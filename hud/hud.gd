class_name Hud
extends CanvasLayer

signal paused
signal unpaused
signal waypoint_set


func _ready():
    $AsteroidWarningContainer.visible = false
    $PausedContainer.visible = false


func set_asteroid_warning_visible(visible: bool):
    $AsteroidWarningContainer.visible = visible


func _on_AsteroidSpawner_asteroid_field(visible):
    set_asteroid_warning_visible(visible)


func _process(delta):
    if Input.is_action_just_pressed("pause"):
        if $PausedContainer.visible:
            get_tree().paused = false
            $PausedContainer.visible = false
            emit_signal("unpaused")
        else:
            get_tree().paused = true
            $PausedContainer.visible = true
            emit_signal("paused")


func _input(event):
    if $PausedContainer.visible:
        if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
            var new_waypoint_position = get_tree().get_current_scene().get_global_mouse_position()
            emit_signal("waypoint_set", new_waypoint_position)
