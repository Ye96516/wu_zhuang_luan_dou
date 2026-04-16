extends StateBase

const 死亡音效 = preload("uid://c3fll78wm84ag")

func enter():
	%HitPlayer.enabled=false
	anp.play("death")
	AudioPlayer.play(死亡音效)
	pass
