extends CharacterBody3D

@export var DEFAULT_SPEED = 10
@export var  DEFAULT_JUMP_VELOCITY = 10
@export var  DEFAULT_GRAVITY = 20
@export var  DEFAULT_SENSITIVITY = 1

var catMode = false
var camRotate = .6
var score = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$catCollision.disabled = true
	#$catMesh.visible = false
	$catModel.visible = false
	$mouseCollision.disabled = false
	$mouseMesh.visible = true
	$Pivot/SpringArm3D.spring_length = 1.5
	$Pivot/SpringArm3D.rotate_z(camRotate)
	$Pivot/SpringArm3D.position.y -= .5

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * DEFAULT_SENSITIVITY)))
	if Input.is_action_just_pressed("switch") and is_on_floor():
		if not catMode:
			catMode = true
			$catCollision.disabled = false
			#$catMesh.visible = true
			$catModel.visible = true
			$mouseCollision.disabled = true
			$mouseMesh.visible = false
			$Pivot/SpringArm3D.spring_length = 3
			$Pivot/SpringArm3D.rotate_z(-camRotate)
			$Pivot/SpringArm3D.position.y += .5
		else:
			catMode = false
			$catCollision.disabled = true
			#$catMesh.visible = false
			$catModel.visible = false
			$mouseCollision.disabled = false
			$mouseMesh.visible = true
			$Pivot/SpringArm3D.spring_length = 1.5
			$Pivot/SpringArm3D.rotate_z(camRotate)
			$Pivot/SpringArm3D.position.y -= .5

func _increaseScore():
	score += 1

func _physics_process(delta):
	if catMode == true:
		DEFAULT_SPEED = 15
		DEFAULT_JUMP_VELOCITY = 15
	else:
		DEFAULT_SPEED = 5
		DEFAULT_JUMP_VELOCITY = 5
	
	#print(str(score))
	$Control/Label.text = str(score)
	
	# Add the DEFAULT_GRAVITY.
	if not is_on_floor():
		velocity.y -= DEFAULT_GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = DEFAULT_JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("back", "forward", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = direction.x * DEFAULT_SPEED
			velocity.z = direction.z * DEFAULT_SPEED
			if catMode:
				$catModel/AnimationPlayer.play("ArmatureAction")
			else:
				$catModel/AnimationPlayer.stop
		else:
			velocity.x = direction.x * DEFAULT_SPEED * .5
			velocity.z = direction.z * DEFAULT_SPEED * .5
	else:
		var startingXVel = velocity.x
		var startingZVel = velocity.z
		velocity.x = move_toward(velocity.x, startingXVel/2, DEFAULT_SPEED*.5)
		velocity.z = move_toward(velocity.z, startingZVel/2, DEFAULT_SPEED*.5)

	move_and_slide()
