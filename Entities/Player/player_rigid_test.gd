extends RigidBody3D

@export var jump_velocity:float = 10
@export var drop_velocity:float = 10
@export var dash_velocity:float = 10

@export var acceleration:float = 5
var accel_multiplier:float = 1.0
@export var walking_speed:float = 15
@export var sprint_speed:float = 25
@export var crouching_speed:float = 10
@export var max_speed:float = 60

var speed:float = walking_speed

#@export_range(0.01,1.0) var stop_speed:float = 0.1

@export var fov_acceleration:float = .1
@export var walking_fov:float = 90.0
@export var crouching_fov:float = 75.0
@export var sprinting_fov:float = 120.0

var velocity=Vector3()

var mouse_input = Vector2()
@onready var head = $Head
@onready var eyes = $Head/Camera
#@onready var body = $Body
@onready var feet = $Feet
@export var view_sensitivity:Vector2 = Vector2(30,30)
var is_on_floor = false
var move_input:Vector2

var physics_mat = load("res://Entities/Player/player_physics_material.tres")
var friction = physics_mat.friction
var global_delta = 0
func _ready():
	linear_damp = 1.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _physics_process(delta):
	global_delta = delta
	
	if 0.001 > linear_velocity.x and linear_velocity.x > -0.001:
		linear_velocity.x=0
	if 0.001 > linear_velocity.y and linear_velocity.y > -0.001:
		linear_velocity.y=0
	if 0.001 > linear_velocity.z and linear_velocity.z > -0.001:
		linear_velocity.z=0
	# Change player movement speed according to player input
	if Input.is_action_pressed("crouch"):
		if linear_velocity != Vector3(0,0,0):
			eyes.fov = lerp(eyes.fov,crouching_fov,fov_acceleration)
		speed=crouching_speed
	elif Input.is_action_pressed("sprint"):
		if linear_velocity != Vector3(0,0,0):
			eyes.fov = lerp(eyes.fov,sprinting_fov,fov_acceleration)
		speed=sprint_speed
	else:
		if linear_velocity != Vector3(0,0,0):
			eyes.fov = lerp(eyes.fov,walking_fov,fov_acceleration)
		speed=walking_speed
	
	# Reset friction to zero to avoid sticking to walk when velocity is applied
	if friction >= 0: friction = 0
	is_on_floor = false
	move_input = Vector2.ZERO
	var dir = Vector3()
	# Handle movement input
	move_input = Input.get_vector("move_left","move_right","move_backward","move_forward")
	dir += move_input.x*head.global_transform.basis.x
	dir -= move_input.y*head.global_transform.basis.z
	velocity = lerp(velocity,dir*speed*10,acceleration*10*accel_multiplier*delta)
	
	apply_central_force(velocity)
	# Ground check and jumping 
	if feet.is_colliding():
		is_on_floor = true
		friction = 1.0
		accel_multiplier = 1.0
		
	if Input.is_action_just_pressed("crouch") and !is_on_floor:
			apply_central_impulse(Vector3.DOWN * drop_velocity*10)
	if Input.is_action_just_pressed("jump") and is_on_floor:
		accel_multiplier = 0.1
		is_on_floor = false
		apply_central_impulse(Vector3.UP * jump_velocity*10)
	
	if Input.is_action_just_pressed("dash"):
		apply_central_impulse(-head.global_transform.basis.z * dash_velocity*10)
	

func _integrate_forces(state):
	# Limit linear velocity to max_speed*10
	if state.linear_velocity.length()>max_speed*10:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed*10
		
	#artificial stopping movement i.e not using physics
	#if move_input.length() < 0.2:
		#state.linear_velocity.x = lerp(state.linear_velocity.x,0.0,stop_speed*10)
		#state.linear_velocity.z = lerp(state.linear_velocity.z,0.0,stop_speed*10)
		
	# Push against floor to avoid sliding on "unreasonable" slopes
	if state.get_contact_count() > 0 and move_input.length()< 0.2:
		if is_on_floor and state.get_contact_local_normal(0).y < 0.9:
			apply_central_force(-state.get_contact_local_normal(0)*10)

func _input(event):
	# Handle mouse input
	if event is InputEventMouseMotion:
	# Handle view and rotation
		eyes.rotation_degrees.x -= event.relative.y * view_sensitivity.x * global_delta
		eyes.rotation_degrees.x = clamp(eyes.rotation_degrees.x,-80,80)
		head.rotation_degrees.y -= event.relative.x * view_sensitivity.y * global_delta
		mouse_input =Vector2.ZERO
	
