extends BaseAsteroid

func _ready():
    min_speed = 100
    max_speed = 250

func get_info():
    return "This space rock looks like it's pretty radioactive.\nLuckily your ship does not mind some ionizing radiation.\nYou should still not hit it though."
