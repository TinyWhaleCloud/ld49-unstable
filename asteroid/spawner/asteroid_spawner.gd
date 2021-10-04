extends Area2D
export (PackedScene) var SpaceCookie
export (PackedScene) var NuclearWaste
export (PackedScene) var CarWaste

signal asteroid_field


export var width = 500
export var height = 500


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func start():
    pass

func _on_Timer_timeout():
    spawn_asteroid()

# Spawns a new asteroid
func spawn_asteroid():
    print("spawning asteroid")
    var asteroid
    var which = rand_range(0, 100)
    if (which < 2):
        asteroid = CarWaste.instance()
    elif (which < 50):
        asteroid = NuclearWaste.instance()
    else:
        asteroid = SpaceCookie.instance()

    # Randomize asteroid position (relative to spawner origin)
    var asteroid_position = position + Vector2(
        rand_range($CollisionShape2D.shape.extents.x * -1, $CollisionShape2D.shape.extents.x),
        rand_range($CollisionShape2D.shape.extents.y * -1, $CollisionShape2D.shape.extents.y)
    )

    $"/root/Main".add_child(asteroid)
    asteroid.spawn(asteroid_position)


func _on_AsteroidSpawner_body_entered(body):
    if body is Spaceship:
        $Timer.start()
        emit_signal("asteroid_field", true)


func _on_AsteroidSpawner_body_exited(body):
    if body is Spaceship:
        $Timer.stop()
        emit_signal("asteroid_field", false)

func get_info():
    return "Asteroid field.\n It looks like if you go here you will have to dodge some asteroids."
