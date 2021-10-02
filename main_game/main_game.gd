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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


# Called when the player is hit by an asteroid
func _on_Player_hit():
    print("player hit!")


# Called periodically to spawn new asteroids
func _on_AsteroidTimer_timeout():
    print("spawn asteroid")
    spawn_asteroid()


# Sets everything up for a new game
func new_game():
    $Player.start($StartPosition.position)
    $AsteroidTimer.start()


# Spawns a new asteroid
func spawn_asteroid():
    var asteroid = Asteroid.instance()
    add_child(asteroid)
    
    # Randomize asteroid position
    var asteroid_position = Vector2(
        rand_range(0, screen_size.x),
        rand_range(0, screen_size.y)
    )
    asteroid.spawn(asteroid_position)
