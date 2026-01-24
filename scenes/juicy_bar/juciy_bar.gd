class_name JuciyBar extends Control

@export	var	top_layer_bar:ProgressBar
@export	var	bottom_layer_bar:ProgressBar
@export	var	min_value:float=	0.0
@export	var	max_value:float	=100.0
@export var top_bar_time:float=0.2
var	current_value:float	

func	 _ready():
	pass	#	Replace	with	function	body.

#为了避免再ready中调用的时序问题，所以改用外部调用
func init_value(min_v:float,max_v:float):
	min_value=min_v
	max_value=max_v
	current_value=max_value
	set_progress_bar_default_values(top_layer_bar)
	set_progress_bar_default_values(bottom_layer_bar)

func  set_progress_bar_default_values(bar:ProgressBar):
	bar.min_value=min_value
	bar.max_value=max_value
	bar.value=current_value
	pass

func change_current_value(value:	float):
	current_value=clamp(value,min_value,max_value)
	run_juicy_tween(top_layer_bar,current_value,top_bar_time,0)
	run_juicy_tween(bottom_layer_bar,current_value,0.4,0.1)
	pass

func	run_juicy_tween(bar:	ProgressBar,	value:float,length:float,delay:	float):
	var	tween=get_tree().create_tween()
	tween.tween_property(bar,"value",value,length).set_delay(delay)
	pass
