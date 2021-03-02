extends Panel

# contains the popup a menu button makes
var fileMenuPopup
var editMenuPopup
var recordSwapPanel
var recordPack

signal new(data)
signal save
signal compile
signal loadFile

onready var fileMenuButton = $MenuBar/File
onready var editMenuButton = $MenuBar/Edit
onready var aboutButton = $MenuBar/About
onready var main = $".."

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
	
	# get the edit menu popup and add all the items
	editMenuPopup = editMenuButton.get_popup()
	editMenuPopup.add_item("Swap two records") # 0
	editMenuPopup.add_item("Change all artists") # 1
	editMenuPopup.add_item("Change all sources") # 2
	# connect to handler function
	editMenuPopup.connect("id_pressed", self, "_on_editMenu_id_pressed")

func _on_fileMenu_id_pressed(id):
	if id == 0: # new
		emit_signal("new", 0)
	elif id == 1: # save
		emit_signal("save")
	elif id == 2: # compile
		emit_signal("compile")
	elif id == 3: # load
		emit_signal("loadFile")
	elif id == 4: # quit
		get_tree().quit()

func _on_editMenu_id_pressed(id):
	if id == 0:
		swap_records()
	elif id == 1:
		pass
	elif id == 2:
		pass

func swap_records():
	recordSwapPanel = load("res://RecordSwapPanel.tscn")
	recordSwapPanel = recordSwapPanel.instance()
	add_child(recordSwapPanel)
	recordSwapPanel.show_modal(true)
	var goButton = recordSwapPanel.get_node("CenterContainer/VBoxContainer/GoButton")
	goButton.connect("pressed", self, "_on_swap_goPressed")

func _on_swap_goPressed():
	var record1 = recordSwapPanel.get_node("CenterContainer/VBoxContainer/RecordLists/Record1").text
	var record2 = recordSwapPanel.get_node("CenterContainer/VBoxContainer/RecordLists/Record2").text
	var recordPack = main.recordPack
	recordPack.updateRecordList()
	# so, get data1 from record1, then put that in record 2's spot and vice versa
	var data1 = recordPack.recordList[record1]
	var data2 = recordPack.recordList[record2]
	recordPack.recordList[record1] = data2
	recordPack.recordList[record2] = data1
	recordPack.updateRecordObjs()
	recordSwapPanel.queue_free()
