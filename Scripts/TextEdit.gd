extends TextEdit

func _ready():
	pass

func _process(delta):
	$Number.text = str(Global.score)