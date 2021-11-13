class_name Hud
extends CanvasLayer

signal paused
signal unpaused
signal waypoint_set

var info_seeker
var viewport


func _ready():
    $AsteroidWarningContainer.visible = false
    $PausedContainer.visible = false
    $PausedContainer/PausePanel.visible = false
    info_seeker = get_info_seeker()
    viewport = get_viewport()


func set_asteroid_warning_visible(visible: bool):
    $AsteroidWarningContainer.visible = visible


func _on_AsteroidSpawner_asteroid_field(visible):
    set_asteroid_warning_visible(visible)


func calculate_popover_position(mouse_pos):
    if (mouse_pos.x + 350 >= viewport.size.x):
        return mouse_pos - Vector2(350, 0)
    else:
        return mouse_pos


func _process(delta):
    if Input.is_action_just_pressed("pause"):
        if $PausedContainer.visible:
            get_tree().paused = false
            $PausedContainer.visible = false
            $PlayerInfoPanel.visible = true
            emit_signal("unpaused")
        else:
            get_tree().paused = true
            $PausedContainer.visible = true
            $PlayerInfoPanel.visible = false
            emit_signal("paused")
    if $PausedContainer.visible:
        if info_seeker:
            var mouse_position = get_tree().get_current_scene().get_global_mouse_position()
            var found_info = info_seeker.seek_info_node(mouse_position)
            if found_info:
                $PausedContainer/PausePanel.visible = true
                $PausedContainer/PausePanel/MarginContainer/Label.text = found_info
                $PausedContainer/PausePanel.set_global_position(calculate_popover_position($PausedContainer.get_global_mouse_position()))
            else:
                $PausedContainer/PausePanel.visible = false


func _input(event):
    if $PausedContainer.visible:
        if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
            var new_waypoint_position = get_tree().get_current_scene().get_global_mouse_position()
            emit_signal("waypoint_set", new_waypoint_position)


func get_info_seeker():
    var info_seeker_resutls = get_tree().get_nodes_in_group("InfoSeeker")
    if info_seeker_resutls.size() > 0:
        return info_seeker_resutls[0]
    return null
