extends Node

var session_file = "user://session.json"
var use_ssl = true

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_SignInButton_pressed():
	var headers = ["Content-Type: application/json"]
	var home_server = get_node("HomeserverUrlInput").text
	var user = get_node("UsernameInput").text
	var password = get_node("PasswordInput").text.replace('"', '\"')
	var device_display_name = "MediaPlay Metaverse " + "(" + OS.get_name() + ")"
	
	var json_request = '{"identifier": {"type": "m.id.user", "user": ' + user + '}, "initial_device_display_name": ' + device_display_name + ', "password": ' + password + ', "type": "m.login.password"}'
	var url = home_server + "/_matrix/client/r0/login"
	
	# $HTTPRequest.request(home_server + "/_matrix/client/versions")
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, json_request)
	
	get_node("Notice").text = "Logging in..."
	
func _on_request_completed(result, response_code, headers, body):
	var file = File.new()
	
	if response_code == 200 or HTTPClient.RESPONSE_OK:
		
		get_node("Notice").text = "Storing session data..."
		file.open(session_file, File.WRITE)
		file.store_var(body)
		get_node("Notice").text = "Stored session data!"
		
		file.close()
		
		print(body)
		
		
		emit_signal("sync")
	elif response_code == 403 or HTTPClient.RESPONSE_FORBIDDEN:
		get_node("Notice").text = "Sorry, can't log in!"
	elif response_code == 429 or HTTPClient.RESPONSE_TOO_MANY_REQUESTS:
		get_node("Notice").text = "Sorry, too many requests. Try again later?"
	else:
		get_node("Notice").text = "Hmm?"
