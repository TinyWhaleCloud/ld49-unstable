extends Area2D
class_name Waypoint
signal waypoint_shown
signal waypoint_removed

func _ready():
    visible = false

func set_or_remove_waypoint(new_position: Vector2, always_set = false):
    var x_diff = new_position.x - position.x
    var y_diff = new_position.y - position.y
    if always_set or visible == false or ((x_diff > 64 or x_diff < -64) and (y_diff > 64 or y_diff < -64)):
        position = new_position
        visible = true
        print("Set waypoint ", new_position)
        emit_signal("waypoint_shown", new_position)
    else:
        emit_signal("waypoint_removed")
        visible = false

func _on_Hud_waypoint_set(new_position: Vector2):
    set_or_remove_waypoint(new_position)

func _on_Waypoint_body_entered(body):
    visible = false
    emit_signal("waypoint_removed")

func handle_set_event(new_position):
    set_or_remove_waypoint(new_position, true)

func _on_Goosington_set_waypoint(new_position):
    handle_set_event(new_position)

func _on_SuspicousCube_set_waypoint(new_position):
    handle_set_event(new_position)

func _on_InhabitableRed_set_waypoint(new_position):
    handle_set_event(new_position)

func _on_ShallowSpaceSeven_set_waypoint(new_position):
    handle_set_event(new_position)

func hide_waypoint():
    visible = false
    emit_signal("waypoint_removed")

func _on_Goosington_passenger_dropped_off():
    hide_waypoint()

func _on_SuspicousCube_passenger_dropped_off():
    hide_waypoint()

func _on_InhabitableRed_passenger_dropped_off():
    hide_waypoint()

func _on_ShallowSpaceSeven_passenger_dropped_off():
    hide_waypoint()

func get_info():
    return "Your current waypoint.\nOnce you unpause the game you will see an arrow showing you the way to it.\nClick here to remove it or somewhere else to move it there."

