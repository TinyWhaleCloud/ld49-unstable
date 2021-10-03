class_name Player
extends Node


## Called when the node enters the scene tree for the first time.
#func _ready():
#    $Spaceship.hide()


# Initialize player to start a new game
func start(start_pos):
    $Spaceship.start(start_pos)
#    show()


func _on_DestinationMenu_rotate_player(target, away):
    $Spaceship.rotate_towards(target, away, false)
