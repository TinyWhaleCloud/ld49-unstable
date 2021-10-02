extends RigidBody2D

# Define signals
signal hit

# Define properties and internal variables
export var speed = 500
var thrust = Vector2(0, -speed)
var torque = 10000
var reset_new_position = null
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    hide()


# Initialize player to start a new game
func start(start_pos):
    position = start_pos
    $CollisionShape2D.disabled = false
    show()


func reset_position(start_pos):
    reset_new_position = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    

func _integrate_forces(state):
    # Reset player position?
    if reset_new_position is Vector2:
        state.transform = Transform2D(0, reset_new_position)
        state.linear_velocity = Vector2()
        state.angular_velocity = 0
        reset_new_position = null
    
    # Thrust
    applied_force = Vector2()
    if Input.is_action_pressed("ui_up"):
        applied_force += thrust.rotated(rotation)
    if Input.is_action_pressed("ui_down"):
        applied_force -= thrust.rotated(rotation)

    # Rotation
    var rotation_dir = 0
    if Input.is_action_pressed("ui_left"):
        rotation_dir -= 1
    if Input.is_action_pressed("ui_right"):
        rotation_dir += 1
    applied_torque = rotation_dir * torque


# Called when a body collides with the player
func _on_Player_body_entered(body):
    print("[Player] Body entered: ", body.name)
    emit_signal("hit")

    # Destroy asteroid on hit
    if body.has_method("destroy_on_hit"):
        body.destroy_on_hit()
