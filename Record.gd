extends Node

export(String) var songName
export(String) var artist
export(String) var source
export var filePath = ""
export(String) var replaces

# contains the file dialog popup
var fileDialog

# signal save_pack(arr)

onready var songNameInp = $RecordInner/SongName
onready var artistInp = $RecordInner/Artist
onready var sourceInp = $RecordInner/Source
onready var discImg = $RecordInner/DiscMargin/Disc
onready var fileButton = $RecordInner/FileButton

func init(songName, artist, source, filePath, replaces):
	# initialize the node with all starting info
	self.songName = songName
	self.artist = artist
	self.source = source
	self.filePath = filePath
	self.replaces = replaces

func _ready():
	# connect menu bar to this
	var menuBar = get_tree().get_root().get_node("Main/MenuPanel")
	menuBar.connect("save", self, "_on_menuBar_save")
	# shitty way to do this but it works
	songNameInp.connect("text_changed", self, "_on_anyInp_change")
	artistInp.connect("text_changed", self, "_on_anyInp_change")
	sourceInp.connect("text_changed", self, "_on_anyInp_change")

func to_dict():
	# add all the info to a dictionary and then return it for saving
	var dict = {
		"songName": songName,
		"artist": artist,
		"replaces": replaces,
		"source": source,
		"filePath": filePath
	}
	return dict

func to_arr():
	# add all the info to an array and then return also for saving
	var arr = [
		replaces,
		songName,
		artist,
		source,
		filePath
	]
	return arr

func _on_File_button_down():
	# when file select button is clicked instance openfile dialog
	var openFile = load("res://OpenFile.tscn")
	fileDialog = openFile.instance()
	add_child(fileDialog)
	# make it a modal and set up an event for file getting selected
	fileDialog.show_modal(true)
	fileDialog.connect("file_selected", self, "_on_OpenFile_file_selected")

func _on_OpenFile_file_selected(fileSelected):
	# set the filePath var to file selected, as well as button text
	filePath = fileSelected
	fileButton.text = fileSelected

func _on_anyInp_change(delta):
	# anytime input is changed update all member vars
	songName = songNameInp.text
	artist = artistInp.text
	source = sourceInp.text

func _on_menuBar_save():
	# make an array out of this disc, and then send it to record pack
	# var arr = to_arr()
	# emit_signal("save_pack", arr)
	pass
