class_name BaseDestination
extends Area2D

signal pause
signal passenger_dropped_off
signal set_waypoint(new_position)

export (PackedScene) var Rocket
export var stats = {}

var targets = []
var removing = false
var player_currently_in_atmosphere = false

func _ready():
    stats = destination_stats.new('Base Destination', 100, 0,0, 'Normal', 'Bubble', 'This is the base destination that should not be rendered. Oopsie!', 0.5, [])

func handle_spaceship_entering(spaceship: RigidBody2D):
    if spaceship.current_passenger.name != 'nobody':
        if spaceship.current_passenger.end == stats.name:
            print("passenger dropped off")
            stats.friendliness_score += 50
            stats.transported += 1
            emit_signal("passenger_dropped_off")
            return true
        elif spaceship.current_passenger.start == stats.name:
            return true
    elif stats.passengers.size() > 0:
        return true
    return stats.friendliness_score >= 100

func handle_spaceship_leaving():
    # Clear flag that player is currently in the atmosphere after a short timeout
    yield(get_tree().create_timer(0.1), "timeout")
    player_currently_in_atmosphere = false
    print("[%s] Spaceship left the atmosphere" % stats.name)

func _on_BaseDestination_body_entered(body):
    # Don't do anything if the player is already (or still) here
    if player_currently_in_atmosphere:
        return

    if body is Spaceship and handle_spaceship_entering(body):
        print("[%s] Spaceship entered the atmosphere" % stats.name)
        player_currently_in_atmosphere = true
        emit_signal('pause', stats, position)
    elif (!body.has_method('blow_up')):
        if (targets.size() == 0):
            $TargetingTimer.start(stats.aggression)
        targets.append(body)

func _on_BaseDestination_body_exited(body):
    if body is Spaceship:
        # Avoid planet menu if it was just closed by setting a timer (asynchronously)
        handle_spaceship_leaving()

    # Catch a race condition when multiple bodies leave at the same time
    while(removing):
        pass
    removing = true
    for c in range(targets.size()):
        if (targets.size() >= c + 1):
            if targets[c].name == body.name:
                targets.remove(c)
                print("removing target " + body.name)
    if targets.size() == 0:
        $TargetingTimer.stop()
    removing = false

func shoot_rocket(body: RigidBody2D):
    print(stats.name + ': Shooting Rocket at ' + body.name)
    print("Target location x: %d y: %d" % [body.position.x, body.position.y])
    var new_rocket = Rocket.instance()
    add_child(new_rocket)
    var rocket_position = Vector2(randi() % 10, randi() % 10)
    # TODO: super advanced rocket targeting (#31)
    var rocket_target = body.global_position + body.linear_velocity
    new_rocket.spawn(rocket_position, rocket_target)

func _on_TargetingTimer_timeout():
    var target_index = randi() % targets.size()
    if target_index < targets.size():
        # catch race conditions
        shoot_rocket(targets[target_index])

func handle_passenger_spawn_signal(start, passenger):
    if start == stats.name:
        stats.passengers.append(passenger)

func set_waypoint_to_passenger_end(passenger):
    var destinations = get_tree().get_nodes_in_group("Destination")
    if destinations.size() > 0:
        for destination in destinations:
            if destination.stats.name == passenger.end:
                print("Setting waypoint for dest ", destination.position)
                emit_signal("set_waypoint", destination.position)
                return
    print("no destination with name " + passenger.end)
    return null

func handle_passenger_picked_up_signal(passenger):
    if (passenger.start == stats.name):
        set_waypoint_to_passenger_end(passenger)
        for c in range(stats.passengers.size()):
            if stats.passengers[c] == passenger:
                stats.passengers.remove(c)
                return

func handle_passenger_dead(passenger):
    if (passenger.end == stats.name):
        stats.friendliness_score -= 50


class destination_stats:
    export var name = ''
    export var friendliness_score = 0
    export var units_spent = 0
    export var transported = 0
    export var stability = ''
    export var economy = ''
    export var flavor_text = ''
    export var aggression = 0.5
    export var passengers = []

    func _init(iName, ifriendliness_score, iunits_spent, itransported, istability, ieconomy, iflavor_text, iaggression, ipassengers = null):
        name = iName
        friendliness_score = ifriendliness_score
        units_spent = iunits_spent
        transported = itransported
        stability = istability
        economy = ieconomy
        flavor_text = iflavor_text
        aggression = iaggression
        passengers = ipassengers if ipassengers != null else Array()
