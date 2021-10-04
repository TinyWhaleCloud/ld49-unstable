extends Area2D
export (PackedScene) var SpaceCookie
export (PackedScene) var NuclearWaste
export (PackedScene) var CarWaste

signal asteroid_field

# Spawn frequency (asteroids per second)
export var spawn_frequency = 1
export var spawn_timer_randomness = 1.2

# The body (i.e. spaceship) that the asteroids spawn around
var centered_body = null
# The radius around the centered_body where asteroids spawn
var center_radius = 1000


func _ready():
    # Set spawn frequency
    randomize_timer()


# Spawns a new asteroid
func spawn_asteroid():
    print("[%s] Spawning asteroid" % name)

    # Create new asteroid node
    var asteroid = create_random_asteroid()
    var asteroid_position = get_random_spawn_position()

    # Add asteriod to main game (otherwise positions are always relative to the spawner node)
    $"/root/Main".add_child(asteroid)
    asteroid.spawn(asteroid_position)

func create_random_asteroid():
    var which = rand_range(0, 100)
    if (which < 2):
        return CarWaste.instance()
    elif (which < 50):
        return NuclearWaste.instance()
    else:
        return SpaceCookie.instance()

func get_random_spawn_position() -> Vector2:
    if centered_body != null:
        # Randomize asteroid position: Spawn in a fixed radius from the spaceship
        return centered_body.position + Vector2(center_radius, 0).rotated(rand_range(0, 2*PI))
    else:
        # Fallback to spawning in the middle of the spawner area
        return position + Vector2(50, 0).rotated(rand_range(0, 2*PI))


func randomize_timer():
    var spawn_time = 1.0 / spawn_frequency
    var random_factor = rand_range(1 / spawn_timer_randomness, spawn_timer_randomness)
    $Timer.wait_time = spawn_time * random_factor


func _on_Timer_timeout():
    spawn_asteroid()
    randomize_timer()
    $Timer.start()

func _on_AsteroidSpawner_body_entered(body):
    if body is Spaceship:
        centered_body = body
        $Timer.start()
        emit_signal("asteroid_field", true)

func _on_AsteroidSpawner_body_exited(body):
    if body is Spaceship:
        centered_body = null
        $Timer.stop()
        emit_signal("asteroid_field", false)


func get_info():
    return "Asteroid field.\n It looks like if you go here you will have to dodge some asteroids."
