extends PanelContainer

var fuel_total_capacity = 0
var fuel_current = 0
var money_current = 0

func _ready():
    update_fuel_bar()
    update_money()

func _on_Spaceship_fuel_changed(total_capacity, current_fuel):
    fuel_total_capacity = total_capacity
    fuel_current = current_fuel
    update_fuel_bar()

func _on_Player_capitalism_units_changed(new_value):
    money_current = new_value
    update_money()

func update_fuel_bar():
    $GridContainer/FuelBar.max_value = fuel_total_capacity
    $GridContainer/FuelBar.value = fuel_current
    $GridContainer/FuelBar/FuelValueLabel.text = "%d / %d" % [fuel_current, fuel_total_capacity]

func update_money():
    $GridContainer/MoneyValueLabel.text = "%d Cu" % money_current
