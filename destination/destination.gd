extends Area2D
signal pause

export (PackedScene) var Rocket
export var stats = {}

var targets = []
var removing = false

func _ready():
    stats = destination_stats.new('Base Destination', 100, 0,0, 'Normal', 'Bubble', 'This is the base destination that should not be rendered. Oopsie!', 0.5)
    color_atmosphere()

func color_atmosphere():
    if (stats.friendliness_score < 100):
        $AtmosphereSprite.frame = 0
    elif(stats.friendliness_score <= 500):
        $AtmosphereSprite.frame = 1
    else:
        $AtmosphereSprite.frame = 2


func _on_BaseDestination_body_entered(body):
    if (body is Spaceship and stats.friendliness_score >= 100):
        if (stats.friendliness_score >= 100):
            emit_signal('pause', stats, position)
    elif (!body.has_method('blow_up')):
        if (targets.size() == 0):
            $TargetingTimer.start(stats.aggression)
        targets.append(body)


func _on_BaseDestination_body_exited(body):
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


class destination_stats:
    export var name = ''
    export var friendliness_score = 0
    export var units_spent = 0
    export var transported = 0
    export var stability = ''
    export var economy = ''
    export var flavor_text = ''
    export var aggression = 0.5


    func _init(iName, ifriendliness_score, iunits_spent, itransported, istability, ieconomy, iflavor_text, iaggression):
        name = iName
        friendliness_score = ifriendliness_score
        units_spent = iunits_spent
        transported = itransported
        stability = istability
        economy = ieconomy
        flavor_text = iflavor_text
        aggression = iaggression

