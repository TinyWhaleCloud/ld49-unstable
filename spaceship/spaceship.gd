class_name Spaceship
extends RigidBody2D

# Define signals
signal hit

# Define properties and internal variables
export var thrust = 500
var thrust_direction = Vector2(0, -1)
var torque = 10000
var reset_new_position = null
var zoom_min = 0.5
var zoom_max = 4


# Called when the node enters the scene tree for the first time.
func _ready():
    # Copy collision shapes from modules
    var modules = [$Cockpit1, $Cockpit2, $Cockpit3, $Cockpit4, $Cockpit5, $EngineLeft, $EngineCenter, $EngineRight]

    for module in modules:
        var shape_owner = create_shape_owner(self)
        shape_owner_add_shape(shape_owner, module.get_node("CollisionShape2D").shape)
        shape_owner_set_transform(shape_owner, Transform2D(0, module.position))


# Initialize player to start a new game
func start(start_pos):
    position = start_pos


func reset_position(start_pos):
    reset_new_position = start_pos


func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_WHEEL_UP and event.pressed:
            change_zoom(0.2)
        if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
            change_zoom(-0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # Camera zoom
    var zoom_delta = 0
    if Input.is_action_pressed("zoom_in"):
        zoom_delta += delta
    if Input.is_action_pressed("zoom_out"):
        zoom_delta -= delta

    if zoom_delta != 0:
        change_zoom(zoom_delta)


func change_zoom(zoom_delta):
    var zoom_factor = min(zoom_max, max(zoom_min, $Camera2D.zoom.x - zoom_delta))
    print("[Player] Zoom factor: ", zoom_factor)
    $Camera2D.zoom = Vector2(zoom_factor, zoom_factor)


func _integrate_forces(state):
    # Reset player position?
    if reset_new_position is Vector2:
        state.transform = Transform2D(0, reset_new_position)
        state.linear_velocity = Vector2()
        state.angular_velocity = 0
        reset_new_position = null

    # Thrust
    var acceleration = 0
    if Input.is_action_pressed("ui_up"):
        acceleration += thrust
    if Input.is_action_pressed("ui_down"):
        acceleration -= thrust
    applied_force = acceleration * thrust_direction.rotated(rotation)

    # Rotation
    var rotation_dir = 0
    if Input.is_action_pressed("ui_left"):
        rotation_dir -= 1
    if Input.is_action_pressed("ui_right"):
        rotation_dir += 1
    applied_torque = rotation_dir * torque


# Called when a body collides with the spaceship
func _on_Spaceship_body_shape_entered(body_id: int, body: Node, body_shape: int, local_shape: int):
    print("[Player] Body entered: ", body.name)
    print("........ Body ID: %d, body shape: %d, local shape: %d" % [body_id, body_shape, local_shape])

    emit_signal("hit")

    # Destroy asteroid on hit
    if body.has_method("destroy_on_hit"):
        body.destroy_on_hit()
