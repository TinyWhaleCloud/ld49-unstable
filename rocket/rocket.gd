extends RigidBody2D

export var thrust = 650

func _ready():
    pass # Replace with function body.

func spawn(initial_position, initial_target):
    position = initial_position
    look_at(initial_target)
    linear_velocity = Vector2(thrust, 0).rotated(rotation)

func blow_up():
    queue_free()


func _on_VisibilityNotifier2D_screen_exited():
    $BlowUpTimer.start(5)


func _on_BlowUpTimer_timeout():
    if !$VisibilityNotifier2D.is_on_screen():
        queue_free()


func _on_Rocket_body_entered(body: RigidBody2D):
    if (body.has_method('destroy_on_hit')):
        body.destroy_on_hit()
    blow_up()
