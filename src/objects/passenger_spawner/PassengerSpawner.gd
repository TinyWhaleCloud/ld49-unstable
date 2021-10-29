extends Timer
class_name PassengerSpawner
signal passenger_spawned


const destinations = ['Inhabitable Red', 'Goosington', 'Suspicious Cube', 'Shallow Space 7']
const current_passengers = 0

func _ready():
    start(15)
    for c in range(destinations.size()):
        spawn_passenger()

func create_passenger(start, end):
    return Passenger.new("Placeholder", floor(rand_range(50, 250)), start, end)

func spawn_passenger():
    var start_destination = randi() % destinations.size()
    var end_destination = start_destination
    while start_destination == end_destination:
        randomize()
        end_destination = randi() % destinations.size()
    start_destination = destinations[start_destination]
    end_destination = destinations[end_destination]
    print("Passenger spawned at " + start_destination)
    emit_signal("passenger_spawned", start_destination, create_passenger(start_destination, end_destination))

func _on_Timer_timeout():
    if current_passengers < 8:
        spawn_passenger()


class Passenger:
    export var name: String
    export var payment: float
    export var start: String
    export var end: String

    func _init(name, payment, start, end):
        self.name = name
        self.payment = payment
        self.start = start
        self.end = end
