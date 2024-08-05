extends Node3D

#@onready var enteredAlr = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	#$cheeseArea3D/CollisionShape3D.disabled = false
	$cheeseArea3D/CollisionShape3D.set_deferred("disabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("cheeseRotate")


func _on_cheese_area_3d_body_entered(body):
	#if not enteredAlr:
		$AnimationPlayer.stop()
		self.visible = false
		#enteredAlr = true
		#$cheeseArea3D/CollisionShape3D.disabled = true
		$cheeseArea3D/CollisionShape3D.set_deferred("disabled", true)
