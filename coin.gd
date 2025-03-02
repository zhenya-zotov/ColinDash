extends Area2D

var screensize = Vector2.ZERO

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "medulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()
	
func _ready() -> void:
	$Timer.start(randf_range(3, 8))


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		var coin_radius = $CollisionShape2D.shape.radius
		var coin_size = coin_radius * 2  # Полный размер монеты

		var new_x = randf_range(coin_size / 2, screensize.x - coin_size / 2)
		var new_y = randf_range(coin_size / 2, screensize.y - coin_size / 2)

		position = Vector2(new_x, new_y)
