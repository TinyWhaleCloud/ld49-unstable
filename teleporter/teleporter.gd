class_name Teleporter
extends Area2D


export var destination_x: int
export var destination_y: int

func _ready():
    pass # Replace with function body.


func _on_Teleporter_body_entered(body: RigidBody2D):
    print('body entered teleporter: ' + body.get_class())
    if (body.has_method('teleport_to')):
        var new_destiantion = Vector2()
        if destination_x:
            new_destiantion.x = destination_x
        else:
            new_destiantion.x = body.position.x
        if destination_y:
            new_destiantion.y = destination_y
        else:
            new_destiantion.y = body.position.y

        print ("Old location (x: %d, y%d)" % [body.position.x, body.position.y])
        print("Teleporting.. (x: %d, y: %d)" % [new_destiantion.x, new_destiantion.y])
        body.teleport_to(new_destiantion)
