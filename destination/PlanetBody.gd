extends Area2D


func _ready():
    pass # Replace with function body.


func _on_PlanetBody_body_entered(body):
    if (!body.has_method('blow_up')):
        print('Planet collision with object ' + body.name)
        body.queue_free()
