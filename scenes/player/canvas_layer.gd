extends CanvasLayer

@onready var player:Player=get_parent()
@onready var hp_bar: JuciyBar = %HPBar
@onready var hp_value:RichTextLabel = %HPValue



func _ready() -> void:

	#初始化生命值的UI和信号连接
	_init_health_ui()
	pass # Replace with function body.

func _init_health_ui():
	player.stat.health_changed.connect(_health_change)

#当生命值改变时触发此函数
func _health_change(current_h:float,_changed_hp:float,max_h:float):
	hp_bar.change_current_value(current_h)
	hp_value.text="[color=orange]"+str(int(current_h))+"[/color]"+\
	"/"+"[color=red]"+str(int(max_h))+"[/color]"
					
