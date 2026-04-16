extends StateBase

@export var player:Player


## 进入状态
func enter() -> void:
	super()
	player.velocity.x=0
	anp.play("atk")
	pass

## 退出状态
func exit() -> void:
	pass

## 渲染帧触发
func process_update(_delta: float) -> void:
	pass

## 物理帧触发
func physical_process_update(_delta: float) -> void:
	#移动
	if player.dir:
		player.velocity.x = player.dir * player.stat.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.stat.speed)
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="atk":
		state_machine.change_state("Idle")
		pass

	pass # Replace with function body.


func _on_atk_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body.is_in_group("enemy"):
		#print("aaaajjjj")
		var atk:StatBuff=StatBuff.new(Stats.BuffableStats.health\
		,-player.stat.current_attack,StatBuff.BuffType.add)
		body.stat.add_buff(atk)
		#print(body.stat.health)
		pass
	pass # Replace with function body.
