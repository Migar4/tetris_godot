extends TextEdit

func _ready():
	$Score.text = str(Global.score)
	Global.score = 0
