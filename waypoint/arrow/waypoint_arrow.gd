extends CanvasLayer
class_name WaypointArrow

export var current_waypoint_position: Vector2

var spaceship
var visible_after_pause = false

func _ready():
    $Sprite.visible = false
    spaceship = get_spaceship()

func _process(delta):
    if ($Sprite.visible && current_waypoint_position):
        $Sprite.rotation = 90 + spaceship.get_angle_to(current_waypoint_position)


func _on_Hud_waypoint_set(new_position):
    current_waypoint_position = new_position
    visible_after_pause = true


func _on_Waypoint_waypoint_removed():
    $Sprite.visible = false


func get_spaceship():
    var spaceships = get_tree().get_nodes_in_group("Spaceship")
    if spaceships.size() > 0:
        return spaceships[0]
    return null


func _on_Hud_paused():
    visible_after_pause = $Sprite.visible
    $Sprite.visible = false


func _on_Hud_unpaused():
    $Sprite.visible = visible_after_pause


func _on_Waypoint_waypoint_shown(new_waypoint_position):
    current_waypoint_position = new_waypoint_position
    if visible_after_pause and !$Sprite.visible:
        pass
    else:
        $Sprite.visible = true
