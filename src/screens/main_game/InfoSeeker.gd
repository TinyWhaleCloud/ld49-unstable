extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func seek_info_node(point: Vector2):
    var space = $CollisionShape2D.get_world_2d().direct_space_state
    var results = space.intersect_point(point, 2, [], 2147483647, true, true)
    for result in results:
        if result.collider.has_method('get_info'):
            return result.collider.get_info()
    return false
