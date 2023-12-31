extends Control

@export var Address = "127.0.0.1" # "192.168.1.2"
@export var port = 8910
var peer: ENetMultiplayerPeer
var server_available = false
var isHeadless = false
var currentPlayers = 0
var maxPlayers = 2
var isStarted = false



# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(server_connected)
	multiplayer.connection_failed.connect(connection_failed)
	$HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/JoinIP.text = Address + ":" + str(port)
	if "--server" in OS.get_cmdline_args():
		isHeadless = true
		create_server()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ipText = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/JoinIP.text
	var label = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/NameLabel2
	var parts = ipText.split(":")
	if parts.size() != 2:
		label.text = "Servidor [ ip:puerto ]" + "(Invalido)"
		return
	Address = parts[0]
	port = int(parts[1])

@rpc("any_peer", "call_remote")
func disconnectPeer():
	print("Dropped peer")
	multiplayer.multiplayer_peer = null

# Called from server and clients
func player_connected(id):
	if multiplayer.is_server():
		if currentPlayers >= maxPlayers || isStarted:
			disconnectPeer.rpc_id(id)
			print("Rejected Connection")
			return
	print("Player Connected " + str(id))

# Called from server and clients
func player_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
	
# Called only from clients
func server_connected():
	print("Server Connected")
	SendPlayerInformation.rpc_id(1, $HBoxContainer/VBoxContainer/MarginContainer/LineEdit.text, multiplayer.get_unique_id())

# Called only from clients
func connection_failed():
	print("Failed to Connect")
	
	
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		print(name + " has joined")
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://game_components/scenes/start_secuence/start_secuence.tscn").instantiate()
	get_tree().root.add_child(scene)
	var audio_node = get_node("AudioStreamPlayer")
	remove_child(audio_node)
	scene.add_child(audio_node)
	self.hide()

func _on_host_button_down():
	create_server()
	SendPlayerInformation($HBoxContainer/VBoxContainer/MarginContainer/LineEdit.text, multiplayer.get_unique_id())
	server_available = true

func create_server():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	$"HBoxContainer/VBoxContainer/IP label".text = "Pasale estos datos al otro jugador:\nIp: " + "Usa tu ip local\n(busca en google como conseguir\nla ip para jugar en lan)\n" + "Puerto: " + str(port)
	$"HBoxContainer/VBoxContainer/IP label".visible = true
	$HBoxContainer/VBoxContainer/Host.disabled = true
	$HBoxContainer/VBoxContainer/PanelContainer.visible = false
	$HBoxContainer/VBoxContainer/NameLabel.visible = false
	$HBoxContainer/VBoxContainer/MarginContainer/LineEdit.editable = false
	$HBoxContainer/VBoxContainer/MarginContainer/LineEdit.visible = false
	$HBoxContainer/VBoxContainer/StartGame.visible = true
	print("Waiting for Players!")
	
	

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(Address, port)
	if error:
		return error
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	server_available = true
	$HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/Join.disabled = true
	$HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/JoinIP.editable = false
	$HBoxContainer/VBoxContainer/Host.visible = false
	$HBoxContainer/VBoxContainer/NameLabel.visible = false
	$HBoxContainer/VBoxContainer/MarginContainer/LineEdit.editable = false
	$HBoxContainer/VBoxContainer/MarginContainer/LineEdit.visible = false
	$HBoxContainer/VBoxContainer/StartGame.visible = true
	print("Joined")


func _on_start_game_button_down():
	if !server_available:
		create_server()
		SendPlayerInformation($HBoxContainer/VBoxContainer/MarginContainer/LineEdit.text, multiplayer.get_unique_id())
	StartGame.rpc()
	pass # Replace with function body.

func getLocalIp():
	var IPs = IP.get_local_addresses()
	for ip in IPs:
		var parts = ip.split(".")
		if parts.size() == 4:
			if ip == "127.0.0.1":
				continue
			if parts[0] == "169":
				continue
			return ip


func _on_back_button_down():
	disconnectPeer()
	var scene = load("res://game_components/scenes/MainMenu/main_menu.tscn").instantiate()
	get_tree().root.add_child(scene)
	var audio_node = get_node("AudioStreamPlayer")
	remove_child(audio_node)
	scene.add_child(audio_node)
	self.queue_free()
