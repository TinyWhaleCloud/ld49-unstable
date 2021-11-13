class_name Teleporter
extends Area2D

export var destination_x: int
export var destination_y: int

func _ready():
    pass # Replace with function body.


func _on_Teleporter_body_entered(body: RigidBody2D):
    if (body.has_method('teleport_to')):
        var new_destination = body.position
        if destination_x:
            new_destination.x = destination_x
        if destination_y:
            new_destination.y = destination_y

        print("[%s] Teleporting from location %s to new location %s" % [name, body.position, new_destination])
        body.teleport_to(new_destination)
