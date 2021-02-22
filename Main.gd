extends Control

# true if main panel is active panel
var main = true

onready var swapperButton = $SwapperPanel/Swapper
onready var mainPanel = $MainPanel
onready var aboutButton = $MenuPanel/MenuBar/About
onready var metaPanel = $MetaPanel
onready var aboutWindow = $AboutWindow

func _ready():
	# change window title
	OS.set_window_title("New Project - Minecraft Record Factory")
	# AboutWindow.gd
	aboutButton.connect("pressed", aboutWindow, "_on_aboutButton_pressed")

func _on_Swapper_pressed():
	# if meta button clicked
	if main:
		# disable main panel, enable meta panel
		mainPanel.visible = false
		metaPanel.visible = true
		# change text on swapper button, also toggle member var main
		swapperButton.text = "Main"
		main = false
	# literally the opposite
	else:
		mainPanel.visible = true
		metaPanel.visible = false
		swapperButton.text = "Meta"
		main = true
