extends Camera2D

const speed:=100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x+=speed*delta
	pass
