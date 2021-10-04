extends GridContainer
class_name PassengerPickupOption
signal option_selected


export var passenger = Dictionary()


func _ready():
    pass

func set_passenger(new_passenger):
    passenger = new_passenger
    $EndValue.text = new_passenger.end
    $PaymentValue.text = str(new_passenger.payment)



func _on_PickupButton_pressed():
    emit_signal("option_selected", passenger)
    queue_free()
