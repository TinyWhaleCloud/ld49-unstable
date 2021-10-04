extends Area2D
class_name PlanetBody


func _on_PlanetBody_body_entered(body):
    if (body is Spaceship):
        var stats = get_parent().stats
        body.handle_crash(stats.name)
    if (!body.has_method('blow_up')):
        print('Planet collision with object ' + body.name)
        body.queue_free()


func getFriendlinessStringFromScore(score:int):
    # TOOD: no copy pasted code
    if (score < 100):
        return 'Hostile'
    elif (score > 500):
        return 'Friendly'
    else:
        return 'Normal'


func get_info():
    var stats = get_parent().stats
    # TODO: Passengers waiting and fuel price from real values in stats
    return  "Name:                       " + stats.name + "\n" +\
            "Friendliness:             " + getFriendlinessStringFromScore(stats.friendliness_score) + "\n" +\
            "Economy:                  " + stats.economy + "\n" +\
            "Passengers waiting:  " + str(stats.passengers.size()) + "\n" +\
            "Fuel price:                100Cu/l"


func contains_point(point: Vector2, havers):
    var space = $Planet.get_world_2d().direct_space_state
    var results = space.intersect_point(point, 2, [], 2147483647, true, true)
    for result in results:
        var index = havers.find(result.collider)
        if index != -1:
            return index
    return false
