extends Node2D

@export var playtime = 30
@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene : PackedScene

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		spawn_cactus()
		$PowerupTimer.start(randf_range(5, 15))

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	spawn_cactus()
	spawn_coins()
	
func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		
		# Получаем размер монеты (диаметр = 2 * радиус)
		var coin_radius = c.get_node("CollisionShape2D").shape.radius
		var coin_size = coin_radius * 2  # Полный размер монеты

		# Генерируем случайную позицию внутри границ экрана
		var pos_x = randi_range(coin_size / 2, screensize.x - coin_size / 2)
		var pos_y = randi_range(coin_size / 2, screensize.y - coin_size / 2)
		
		c.position = Vector2(pos_x, pos_y)

func spawn_cactus():
	for i in level + 2:
		var cactus = cactus_scene.instantiate()
		add_child(cactus)
		cactus.screensize = screensize

		# Получаем узел CollisionShape2D
		var shape = cactus.get_node("CollisionShape2D").shape

		# Определяем размер в зависимости от типа коллизии
		var cactus_size = Vector2.ZERO
		if shape is RectangleShape2D:
			cactus_size = shape.size
		elif shape is CircleShape2D:
			cactus_size = Vector2(shape.radius * 2, shape.radius * 2)

		# Генерируем случайную позицию внутри границ экрана
		var pos_x = randi_range(cactus_size.x / 2, screensize.x - cactus_size.x / 2)
		var pos_y = randi_range(cactus_size.y / 2, screensize.y - cactus_size.y / 2)

		cactus.position = Vector2(pos_x, pos_y)


func game_over():
	playing = false
	$GameTimer.stop()
	$EndSound.play()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$HUD.show_game_over()
	$Player.die()
		
func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

	
func _on_hud_start_game():
	new_game()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
