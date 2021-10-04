class_name Spaceship
extends RigidBody2D

# Define signals
signal hit

# Constants
const TORQUE_PER_THRUST = 35

# Define properties and internal variables
export var thrust = 500
export var current_passenger = {"name": "nobody"}
var torque = 10000
export var emergency_thrust = 50

var reset_new_position = null
var reset_new_rotation = null
var reset_clear_velocity = false
var reset_smooth_cam = false
var zoom_min = 0.5
var zoom_max = 4


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Initialize player to start a new game
func start(start_pos):
    position = start_pos
    rotation = 0


func reset_modules():
    print("[%s] Resetting all modules" % [name])

    # Remove all collision shapes
    for owner_id in get_shape_owners():
        shape_owner_clear_shapes(owner_id)
        remove_shape_owner(owner_id)

    # Reset modules
    $ModuleGrid.reset_all()


func get_borked_modules():
    return $ModuleGrid.get_borked_modules()


func reset_position(start_pos):
    reset_new_position = start_pos
    reset_new_rotation = 0
    reset_clear_velocity = true


func _on_ModuleGrid_module_added(added_module: ShipBaseModule):
    print("[%s] Module added: %s" % [name, added_module])

    # Add module shape to spaceship collision shapes
    var shape_owner_id = create_shape_owner(added_module)
    shape_owner_add_shape(shape_owner_id, added_module.get_shape())
    shape_owner_set_transform(shape_owner_id, Transform2D(0, added_module.position))


func _on_ModuleGrid_module_removed(removed_module: ShipBaseModule):
    print("[%s] Module removed: %s" % [name, removed_module])

    # Remove module shape from spaceship collision shapes
    for owner_id in get_shape_owners():
        if shape_owner_get_owner(owner_id) == removed_module:
            print("[%s] Deleting shape owner ID %d" % [name, owner_id])
            shape_owner_clear_shapes(owner_id)
            remove_shape_owner(owner_id)


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
    if Input.is_action_just_pressed("pause"):
        toggle_pause()

    if zoom_delta != 0:
        change_zoom(zoom_delta)


func change_zoom(zoom_delta):
    var zoom_factor = min(zoom_max, max(zoom_min, $Camera2D.zoom.x - zoom_delta))
    print("[%s] Zoom factor: %f" % [name, zoom_factor])
    $Camera2D.zoom = Vector2(zoom_factor, zoom_factor)

func toggle_pause():
    if $ZoomedOutCam.current:
        $Camera2D.make_current()
    else:
        $ZoomedOutCam.make_current()


func _integrate_forces(state):
    # Reset player position and/or velocity?
    if reset_new_position != null or reset_new_rotation != null:
        state.transform = Transform2D(
            reset_new_rotation if reset_new_rotation is int else rotation,
            reset_new_position if reset_new_position is Vector2 else position
        )
    if reset_clear_velocity:
        state.linear_velocity = Vector2()
        state.angular_velocity = 0

    reset_new_position = null
    reset_new_rotation = null
    reset_clear_velocity = false

    # Reset current forces
    applied_force = Vector2()
    applied_torque = 0

    # Thrust direction
    var move_forwards = 0
    var move_sideways = 0
    if Input.is_action_pressed("ui_up"):
        move_forwards = 1
    if Input.is_action_pressed("ui_down"):
        move_forwards = -1
    if Input.is_action_pressed("ship_thrust_left"):
        move_sideways = -1
    if Input.is_action_pressed("ship_thrust_right"):
        move_sideways = +1

    # Get all (intact) engines
    var intact_engines = $ModuleGrid.get_engines()
    var ship_total_thrust = 0

    # Combine both x and y movement, normalize
    var force_dir = Vector2(move_sideways, -move_forwards).normalized()
    var force_dir_forwards = force_dir.y * Vector2(0, 1).rotated(rotation) if move_forwards else null
    var force_dir_sideways = force_dir.x * Vector2(1, 0).rotated(rotation) if move_sideways else null

    # Apply engine forces (if there are any left intact)
    if not intact_engines.empty():
        for engine in intact_engines:
            ship_total_thrust += engine.thrust
            if force_dir_forwards:
                add_force(engine.position.rotated(rotation), force_dir_forwards * engine.thrust)
            if force_dir_sideways:
                add_central_force(force_dir_sideways * engine.thrust)
    else:
        # "Emergency thrust": Small thrust from the spaceship itself when no engines are left intact
        ship_total_thrust += emergency_thrust
        add_central_force(force_dir.rotated(rotation) * emergency_thrust)

    # Rotation
    var rotation_dir = 0
    if Input.is_action_pressed("ui_left"):
        rotation_dir -= 1
    if Input.is_action_pressed("ui_right"):
        rotation_dir += 1

    if rotation_dir:
        var ship_total_torque = ship_total_thrust * TORQUE_PER_THRUST
        add_torque(rotation_dir * ship_total_torque)

    # Engine exhaust flames animation
    for engine in intact_engines:
        if move_forwards or move_sideways or rotation_dir:
            engine.play_animation()
        else:
            engine.stop_animation()

    if reset_smooth_cam:
        $Camera2D.call_deferred("reset_smoothing")
        $Camera2D.call_deferred("smoothing_enabled", true)
        reset_smooth_cam = false


# Called when a body collides with the spaceship
func _on_Spaceship_body_shape_entered(body_id: int, body: Node, body_shape: int, local_shape: int):
    print("[%s] Body entered: %s (local shape: %d)" % [name, body.name, local_shape])
    emit_signal("hit")

    # Destroy ship module
    var hit_module = shape_owner_get_owner(shape_find_owner(local_shape))
    if is_instance_valid(hit_module) and hit_module is ShipBaseModule:
        destroy_hit_module(hit_module)

    # Destroy asteroid on hit
    if body.has_method("destroy_on_hit"):
        body.destroy_on_hit()


func look_at(target: Vector2):
    .look_at(target)
    rotation += PI / 2

func turn_around():
    rotation += PI


func rotate_towards(target: Vector2, away: bool, smooth: bool = true):
    print("[%s] Rotate towards/away from: %s" % [name, target])
    if (!smooth):
        reset_smooth_cam = true
    look_at(target)
    if away:
        turn_around()
    linear_velocity = Vector2()
    angular_velocity = 0


func teleport_to(destination: Vector2):
    # Actual movement must be done in _integrate_forces
    reset_new_position = destination

    # Temporarily disable camera smoothing to avoid nauseous camera jumps
    $Camera2D.smoothing_enabled = false
    reset_smooth_cam = true


func destroy_hit_module(hit_module: ShipBaseModule):
    print("[%s] Body hit module: %s" % [name, hit_module])
    hit_module.destroy()


func get_info():
    var info = "This is your trusty (though not especially stable) spaceship.\nIt's really important that you do not break it."
    if current_passenger.name != 'nobody':
        info += '\n\nCurrent passenger destination: ' + current_passenger.end
    return info
