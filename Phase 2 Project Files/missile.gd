extends Area2D

@export var speed = 250
@export var explosion_area_scene = preload("res://explosion_area.tscn")

var velocity = Vector2.ZERO

func start(_transform):
	transform = _transform
	velocity = transform.x * speed
	
func _process(delta):
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("rocks") or body.is_in_group("bad_rocks"):
		var a = explosion_area_scene.instantiate()
		a.position = position
		get_tree().root.add_child(a)
		queue_free()
		
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		var a = explosion_area_scene.instantiate()
		a.position = position
		get_tree().root.add_child(a)
		queue_free()
