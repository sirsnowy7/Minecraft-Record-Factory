extends Panel

onready var discOverlay = $CenterContainer/MetadataContainer/IconMargin/IconContainer/Icon/Disc

func _ready():
	pass

# match state of disc overlay to state of tickbox
func _on_OverlayTick_toggled(button_pressed):
	discOverlay.visible = button_pressed
