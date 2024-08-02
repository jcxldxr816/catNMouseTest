extends CharacterBody3D

@export var DEFAULT_SPEED = 15
@export var  DEFAULT_JUMP_VELOCITY = 15
@export var  DEFAULT_GRAVITY = 20
@export var  DEFAULT_SENSITIVITY = .7

@onready var storedSpeed = DEFAULT_SPEED
@onready var storedJumpVel = DEFAULT_JUMP_VELOCITY
@onready var storedGravity = DEFAULT_GRAVITY
@onready var storedSens = DEFAULT_SENSITIVITY

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * DEFAULT_SENSITIVITY)))
		
		$Pivot.rotate_x(deg_to_rad(event.relative.y * DEFAULT_SENSITIVITY))
		$Pivot.rotation.x = clamp($Pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	
	# Add the DEFAULT_GRAVITY.
	if not is_on_floor():
		velocity.y -= DEFAULT_GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and not Input.is_action_pressed("shift") and is_on_floor() and DEFAULT_GRAVITY != 0:
		velocity.y = DEFAULT_JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_up"):
		if $jumpLocation.position.y <= 4:
			$jumpLocation.position.y += 1
	if Input.is_action_just_pressed("ui_down"):
		if $jumpLocation.position.y >= 1:
			$jumpLocation.position.y -= 1
	
	if Input.is_action_pressed("shift") and Input.is_action_just_pressed("jump") and DEFAULT_GRAVITY != 0 and is_on_floor():
		self.global_transform = $jumpLocation.global_transform
		
		#self.position.move_toward($jumpLocation.global_position, 3)
		#self.position.y -= .25


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("right", "left", "back", "forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and DEFAULT_GRAVITY != 0:
		if is_on_floor():
			velocity.x = direction.x * DEFAULT_SPEED
			velocity.z = direction.z * DEFAULT_SPEED
			$catMesh/AnimationPlayer.play("ArmatureAction")
		else:
			velocity.x = direction.x * DEFAULT_SPEED * .5
			velocity.z = direction.z * DEFAULT_SPEED * .5
	else:
		var startingXVel = velocity.x
		var startingZVel = velocity.z
		velocity.x = move_toward(velocity.x, startingXVel/2, DEFAULT_SPEED*.5)
		velocity.z = move_toward(velocity.z, startingZVel/2, DEFAULT_SPEED*.5)

	move_and_slide()
