import Record

class RecordPack:
  def __init__(self, name, version):
	self.name = name
	self.version = version
	self.icon_png = 0
	self.records = {
	  "13":      Record("13", "C418"),
	  "cat":     Record("cat", "C418"),
	  "blocks":  Record("blocks", "C418"),
	  "chirp":   Record("chirp", "C418"),
	  "far":     Record("far", "C418"),
	  "mall":    Record("mall", "C418"),
	  "mellohi": Record("mellohi", "C418"),
	  "stal":    Record("stal", "C418"),
	  "strad":   Record("strad", "C418"),
	  "ward":    Record("ward", "C418"),
	  "11":      Record("11", "C418"),
	  "wait":    Record("wait", "C418"),
	  "Pigstep": Record("Pigstep", "Lena Raine")
	}
