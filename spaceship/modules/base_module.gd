class_name ShipBaseModule
extends Area2D

signal destroyed

# State
var destroyed := false


func destroy():
    print("[%s] I was destroyed!" % [name])
    hide()
    destroyed = true
    emit_signal("destroyed")


func reset():
    print("[%s] Reset" % [name])
    show()
    destroyed = false


func get_shape() -> Shape2D:
    return $CollisionShape2D.shape
