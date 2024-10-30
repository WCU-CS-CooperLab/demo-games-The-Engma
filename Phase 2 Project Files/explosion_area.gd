extends Area2D

@export var size = Vector2(10, 10)
@export var playerDamage = 75
@export var enemyDamage = 10

var canDamage = true

func _ready():
	$CollisionShape2D.set_scale(size)
	$LifeTime.start()
	
func explode():
	$Explosion/AnimationPlayer.play("explosion")
	await $Explosion/AnimationPlayer.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocks") and canDamage:
		body.killedByMissile = true
		body.explode()
	if body.is_in_group("bad_rocks") and canDamage:
		body.explode()
	if body.name == "player" and canDamage:
		body.shield -= playerDamage
	explode()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and canDamage:
		area.take_damage(enemyDamage)
	explode()

func _on_life_time_timeout() -> void:
	explode()
	canDamage = false
