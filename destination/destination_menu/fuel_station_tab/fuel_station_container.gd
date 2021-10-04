extends VBoxContainer

signal buy_fuel(refill_amount, price)

var spaceship: Spaceship
var purchase_handler: PurchaseHandler
var price_per_unit = 2

# This is for the next refill
var refill_amount = 0
var refill_price = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    purchase_handler = get_node_by_group("PurchaseHandler")
    spaceship = get_node_by_group("Spaceship")
    update_labels()

func get_node_by_group(group_name):
    var ph_results = get_tree().get_nodes_in_group(group_name)
    if ph_results.size() > 0:
        return ph_results[0]
    return null

func update_labels():
    $GridContainer/FuelLevelValue.text = "%d / %d" % [spaceship.current_fuel, spaceship.total_fuel_capacity]
    $GridContainer/PricePerUnit.text = "%d Cu/l" % price_per_unit

    var total_money = spaceship.get_parent().capitalism_units
    var full_refill_price = 0
    refill_amount = spaceship.total_fuel_capacity - spaceship.current_fuel

    if spaceship.tanks_are_full():
        $AlreadyFullLabel.visible = true
        $NotEnoughCuLabel.visible = false
    else:
        full_refill_price = refill_amount * price_per_unit
        $AlreadyFullLabel.visible = false
        $NotEnoughCuLabel.visible = full_refill_price > total_money

        if full_refill_price > total_money:
            refill_amount = floor(total_money / price_per_unit)

    refill_price = refill_amount * price_per_unit

    $GridContainer/FullRefillPrice.text = "%d Cu" % full_refill_price
    $BuyFuelButton.text = "Buy %d liters of fuel now for only %d Cu!" % [refill_amount, refill_price]

func _on_BuyFuelButton_pressed():
    if purchase_handler.purchase_item(refill_price, "%d liters of fuel" % refill_amount):
        spaceship.refill_fuel(refill_amount)
        emit_signal("purchase_successful")
    update_labels()
