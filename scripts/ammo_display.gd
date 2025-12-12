extends Label

@export var ammo_type: String = "apples"  # "apples" ou "carrots"

func _process(_delta):
	if ammo_type == "apples":
		text = str(Globals.apples)
	elif ammo_type == "carrots":
		text = str(Globals.carrots)
