extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("cheeseRotate")


func _on_area_3d_body_entered(body):
	if self.visible == true:
		body._increaseScore()
	self.visible = false
