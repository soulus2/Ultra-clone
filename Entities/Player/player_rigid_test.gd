extends RigidBody3D

@export_category("Vertical movement")
@export var jump_velocity:float = 10
@export var drop_velocity:float = 10
@export var max_wall_jumps:int = 3

@export_category("Horizontal movement")
@export var max_speed:float = 60
@export var speed:float = 35
@export var dash_velocity:float = 100
@export var acceleration:float = 5
@export var accel_multiplier:float = 1.0

@export_category("Camera")
@export var fov_acceleration:float = .1
@export var view_sensitivity:Vector2 = Vector2(20,20)
@export var joy_view_sensitivity:Vector2 = Vector2(50,50)

@export_category("Other")
@export var physics_mat:PhysicsMaterial = load("res://Entities/Player/player_physics_material.tres")

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var ground_cast = $Ground_cast
@onready var wall_cast = $Wall_cast


var is_on_floor = false
var is_on_wall = false
var move_input:Vector2
var velocity:Vector3 = Vector3()
var mouse_input:Vector2 = Vector2()
var friction:float = physics_mat.friction
var dir:Vector3 = Vector3()
var wall_normal:Vector3 = Vector3()
var wall_jumps:int = max_wall_jumps

func _ready():
	linear_damp = 1.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	Look_with_controller()
	is_on_floor = false
	move_input = Vector2.ZERO
	dir = Vector3.ZERO
	# Ground check and jumping 
	if ground_cast.is_colliding():
		is_on_floor = true
		friction = 1.0
		accel_multiplier = 1.0
		wall_jumps = max_speed
		
	if wall_cast.is_colliding():
		is_on_wall = true
		wall_normal = wall_cast.get_collision_normal(0)
		
	else:
		is_on_wall = false
		wall_normal = Vector3(0,0,0)
		
	if 0.001 > linear_velocity.x and linear_velocity.x > -0.001:
		linear_velocity.x=0
	if 0.001 > linear_velocity.y and linear_velocity.y > -0.001:
		linear_velocity.y=0
	if 0.001 > linear_velocity.z and linear_velocity.z > -0.001:
		linear_velocity.z=0
		
	
	# Reset friction to zero to avoid sticking to walk when velocity is applied
	if friction >= 0: friction = 0
	
	
	# Handle movement input
	move_input = Input.get_vector("move_left","move_right","move_backward","move_forward")
	dir += move_input.x*head.global_transform.basis.x
	dir -= move_input.y*head.global_transform.basis.z
	if dir.dot(wall_normal)<0:
		dir = get_normal_slide_V3(dir,wall_normal)
	velocity = lerp(velocity,dir*speed*10,acceleration*10*accel_multiplier*delta)
	
	apply_central_force(velocity)
		
	if Input.is_action_just_pressed("drop") and !is_on_floor:
			apply_central_impulse(Vector3.DOWN * drop_velocity*10)
	if Input.is_action_just_pressed("jump") :
		if is_on_floor:
			accel_multiplier = 0.1
			is_on_floor = false
			apply_central_impulse(Vector3.UP * jump_velocity*10)
		if is_on_wall && wall_jumps>0:
			wall_jumps-=1;
			accel_multiplier = 0.1
			is_on_wall = false
			apply_central_impulse(wall_normal * jump_velocity*10)
	
	if Input.is_action_just_pressed("dash"):
		apply_central_impulse(-head.global_transform.basis.z * dash_velocity)
	

func _integrate_forces(state):
	# Limit linear velocity to max_speed
	if state.linear_velocity.length()>max_speed*10:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed*10
		
	# Push against floor to avoid sliding on "unreasonable" slopes
	if state.get_contact_count() > 0 and move_input.length()< 0.2:
		if is_on_floor and state.get_contact_local_normal(0).y < 0.9:
			apply_central_force(-state.get_contact_local_normal(0)*10)

func _input(event):
	# Handle mouse input
	if event is InputEventMouseMotion:
	# Handle view and rotation
		camera.rotation_degrees.x -= event.relative.y * view_sensitivity.x * get_physics_process_delta_time()
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-89,89)
		head.rotation_degrees.y -= event.relative.x * view_sensitivity.y * get_physics_process_delta_time()
		mouse_input = Vector2.ZERO


func Look_with_controller():
	var look_dir = Input.get_vector("look_left","look_right","look_up","look_down")
	camera.rotation_degrees.x -= look_dir.y * joy_view_sensitivity.x *2 * get_physics_process_delta_time()
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,-89,89)
	head.rotation_degrees.y -= look_dir.x * joy_view_sensitivity.y *2 * get_physics_process_delta_time()
	mouse_input = Vector2.ZERO
	
func get_normal_slide_V3(a:Vector3,b:Vector3):
	return a-(a.dot(b))*b
