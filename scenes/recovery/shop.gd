extends AnimatedSprite2D

@onready var button_rectangle_line: Sprite2D = $ButtonRectangleLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_rectangle_line.visible=false
	var t:Tween=get_tree().create_tween().set_loops()
	t.tween_property(button_rectangle_line,"position",Vector2(23,20),2)
	t.tween_property(button_rectangle_line,"position",Vector2(23,25),2)
	
	pass # Replace with function body.


func _on_shop_body_entered(body: Node2D) -> void:
	if body is Player:
		button_rectangle_line.visible=true
		pass
	pass # Replace with function body.
