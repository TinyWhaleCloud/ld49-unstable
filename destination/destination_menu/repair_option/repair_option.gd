extends GridContainer
class_name RepairOption
signal purchase_successful


var module
var price
var purchase_handler

func set_module(new_module):
    module = new_module
    $PartNameValue.text = new_module.module_type

func set_price(new_price: float):
    price = new_price
    var can_afford = purchase_handler.can_affort(new_price)
    $BuyButton.disabled = !can_afford
    $PartPriceValue.add_color_override("font_color", "ffffff" if can_afford else "ff0000")
    $PartPriceValue.text = str(new_price) + " Cu"

func _on_BuyButton_pressed():
    if purchase_handler.purchase_item(price, "Module repair: " + module.module_type):
        module.reset()
        emit_signal("purchase_successful")
