extends Panel

var fileDialog

signal error(message)

onready var iconRect = $CenterContainer/MetadataContainer/IconMargin/IconContainer/Icon
onready var discOverlay = $CenterContainer/MetadataContainer/IconMargin/IconContainer/Icon/Disc
onready var recordPack = get_tree().get_root().get_node("Main/RecordPack")
onready var nameInp = $CenterContainer/MetadataContainer/TextDataMargin/TextData/NameInp
onready var authorInp = $CenterContainer/MetadataContainer/TextDataMargin/TextData/AuthorInp
onready var versionInp = $CenterContainer/MetadataContainer/TextDataMargin/TextData/VersionInp
onready var monoCheck = $CenterContainer/MetadataContainer/TextDataMargin/TextData/MonoCheck
onready var overlayTick = $CenterContainer/MetadataContainer/IconMargin/IconContainer/OverlayTick
onready var fileButton = $CenterContainer/MetadataContainer/IconMargin/IconContainer/FileButton
onready var descInp = $CenterContainer/MetadataContainer/DescMargin/DescContainer/DescEdit

func _ready():
	# again this is SUCH a shitty way to do this hahah
	nameInp.connect("text_changed", self, "_on_anyInp_change")
	authorInp.connect("text_changed", self, "_on_anyInp_change")
	versionInp.connect("text_changed", self, "_on_anyInp_change")
	descInp.connect("text_changed", self, "_on_desc_change")

func _on_anyInp_change(u):
	# anytime input is changed update all member vars
	recordPack.packName = nameInp.text
	recordPack.packAuthor = authorInp.text
	recordPack.packVer = versionInp.text

func _on_desc_change():
	recordPack.packDesc = descInp.text

# copy paste of an earlier function lol
func _on_File_button_down():
	# when file select button is clicked instance openfile dialog
	var openFile = load("res://OpenFile.tscn")
	fileDialog = openFile.instance()
	add_child(fileDialog)
	# make it a modal and set up an event for file getting selected
	fileDialog.show_modal(true)
	fileDialog.filters = PoolStringArray(["*.png ; PNG Images", "*.jpeg, *.jpg ; JPEG Images"])
	fileDialog.connect("file_selected", self, "_on_OpenFile_file_selected")

func changeIcon():
	var tex = ImageTexture.new()
	var img = Image.new()
	tex.load(recordPack.iconPath)
	img = tex.get_data()
	img.resize(128,128) # i didn't test this but it probably works
	tex.create_from_image(img)
	if not tex.get_height() == tex.get_width():
		emit_signal("error", "Error! Image aspect ratio not 1:1.")
		return
	iconRect.texture = tex
	

func _on_OpenFile_file_selected(fileSelected):
	# set the filePath var to file selected, as well as button text
	recordPack.iconPath = fileSelected
	fileButton.text = fileSelected
	fileButton.hint_tooltip = fileSelected
	changeIcon()

# match state of disc overlay to state of tickbox and track the data
func _on_OverlayTick_toggled(button_pressed):
	discOverlay.visible = button_pressed
	recordPack.iconDiscOverlay = button_pressed


func _on_MonoCheck_toggled(button_pressed):
	if button_pressed:
		recordPack.packChannels = 1
	else:
		recordPack.packChannels = 2
