extends Control

const PORT = 3020

@export var database_file_path = "res://network/UserDatabase.json"
@export_file("*.tscn") var game_scene_path = "res://Levels/field.tscn"
@export var player_scene : PackedScene

var peer = ENetMultiplayerPeer.new()
var database = {}
var logged_users = {}

func _add_player_to_game(id: int):
	var player_to_add = player_scene.instantiate()
	player_to_add.name = str(id)
	player_to_add.player_id = id
	
	$Player.add_child(player_to_add, true)

func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	load_database()


func load_database(path_to_database_file = database_file_path):
	var file = FileAccess.open(path_to_database_file, FileAccess.READ)
	var file_content = file.get_as_text()
	database = JSON.parse_string(file_content)


@rpc("any_peer", "call_remote")
func authenticate_player(user, password):
	var peer_id = multiplayer.get_remote_sender_id()
	
	if not user in database:
		rpc_id(peer_id, "authentication_failed", "User doesn't exist")
	elif not database[user]['password'] == password:
		rpc_id(peer_id, "authentication_failed", "Password doesn't match")
	elif user in logged_users:
		rpc_id(peer_id, "authentication_failed", "User is already logged")
	elif database[user]['password'] == password:
		var token = randi()
		logged_users[user] = token
		rpc_id(peer_id, "authentication_succeed", token)
		rpc("clear_logged_players")
		for logged_user in logged_users.keys():
			rpc("add_logged_player", database[logged_user]['name'])


@rpc("any_peer", "call_remote")
func start_game():
	rpc("start_game")
	get_tree().change_scene_to_file(game_scene_path)

@rpc
func authentication_failed(error_message):
	pass


@rpc
func authentication_succeed(session_token):
	pass


@rpc
func add_logged_player(player_name):
	pass


@rpc
func clear_logged_players():
	pass
