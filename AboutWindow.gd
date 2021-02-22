extends WindowDialog

func _ready():
	pass

# when about button on menu bar pressed make it visible
# this is so nice and elegant because it has no effect if you do it twice
func _on_aboutButton_pressed():
	visible = true
