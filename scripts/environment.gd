extends Node

@onready var cheeseArea = $cheese/cheeseArea3D
@onready var cat = $cat
@onready var mouse = $mouse
@onready var catCam = $cat/Pivot/SpringArm3D/Camera3D
@onready var mouseCam = $mouse/Pivot/SpringArm3D/Camera3D

@onready var life = 4

@onready var mouseActive = true
@onready var grounded = false
@onready var score = 0
#@onready var cheeseEnteredAlr = false

@onready var catEntryEligible = false
@onready var lastCatYPos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	catCam.current = false
	mouseCam.current = true
	#cat.visible = false
	cat.DEFAULT_GRAVITY = 0
	cat.DEFAULT_JUMP_VELOCITY = 0
	cat.DEFAULT_SENSITIVITY = 0
	cat.DEFAULT_SPEED = 0
	
	mouse.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/lifeLabel.text = ("Life:" + str(life))
	$Control/scoreLabel.text = ("Score:" + str(score))
	$Control/fpsCount.text = str(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("switch") and grounded:
		if mouseActive and catEntryEligible: #mouse -> cat
			mouseActive = false
			catEntryEligible = false
			mouse.visible = false
			#cat.visible = true
			cat.DEFAULT_GRAVITY = cat.storedGravity
			cat.DEFAULT_JUMP_VELOCITY = cat.storedJumpVel
			cat.DEFAULT_SENSITIVITY = cat.storedSens
			cat.DEFAULT_SPEED = cat.storedSpeed
			
			cat.position.y += 1
			$cat/CollisionShape3D.disabled = false
			$mouse/CollisionShape3D.disabled = true
			catCam.current = true
			mouseCam.current = false
			$catEntryArea.visible = false
			
		else: #cat -> mouse
			mouseActive = true
			catEntryEligible = false
			lastCatYPos = cat.position.y
			mouse.visible = true
			#cat.visible = false
			cat.DEFAULT_GRAVITY = 0
			cat.DEFAULT_JUMP_VELOCITY = 0
			cat.DEFAULT_SENSITIVITY = 0
			cat.DEFAULT_SPEED = 0
			
			
			$cat/CollisionShape3D.disabled = true
			$mouse/CollisionShape3D.disabled = false
			$catEntryArea.global_transform = cat.global_transform
			catCam.current = false
			mouseCam.current = true
			$catEntryArea.visible = true
			
	if mouseActive:
		if mouse.is_on_floor():
			grounded = true
		else:
			grounded = false
		cat.position.y = lastCatYPos
	else:
		if cat.is_on_floor():
			grounded = true
		else:
			grounded = false
		mouse.global_transform = cat.global_transform
	

func _on_cat_entry_area_body_entered(body):
	if body.get_name() == "mouse":
		catEntryEligible = true
		#print("cat entry available")


func _on_cat_entry_area_body_exited(body):
	if body.get_name() == "mouse":
		catEntryEligible = false
		#print("cat entry unavailable")


func _on_cheese_area_3d_body_entered(body):
	#if not cheeseEnteredAlr:
		score += 1
		#cheeseEnteredAlr = true




func _on_spike_area_body_entered(body):
	#print("touching spikes")
	#if body.get_class() == "CharacterBody3D":
	if body.get_collision_layer_value(5):
		print("character touched spikes")
		life -= 1
		if life <= 0:
			print("game over")
			get_tree().quit()

	

func _healthFunction():
	print("health picked up")
	if life < 4:
		life += 1
