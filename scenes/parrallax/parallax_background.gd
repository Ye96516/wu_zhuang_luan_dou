@tool
extends Node

@export_enum("绿森林","暗森林") var background:String

func _ready() -> void:
	match background:
		"绿森林":
			_green()
		"暗森林":
			_dark()
	pass # Replace with function body.

func _green():
	$Green.visible=true
	$Dark.visible=false
	
func _dark():
	$Dark.visible=true
	$Green.visible=false
