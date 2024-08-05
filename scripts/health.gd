extends Node3D

#@onready var enteredAlr = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	#$healthArea3D/CollisionShape3D.disabled = false
	$healthArea3D/CollisionShape3D.set_deferred("disabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_health_area_3d_body_entered(body):
	self.visible = false
	#$healthArea3D/CollisionShape3D.disabled = true
	$healthArea3D/CollisionShape3D.set_deferred("disabled", true)
	#print("picked up health")
	
	var world = self.get_parent()
	#print(str(world.get_path()))
	world._healthFunction()
