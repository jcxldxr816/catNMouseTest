extends Node

@onready var cheeseArea = $cheese/Area3D
@onready var cat = $cat
@onready var mouse = $mouse
@onready var catCam = $cat/Pivot/SpringArm3D/Camera3D
@onready var mouseCam = $mouse/Pivot/SpringArm3D/Camera3D

@onready var mouseActive = true
@onready var grounded = false
@onready var score = 0
@onready var catEntryEligible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	catCam.current = false
	mouseCam.current = true
	cat.visible = false
	mouse.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("switch") and grounded:
		if mouseActive and catEntryEligible: #mouse -> cat
			mouseActive = false
			catEntryEligible = false
			
			mouse.visible = false
			cat.visible = true
			catCam.current = true
			mouseCam.current = false
			$catEntryArea.visible = false
			
		else: #cat -> mouse
			mouseActive = true
			catEntryEligible = false
			
			mouse.visible = true
			cat.visible = false
			$catEntryArea.global_transform = cat.global_transform
			catCam.current = false
			mouseCam.current = true
			$catEntryArea.visible = true
			
	if mouseActive:
		if mouse.is_on_floor():
			grounded = true
		else:
			grounded = false
	else:
		if cat.is_on_floor():
			grounded = true
		else:
			grounded = false

#func _scoreIncrease():
	#score += 1
	#$Control/Label.text = str(score)
	

func _on_cat_entry_area_body_entered(body):
	if body.get_name() == "mouse":
		catEntryEligible = true
		print("cat entry available")


func _on_cat_entry_area_body_exited(body):
	if body.get_name() == "mouse":
		catEntryEligible = false
		print("cat entry unavailable")
