extends Area2D
class_name Waypoint
signal waypoint_removed

func _ready():
    visible = false


func set_or_remove_waypoint(new_position: Vector2):
    var x_diff = new_position.x - position.x
    var y_diff = new_position.y - position.y
    if visible == false or ((x_diff > 64 or x_diff < -64) and (y_diff > 64 or y_diff < -64)):
        position = new_position
        visible = true
    else:
        emit_signal("waypoint_removed")
        visible = false


func _on_Hud_waypoint_set(new_position: Vector2):
    set_or_remove_waypoint(new_position)


func _on_Waypoint_body_entered(body):
    visible = false
    emit_signal("waypoint_removed")


func get_info():
    return "Your current waypoint.\nOnce you unpause the game you will see an arrow showing you the way to it.\nClick here to remove it or somewhere else to move it there."
