extends RigidBody3D

var defultMat = preload("res://ballMats/ballDefult.tres")
var bouncyMat = preload("res://ballMats/ballBouncy.tres")
var gravityMat = preload("res://ballMats/ballGravity.tres")
var antiGravityMat = preload("res://ballMats/ballAntiGravity.tres")


var bouncyPhys = preload("res://ballPhysicsMats/ballBouncyPhysics.tres")
var defultPhys = preload("res://ballPhysicsMats/ballDefultPhysics.tres")

var superPower = false

signal stopped

func shoot(angle, power):
	var force = -angle
	var powerScaled = 0
	if superPower:
		powerScaled = 2 * (power / 2.5)
	else:
		powerScaled = 2 * (power / 5)
	apply_central_impulse(force * powerScaled)
	
func _integrate_forces(state):
	if state.linear_velocity.length() < 0.1:
		stopped.emit()
		state.linear_velocity = Vector3.ZERO
	if position.y < -20:
		get_tree().reload_current_scene()
	
func changeToBouncy():
	$ballMesh.set_surface_override_material(0, bouncyMat)
	set_physics_material_override(bouncyPhys)
	set_linear_damp(0.5)
	set_angular_damp(0.5)
	set_gravity_scale(0.0)
	superPower = true

	
func changeToGravity():
	$ballMesh.set_surface_override_material(0, gravityMat)
	set_physics_material_override(defultPhys)
	set_linear_damp(3)
	set_angular_damp(3)
	set_gravity_scale(5.0)
	superPower = false
	
func changeToDefult():
	$ballMesh.set_surface_override_material(0, defultMat)
	set_physics_material_override(defultPhys)
	set_linear_damp(0.5)
	set_angular_damp(1)
	set_gravity_scale(0.25)
	superPower = false
	
func changeToAntiGravity():
	$ballMesh.set_surface_override_material(0, antiGravityMat)
	set_physics_material_override(defultPhys)
	set_linear_damp(0.5)
	set_angular_damp(1)
	set_gravity_scale(-0.25)
	superPower = false
