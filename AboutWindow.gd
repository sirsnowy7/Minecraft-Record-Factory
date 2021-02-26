extends WindowDialog

func _ready():
	pass

# when about button on menu bar pressed make it visible
# this is so nice and elegant because it has no effect if you do it twice
func _on_aboutButton_pressed():
	visible = true


func _on_Github_pressed():
	OS.shell_open("https://github.com/sirsnowy7/Minecraft-Record-Factory")


func _on_Instagram_pressed():
	OS.shell_open("https://www.instagram.com/sirsnowy7/")
