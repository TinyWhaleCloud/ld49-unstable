extends RigidBody2D

# Define properties and internal variables
export var min_speed = 50
export var max_speed = 200


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called when the asteroid leaves the visible screen
func _on_VisibilityNotifier2D_screen_exited():
    # TODO: not sure if we want all asteroid to remove themselves when invisible though?
    queue_free()


# Initializes a newly spawned asteroid
func spawn(start_pos):
    # Set start position
    position = start_pos
    
    # Randomize direction and movement
    rotation = rand_range(0, 2 * PI)
    linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
    linear_velocity = linear_velocity.rotated(rotation)


# Destroys asteroid on hit
func destroy_on_hit():
    queue_free()
