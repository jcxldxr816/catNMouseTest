extends CharacterBody3D

@export var DEFAULT_SPEED = 5
@export var  DEFAULT_JUMP_VELOCITY = 5
@export var  DEFAULT_GRAVITY = 20
@export var  DEFAULT_SENSITIVITY = 1

@onready var storedSpeed = DEFAULT_SPEED
@onready var storedJumpVel = DEFAULT_JUMP_VELOCITY
@onready var storedGravity = DEFAULT_GRAVITY
@onready var storedSens = DEFAULT_SENSITIVITY

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * DEFAULT_SENSITIVITY)))

func _physics_process(delta):
	
	# Add the DEFAULT_GRAVITY.
	if not is_on_floor():
		velocity.y -= DEFAULT_GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and self.visible:
		velocity.y = DEFAULT_JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("back", "forward", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and self.visible:
		if is_on_floor():
			velocity.x = direction.x * DEFAULT_SPEED
			velocity.z = direction.z * DEFAULT_SPEED
		else:
			velocity.x = direction.x * DEFAULT_SPEED * .5
			velocity.z = direction.z * DEFAULT_SPEED * .5
	else:
		var startingXVel = velocity.x
		var startingZVel = velocity.z
		velocity.x = move_toward(velocity.x, startingXVel/2, DEFAULT_SPEED*.5)
		velocity.z = move_toward(velocity.z, startingZVel/2, DEFAULT_SPEED*.5)

	move_and_slide()
