extends CanvasLayer
class_name WaypointArrow

const BORDER_MARGIN = 32

export var current_waypoint_position: Vector2

var spaceship
var visible_after_pause = false


func _ready():
    $Sprite.visible = false
    spaceship = get_spaceship()

    # When the window is resized, recalculate the border path
    get_viewport().connect("size_changed", self, "_on_viewport_resize")
    _on_viewport_resize()


# When the window is resized, recalculate the border path
func _on_viewport_resize():
    # Get viewport size
    var viewport_size = get_viewport().size

    var _top = BORDER_MARGIN
    var _bottom = viewport_size.y - BORDER_MARGIN
    var _left = BORDER_MARGIN
    var _right = viewport_size.x - BORDER_MARGIN

    # We start and end with the center of the top border (because that's "north")
    var path_points = [
        Vector2(viewport_size.x / 2, _top),
        Vector2(_right, _top),
        Vector2(_right, _bottom),
        Vector2(_left, _bottom),
        Vector2(_left, _top),
        Vector2(viewport_size.x / 2, _top),
    ]

    # Create curve for border path
    $BorderPath.curve = Curve2D.new()

    for path_point in path_points:
        $BorderPath.curve.add_point(path_point)


func _process(delta):
    if ($Sprite.visible && current_waypoint_position):
        # Rotate arrow from spaceship towards the waypoint
        $Sprite.rotation = PI/2 + spaceship.get_angle_to(current_waypoint_position)

        if not spaceship.get_node("Camera2D").rotating:
            $Sprite.rotation += spaceship.rotation

        # Get location on BorderPath corresponding to the angle of the arrow
        $BorderPath/ArrowLocation.unit_offset = $Sprite.rotation / (2 * PI)
        $Sprite.position = $BorderPath/ArrowLocation.position


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
