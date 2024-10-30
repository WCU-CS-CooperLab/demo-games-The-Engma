extends Area2D

func _ready():
	$LifeTime.start()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.startPowerUpTimer()
		queue_free()

func _on_life_time_timeout() -> void:
	queue_free()
