class_name ShipModuleGrid
extends Node2D

signal module_added(added_module)
signal module_removed(removed_module)
# TODO: signal last_cockpit_removed

# Preload module types
const ModuleCockpit = preload("res://spaceship/modules/cockpit.tscn")
const ModuleEngine = preload("res://spaceship/modules/engine.tscn")
const ModuleFuelTank = preload("res://spaceship/modules/fuel_tank.tscn")
const ModulePassengerBay = preload("res://spaceship/modules/passenger_bay.tscn")
const ModuleBasicHull = preload("res://spaceship/modules/basic_hull.tscn")
const ModuleBasicWingL = preload("res://spaceship/modules/basic_wing_left.tscn")
const ModuleBasicWingR = preload("res://spaceship/modules/basic_wing_right.tscn")

# Size of a module in pixel
const GRID_SIZE = 32

# This is where we store our modules
var module_list = []

# Where is vector position 0, 0
var center_position = GridPosition.new()

# Default module layout to create initial modules
var default_layout = [
    [null,              ModuleBasicWingL,   ModuleBasicHull,    ModuleBasicWingR,   null],
    [ModuleBasicWingL,  ModuleBasicHull,    ModuleCockpit,      ModuleBasicHull,    ModuleBasicWingR],
    [ModuleBasicHull,   ModuleFuelTank,     ModulePassengerBay, ModuleFuelTank,     ModuleBasicHull],
    [ModuleEngine,      null,               ModuleEngine,       null,               ModuleEngine],
]


# Called when the node enters the scene tree for the first time.
func _ready():
    # Create our modules
    create_modules_from_layout(default_layout)


func create_modules_from_layout(layout: Array):
    # Set center position to the first cockpit we find
    center_position = find_center_position(layout)

    # Create the modules
    for row in layout.size():
        for col in layout[row].size():
            var module_class = layout[row][col]
            if module_class != null:
                add_module(module_class.instance(), GridPosition.new(row, col))


func find_center_position(layout: Array) -> GridPosition:
    # Set center position to the first cockpit we find
    for row in layout.size():
        for col in layout[row].size():
            if layout[row][col] == ModuleCockpit:
                print("[%s] Setting center position to cockpit at %d/%d" % [name, row, col])
                return GridPosition.new(row, col)
    # Fallback to current value
    return center_position


func add_module(new_module: ShipBaseModule, grid_position: GridPosition):
    # TODO: Store in a 2D array...?
    module_list.append(new_module)

    # Set position and add to scene
    new_module.position = Vector2(grid_position.col - center_position.col, grid_position.row - center_position.row) * GRID_SIZE
    add_child(new_module)

    # Connect events
    new_module.connect("destroyed", self, "_on_ShipBaseModule_destroyed", [new_module])

    # Notify spaceship about new module
    emit_signal("module_added", new_module)


func reset_all():
    for module in module_list:
        module.reset()
        emit_signal("module_added", module)


func _on_ShipBaseModule_destroyed(destroyed_module: ShipBaseModule):
    print("[%s] Module was destroyed: %s" % [name, destroyed_module])
    emit_signal("module_removed", destroyed_module)


func get_engines(only_intact: bool = true) -> Array:
    var engine_array = []

    for module in module_list:
        if module is ShipEngine and (not only_intact or module.is_intact()):
            engine_array.append(module)

    return engine_array


func get_borked_modules():
    var borked = Array()
    for module in module_list:
        if !module.is_intact():
            borked.append(module)
    return borked


# Inner class to represent a position in the grid
class GridPosition:
    var row: int
    var col: int

    func _init(row: int = 0, col: int = 0):
        self.row = row
        self.col = col
