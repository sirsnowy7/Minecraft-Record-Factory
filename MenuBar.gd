extends Panel

# contains the popup a menu button makes
var fileMenuPopup

signal save
signal compile
signal loadFile

onready var fileMenuButton = $MenuBar/File
onready var aboutButton = $MenuBar/About

func _ready():
	# get the file menu popup and add all the items
	fileMenuPopup = fileMenuButton.get_popup()
	fileMenuPopup.add_item("New") # 0
	fileMenuPopup.add_item("Save") # 1
	fileMenuPopup.add_item("Compile") # 2
	fileMenuPopup.add_item("Load") # 3
	fileMenuPopup.add_item("Quit") # 4
	# connect to handler function
	fileMenuPopup.connect("id_pressed", self, "_on_fileMenu_id_pressed")

func _on_fileMenu_id_pressed(id):
	if id == 0: # new
		pass
	elif id == 1: # save
		emit_signal("save")
	elif id == 2: # compile
		emit_signal("compile")
	elif id == 3: # load
		emit_signal("loadFile")
	elif id == 4: # quit
		get_tree().quit()
