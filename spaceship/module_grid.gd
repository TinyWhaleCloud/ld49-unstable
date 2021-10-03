class_name ShipModuleGrid
extends Node2D

signal module_added(added_module)
signal module_removed(removed_module)
# TODO: signal last_cockpit_removed

# Preload module types
const ModuleCockpit = preload("res://spaceship/modules/cockpit.tscn")
const ModuleEngine = preload("res://spaceship/modules/engine.tscn")

# Size of a module in pixel
const GRID_SIZE = 32

# This is where we store our modules
var module_list = []

# Where is vector position 0, 0 (position of cockpit module)
var center_position = GridPosition.new(2, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
    # Create our modules
    for i in range(5):
        add_module(ModuleCockpit.instance(), GridPosition.new(i, 0))

    add_module(ModuleEngine.instance(), GridPosition.new(0, 1))
    add_module(ModuleEngine.instance(), GridPosition.new(2, 1))
    add_module(ModuleEngine.instance(), GridPosition.new(4, 1))


func add_module(new_module: ShipBaseModule, grid_position: GridPosition):
    # TODO: Store in a 2D array
    module_list.append(new_module)

    # Set position and add to scene
    new_module.position = Vector2(grid_position.x - center_position.x, grid_position.y - center_position.y) * GRID_SIZE
    add_child(new_module)

    # Connect events
    new_module.connect("destroyed", self, "_on_ShipBaseModule_destroyed", [new_module])

    # Notify spaceship about new module
    emit_signal("module_added", new_module)


func reset_module(module: ShipBaseModule):
    module.show()
    emit_signal("module_added", module)


func reset_all():
    for module in module_list:
        reset_module(module)


func _on_ShipBaseModule_destroyed(destroyed_module: ShipBaseModule):
    print("[%s] Module was destroyed: %s" % [name, destroyed_module])
    emit_signal("module_removed", destroyed_module)


# Inner class to represent a position in the grid
class GridPosition:
    var x: int
    var y: int

    func _init(x: int = 0, y: int = 0):
        self.x = x
        self.y = y
