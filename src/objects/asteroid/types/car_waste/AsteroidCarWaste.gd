extends BaseAsteroid

func _ready():
    min_speed = 300
    max_speed = 500

func get_info():
    return "Looks like there's a car drifting around.\nI wonder who thought that would be a good idea.\nYou should avoid hitting it."
