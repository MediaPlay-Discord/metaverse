extends Node

var user_profile_file = "user://user.json"
var session_file = "user://session.json"
var file = File.new()

func _ready():

	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_MatrixSignIn_sync():
	var home_server = get_node("HomeserverUrlInput").text
	var user = get_node("UsernameInput").text
	
	$HTTPRequest.request(home_server + "/_matrix/client/r0/profile/" + user)

func _on_request_completed(result, response_code, headers, body):
	file.open(user_profile_file, File.WRITE)
	file.store_var(body)
	file.close()
	
	# ...and then supply the display name and avatar to the UI
	
#	if file.file_exists(session_file):
#		file.open(session_file, File.READ)
#		var session = file.get_var(result)
#		file.close()
