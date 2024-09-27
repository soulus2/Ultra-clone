extends CharacterBody3D


var movement_speed = 5.0
var jump_speed = 3

@export var walking_velocity:float = 5.0 
@export var sprinting_velocity:float = 10.0 
@export var crouching_velocity:float = 2.5 
@export var gravity:float = 980

@export var mouse_sensitivity:Vector2 = Vector2(0.3,0.3)

var global_delta = 0
var jump_time = 0
var is_jumping = false

enum  MOVEMENT_STATES {IDLE,WALKING,RUNNING,CROUCHING,JUMPING,FALLING}
var movement_state: MOVEMENT_STATES = MOVEMENT_STATES.IDLE


func _process(delta: float) -> void:
	global_delta = delta
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_object_local(Vector3.UP, -event.relative.x * global_delta * mouse_sensitivity.x)
		$Head.rotate_object_local(Vector3.LEFT, event.relative.y * global_delta * mouse_sensitivity.y)
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x, -89.99,89.99)
		

func _physics_process(delta):
	jumping(delta)
	movement(delta)
	state_handler()
	move_and_slide()
func movement(delta):
	if Input.is_action_pressed("crouch"):
		movement_speed = crouching_velocity
		movement_state = MOVEMENT_STATES.CROUCHING
	elif Input.is_action_pressed("sprint"):
		movement_speed = sprinting_velocity
		movement_state = MOVEMENT_STATES.RUNNING
	else:
		movement_speed = walking_velocity
		movement_state = MOVEMENT_STATES.WALKING
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)

func jumping(delta):
	#Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta * delta
		movement_state=MOVEMENT_STATES.FALLING
	if Input.is_action_pressed("jump"):
		velocity.y = jump_speed
		movement_state=MOVEMENT_STATES.JUMPING
			
	if Input.is_action_just_released("jump"):
		is_jumping = false
func state_handler():
	match movement_state:
		MOVEMENT_STATES.WALKING:
			pass
		MOVEMENT_STATES.CROUCHING:
			pass
		MOVEMENT_STATES.RUNNING:
			pass
		MOVEMENT_STATES.JUMPING:
			pass
		MOVEMENT_STATES.FALLING:
			pass
		_:
			pass
	
	
