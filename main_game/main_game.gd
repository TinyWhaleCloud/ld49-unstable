extends Node

# Define properties and internal variables
export (PackedScene) var Asteroid
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    # TODO: get_viewport_rect() doesn't work here (maybe because it's not a Node2D?)
    # screen_size = get_viewport_rect().size
    screen_size = Rect2(0, 0, 1024, 600).size
    
    # Start game :)
    new_game()


# Called on input events
func _unhandled_input(event):
    # Debug mode: Do stuff with keys
    if OS.is_debug_build():
        handle_debug_keys(event)


# Called when the player is hit by an asteroid
func _on_Player_hit():
    print("player hit!")


# Called periodically to spawn new asteroids
func _on_AsteroidTimer_timeout():
    print("AsteroidTimer: timeout")
    spawn_asteroid()


# Sets everything up for a new game
func new_game():
    $Player.start($StartPosition.position)
    $AsteroidTimer.start()


# Spawns a new asteroid
func spawn_asteroid():
    print("spawning asteroid")
    var asteroid = Asteroid.instance()
    add_child(asteroid)
    
    # Randomize asteroid position
    var asteroid_position = Vector2(
        rand_range(0, screen_size.x),
        rand_range(0, screen_size.y)
    )
    asteroid.spawn(asteroid_position)
    

# Debug mode: Handle special keys that to stuff for debugging
func handle_debug_keys(event):
    if event is InputEventKey and event.pressed:
        # F9: Spawn new asteroid
        if event.scancode == KEY_F9:
            spawn_asteroid()
