extends Node

var level = 0
var score = 0
var playing = false
var screensize = Vector2.ZERO

@export var rock_scene : PackedScene
@export var enemy_scene : PackedScene

func _ready():
	screensize = get_viewport().get_visible_rect().size
	for i in 3:
		spawn_rock(3)
		
func spawn_rock(size, pos=null, vel=null):
	if pos == null:
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	r.exploded.connect(self._on_rock_exploded)
		
	 
func _on_rock_exploded(size, radius, pos, vel):
	$ExplosionSound.play()
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size - 1, newpos, newvel)
		
func new_game():
	# remove any old rocks from previous game
	get_tree().call_group("rocks", "queue_free")
	level = 0
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$player.reset()
	$Music.play()
	await $HUD/Timer.timeout
	playing = true
	
func new_level():
	level += 1
	$HUD.show_message("Wave %s" % level)
	for i in level:
		spawn_rock(3)
	$EnemyTimer.start(randf_range(5, 10))
		
func _process(delta):
	if not playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		new_level()
		
func game_over():
	playing = false
	$HUD.game_over()
	$Music.stop()
	
func _input(event):
	if event.is_action_pressed("pause"):
		if not playing:
			return
		get_tree().paused = not get_tree().paused
		var message = $HUD/VBoxContainer/Message
		if get_tree().paused:
			message.text = "Paused"
			message.show()
		else:
			message.text = ""
			message.hide()

func _on_enemy_timer_timeout():
	var e = enemy_scene.instantiate()
	add_child(e)
	e.target = $player
	$EnemyTimer.start(randf_range(20, 40))
