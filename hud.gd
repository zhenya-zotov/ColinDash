extends CanvasLayer

signal start_game

var game_running = false

func update_score(value):
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	$MarginContainer/Time.text = str(value)
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()
	
func show_game_over():
	game_running = false
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coint Dash!"
	$Message.show()

func start_game_signal():
	if game_running:  # Если игра уже запущена, ничего не делаем
		return
	
	game_running = true
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func _on_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	if Input.is_action_just_pressed("start_game"):
		start_game_signal()
	start_game_signal()

func _on_start_game() -> void:
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("start_game"):
		start_game_signal()
