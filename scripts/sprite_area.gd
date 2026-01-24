@tool
class_name SpriteArea extends Sprite2D

func _ready() -> void:
	if not texture:
		texture=CanvasTexture.new()
	if scale==Vector2(1,1):
		scale=Vector2(20,20)
	if  self_modulate.a==1:
		self_modulate.a=0.3

##返回图形尺寸
func return_rect(type:int=0):
	var gp:Vector2=global_position
	var left_x:float=(gp.x-scale.x/2.0)
	var rihgt_x:float=(gp.x+scale.x/2.0)
	var top_y:float=gp.y-scale.y/2.0
	var bottom_y:float=gp.y+scale.y/2.0
	match type:
		0:
			return [left_x,rihgt_x,top_y,bottom_y]
		1:
			var left_top:Vector2=Vector2(left_x,top_y)
			var left_bottom:Vector2=Vector2(left_x,bottom_y)
			var right_top:Vector2=Vector2(rihgt_x,top_y)
			var right_bottom:Vector2=Vector2(rihgt_x,bottom_y)
			return[left_top,left_bottom,right_top,right_bottom]
	

	
	
