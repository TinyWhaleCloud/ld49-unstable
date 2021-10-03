class_name ShipBaseModule
extends Area2D

signal destroyed


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func destroy():
    print("[%s] I was destroyed!" % [name])
    queue_free()
    emit_signal("destroyed")


func get_shape() -> Shape2D:
    return $CollisionShape2D.shape
