extends AcceptDialog

func _ready():
	pass

func _on_RecordPack_error(message):
	dialog_text = message
	visible = true

func _on_MetaPanel_error(message):
	dialog_text = message
	visible = true
