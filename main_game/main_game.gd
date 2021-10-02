extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()

    # Start game :)
    new_game()


# Called on input events
func _unhandled_input(event):
    # Debug mode: Do stuff with keys
    if OS.is_debug_build():
        handle_debug_keys(event)


# Called when the player is hit by an asteroid
func _on_Player_hit():
    print("[Main] Player hit!")


# Sets everything up for a new game
func new_game():
    $Player.start($StartPosition.position)


# Spawns a new asteroid
func spawn_asteroid():
    $AsteroidSpawner.spawn_asteroid()


# Debug mode: Handle special keys that to stuff for debugging
func handle_debug_keys(event):
    if event is InputEventKey and event.pressed:
        # F9: Respawn player at start position
        if event.scancode == KEY_F9:
            print("[Main] Respawning player")
            $Player.reset_position($StartPosition.position)
        # F10: Spawn new asteroid
        if event.scancode == KEY_F10:
            spawn_asteroid()


func _on_BaseDestination_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_Goosington_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_SuspicousCube_pause(stats, position):
    $DestinationMenu.show(stats, position)


func _on_InhabitableRed_pause(stats, position):
    $DestinationMenu.show(stats, position)
