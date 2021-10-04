extends Node2D
signal cannot_afford(price, balance)
signal item_purchased(name, price, balance)

var player
var message

func _ready():
    var tree = get_tree()
    var player_results = tree.get_nodes_in_group("Player")
    if player_results.size() > 0:
        player = player_results[0]


func can_affort(amount: float):
    var result
    var balance
    if !player:
        print("[PurchaseHandler] Error: Player not found")
        result = false
        balance = 0
    else:
        balance = player.capitalism_units
        result = player.capitalism_units >= amount
    return result


func purchase_item(price: float, name: String = "item"):
    if !player:
        print("[PurchaseHandler] Error: Player not found")
    else:
        var balance = player.capitalism_units
        if balance < price:
            emit_signal("cannot_afford", price, balance)
            return false
        else:
            player.capitalism_units -= price
            emit_signal("item_purchased", name, price, balance - price)
            return true
