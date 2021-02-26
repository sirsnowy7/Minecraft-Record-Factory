extends Node

class_name RecordPack

var fileDialog
var dirDialog

export(String) var packName
export(String) var packAuthor
export(String) var packVer # this is the pack version, not the minecraft version
export(String) var packDesc
export(String) var iconPath = "icon.png"
export(bool) var iconDiscOverlay

signal error(message)
signal newPack(data)

var recordList = { # replaces: [ disc name, artist, source, file path ]
	"13":      ["13", "C418", "", ""],
	"cat":     ["cat", "C418", "", ""],
	"blocks":  ["blocks", "C418", "", ""],
	"chirp":   ["chirp", "C418", "", ""],
	"far":     ["far", "C418", "", ""],
	"mall":    ["mall", "C418", "", ""],
	"mellohi": ["mellohi", "C418", "", ""],
	"stal":    ["stal", "C418", "", ""],
	"strad":   ["strad", "C418", "", ""],
	"ward":    ["ward", "C418", "", ""],
	"11":      ["11", "C418", "", ""],
	"wait":    ["wait", "C418", "", ""],
	"Pigstep": ["Pigstep", "Lena Raine", "", ""]
}

var recordObjects = []

# load the record scene
const RECORD = preload("res://Record.tscn")

onready var recordGrid = $"../MainPanel/RecordScroll/RecordGrid"
onready var metaPanel = $"../MetaPanel"
onready var main = $".."

func fillRecords():
	# clear record grid
	delete_children(recordGrid)
	# loop over the record list
	for r in recordList:
		# create a new record scene instance
		var newRecord = RECORD.instance()
		# this adds the name, artist, source, filepath, and then which song it
		# replaces in the function
		newRecord.init(recordList[r][0], recordList[r][1], recordList[r][2],
		  recordList[r][3], r)
		
		# get the disc image display and change it to the original disc's
		# sprite
		var discImg = newRecord.get_node("RecordInner/DiscMargin/Disc")
		discImg.texture = load("res://images/records/%s.png" % newRecord.replaces)
		# update fields from data
		var nameField = newRecord.get_node("RecordInner/SongName")
		nameField.text = newRecord.songName
		var artistField = newRecord.get_node("RecordInner/Artist")
		artistField.text = newRecord.artist
		var sourceField = newRecord.get_node("RecordInner/Source")
		sourceField.text = newRecord.source
		if not newRecord.filePath == "":
			var fileButton = newRecord.get_node("RecordInner/FileButton")
			fileButton.text = newRecord.filePath
		
		# connect the record to the record pack (old)
		# newRecord.connect("save_pack", self, "_on_savePack")
		# add record to array for later access
		recordObjects.append(newRecord)
		# now we're done adding info, add it to the ui
		recordGrid.add_child(newRecord)

func _ready():
	# connect menubar to here
	var menuBar = get_tree().get_root().get_node("Main/MenuPanel")
	menuBar.connect("save", self, "_on_menuBar_save")
	menuBar.connect("compile", self, "_on_compile")
	menuBar.connect("loadFile", self, "_on_loadFile")

func init(data):
	if typeof(data) == TYPE_INT:
		# fill up the record grid
		fillRecords()
	else:
		# bring back the data!!!!
		# i'm getting stupid lazy and janky with this lmao
		recordList = data["recordList"]
		packName = data["metadata"]["packName"]
		packAuthor = data["metadata"]["packAuthor"]
		packVer = data["metadata"]["packVer"]
		packDesc = data["metadata"]["packDesc"]
		iconPath = data["metadata"]["iconPath"]
		iconDiscOverlay = data["metadata"]["iconDiscOverlay"]
		fillRecords()
		metaPanel.recordPack = self
		metaPanel.nameInp.text = packName
		metaPanel.authorInp.text = packAuthor
		metaPanel.versionInp.text = packVer
		metaPanel.descInp.text = packDesc
		metaPanel.fileButton.text = iconPath
		metaPanel.fileButton.hint_tooltip = iconPath
		metaPanel.overlayTick.pressed = iconDiscOverlay
		metaPanel.changeIcon()

# change recordList to fix records
# i usually try to do object instead of function oriented
# but oh well
func updateRecordList():
	for i in recordObjects:
		var arr = i.to_arr()
		# confusing as all hell but
		# get index by arr [replaces], and change first value in array from the
		# list to second value from arr [name]
		recordList[arr[0]][0] = arr[1]
		recordList[arr[0]][1] = arr[2]
		recordList[arr[0]][2] = arr[3]
		recordList[arr[0]][3] = arr[4]

# return pack as dict
func to_dict():
	var dict = {
		"recordList": recordList,
		"metadata": {
			"packName": packName,
			"packAuthor": packAuthor,
			"packVer": packVer,
			"packDesc": packDesc,
			"iconPath": iconPath,
			"iconDiscOverlay": iconDiscOverlay
		}
	}
	return dict

