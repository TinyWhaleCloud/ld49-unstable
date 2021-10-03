class_name ShipModuleGrid
extends Node2D

signal module_added(added_module)
signal module_removed(removed_module)

onready var module_list = [$Cockpit1, $Cockpit2, $Cockpit3, $Cockpit4, $Cockpit5, $EngineLeft, $EngineCenter, $EngineRight]


# Called when the node enters the scene tree for the first time.
func _ready():
    # TODO construct dynamically
    for module in module_list:
        module.connect("destroyed", self, "_on_ShipBaseModule_destroyed", [module])
        emit_signal("module_added", module)


func remove_module(module: ShipBaseModule):
    module_list.erase(module)
    emit_signal("module_removed", module)


func _on_ShipBaseModule_destroyed(destroyed_module: ShipBaseModule):
    print("[%s] Module was destroyed: %s" % [name, destroyed_module])
    remove_module(destroyed_module)
