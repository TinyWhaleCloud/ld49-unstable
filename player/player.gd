class_name Player
extends Node


## Called when the node enters the scene tree for the first time.
#func _ready():
#    $Spaceship.hide()


# Initialize player to start a new game
func start(start_pos):
    $Spaceship.start(start_pos)
#    show()