func _on_savePack(arr): # old
	# again, confusing as all hell but
	# get index by arr [replaces], and change first value in array from the
	# list to second value from arr [name]
	# recordList[arr[0]][0] = arr[1]
	# recordList[arr[0]][1] = arr[2]
	# recordList[arr[0]][2] = arr[3]
	# recordList[arr[0]][3] = arr[4]
	# print(recordList[arr[0]])
	pass

# return a string with save data (make sure to update record list first)
func getSaveStr():
	var dict = to_dict()
	dict = JSON.print(dict, "  ")
	return dict
	
# save a file to user dir
func saveFile(saveStr, fileName):
	var file = File.new()
	var err = file.open("user://%s.json" % fileName, File.WRITE)
	if not err == OK:
		emit_signal("error", "Error saving! Maybe you have invalid characters in your pack name? (Pack Name: %s) Invalid characters include \"/\" on Linux. (Error code: %s)" % [packName, err])
	file.store_string(saveStr)
	file.close()

func _on_loadFile():
	# when file select button is clicked instance openfile dialog
	var openFile = load("res://OpenFile.tscn")
	fileDialog = openFile.instance()
	add_child(fileDialog)
	# make it a modal and set up an event for file getting selected
	fileDialog.show_modal(true)
	fileDialog.access = 1 # user
	fileDialog.current_dir = "user://" # user
	fileDialog.filters = PoolStringArray(["*.json ; JSON save files"])
	fileDialog.connect("file_selected", self, "_on_OpenFile_file_selected")

func _on_OpenFile_file_selected(fileSelected):
	var file = File.new()
	file.open(fileSelected, File.READ)
	var json_result = JSON.parse(file.get_as_text())
	if not json_result.error == OK || typeof(json_result.result) == TYPE_ARRAY:
		emit_signal("error", "Error parsing JSON file. This is probably on me, report it on GitHub.")
		return
	else:
		emit_signal("newPack", json_result.result)

func _on_menuBar_save():
	if packName == "":
		emit_signal("error", "Error: Pack name not provided. Please provide a pack name before saving.")
		print(packName)
		return
	updateRecordList()
	saveFile(getSaveStr(), packName)
	var file = File.new()
	file.open("user://%s.json" % packName, File.READ)

# return 128 by 128 png of icon
# why is this method so clean though :000
func compileIcon():
	var img = Image.new()
	
	# i dont need to do this LOL
	# good practice for later tho
#	if ".jpg" in iconPath:
#		OS.execute("ffmpeg", ["-yi", iconPath, iconPath + ".png"], true)
#		img.load(iconPath + ".png")
#		img.resize(128, 128)
#	else:
#		img.load(iconPath)
#		img.resize(128, 128)
	
	img.load(iconPath)
	img.resize(128, 128)
	img.convert(5)
	
	if iconDiscOverlay:
		var overlay = Image.new()
		overlay.load("stal_shadow.png")
		img.blend_rect(overlay, Rect2(0,0,128,128), Vector2(0,0))
	
	return img

# return a string representing the readme
func compileReadme():
	var text = ""
	
	text += "%s - created by %s\n" % [packName, packAuthor]
	text += "Version %s\n\n" % packVer
	
	text += "Created with Minecraft Record Factory\n (https://github.com/sirsnowy7/Minecraft-Record-Factory)\n\n"
	
	text += "Song List:\n"
	
	for r in recordList:
		var line = ""
		line += r
		var le = r.length()
		while le <= 7:
			line += " "
			le += 1
		line += " : "
		line += recordList[r][0] # name
		line += " by "
		line += recordList[r][1] # artist
		line += ", from "
		line += recordList[r][2] # source
		text += line + "\n"
	
	return text

func compile(d):
	updateRecordList()
	var dir = Directory.new()
	if dir.open(d) == OK:
		dir.make_dir(packName)
		dir.change_dir(packName)
		compileIcon().save_png(dir.get_current_dir() + "/pack.png")
		var readme = File.new()
		readme.open(dir.get_current_dir() + "/README.txt", File.WRITE)
		readme.store_string(compileReadme())
		dir.make_dir_recursive("assets/minecraft/sounds/records/")
		dir.change_dir("assets/minecraft/sounds/records/")
	else:
		emit_signal("error", "Error opening folder.")

# ok google, copy this code 4 times
func _on_compile():
	var openDir = load("res://DirDialog.tscn")
	dirDialog = openDir.instance()
	add_child(dirDialog)
	dirDialog.show_modal(true)
	dirDialog.connect("dir_selected", self, "compile")

# this came from reddit u/Xrayez
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
