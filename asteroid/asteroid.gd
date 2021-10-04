extends RigidBody2D

# Define properties and internal variables
export var min_speed = 50
export var max_speed = 200

var reset_new_position = null

# Initializes a newly spawned asteroid
func spawn(start_pos, start_rotation = null, start_velocity = null):
    # Default: Randomize direction and velocity
    if start_rotation == null:
        start_rotation = rand_range(0, 2 * PI)
    if start_velocity == null:
        start_velocity = rand_range(min_speed, max_speed)

    # Set start position, rotation and velocity
    position = start_pos
    rotation = start_rotation
    linear_velocity = Vector2(start_velocity, 0).rotated(rotation)


# Destroys asteroid on hit
func destroy_on_hit():
    queue_free()


func _integrate_forces(state):
    # Reset asteroid position after teleport
    if reset_new_position is Vector2:
        state.transform = Transform2D(rotation, reset_new_position)
        reset_new_position = null


func teleport_to(destination: Vector2):
    # Actual movement must be done in _integrate_forces
    reset_new_position = destination


# Called when the asteroid leaves the visible screen
func _on_VisibilityNotifier2D_screen_exited():
    $DestructionTimer.start(5)

# Destroy asteroid 5 seconds after it left the screen if it has not re-entered
func _on_DestructionTimer_timeout():
    $DestructionTimer.stop()
    if !$VisibilityNotifier2D.is_on_screen():
        queue_free()

func get_info():
    return "This is an asteroid.\nYou should avoid hitting it."
