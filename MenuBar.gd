extends Panel

# contains the popup a menu button makes
var fileMenuPopup

# signals to record and record pack to save stuff
signal save

onready var fileMenuButton = $MenuBar/File
onready var aboutButton = $MenuBar/About

func _ready():
	# get the file menu popup and add all the items
	fileMenuPopup = fileMenuButton.get_popup()
	fileMenuPopup.add_item("New") # 0
	fileMenuPopup.add_item("Save") # 1
	fileMenuPopup.add_item("Save As") # 2
	fileMenuPopup.add_item("Compile") # 3
	fileMenuPopup.add_item("Load") # 4
	fileMenuPopup.add_item("Quit") # 5
	# connect to handler function
	fileMenuPopup.connect("id_pressed", self, "_on_fileMenu_id_pressed")

func _on_fileMenu_id_pressed(id):
	if id == 0: # new
		pass
	elif id == 1: # save
		emit_signal("save")
	elif id == 2: # save as
		pass
	elif id == 3: # compile
		pass
	elif id == 4: # load
		pass
	elif id == 5: # quit
		get_tree().quit()
