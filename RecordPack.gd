extends Node

class_name RecordPack

export(String) var packName
export(String) var packAuthor
export(String) var packVer # this is the pack version, not the minecraft version
export(String) var packDesc
export(String) var iconPath
export(bool) var iconDiscOverlay

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
		discImg.texture = load("res://images/records/%s.png" % newRecord.songName)
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

func _ready():
	# connect menubar to here
	var menuBar = get_tree().get_root().get_node("Main/MenuPanel")
	menuBar.connect("save", self, "_on_menuBar_save")
	# fill up the record grid
	fillRecords()

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

func _on_menuBar_save():
	updateRecordList()
	print(to_dict())

# this came from reddit u/Xrayez
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
