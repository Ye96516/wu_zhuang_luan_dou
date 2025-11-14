extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var a=StatBuff.new(Stats.BuffableStats.current_max_health,100,StatBuff.BuffType.add)
		body.stat.add_buff(a)
	pass # Replace with function body.
