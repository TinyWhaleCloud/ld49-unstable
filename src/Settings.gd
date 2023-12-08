extends Node

# Constants
const CONFIG_FILENAME = "user://settings.json"

var camera_rotation = false
var parallax_scrolling = true
var sfx = true
var music = false
var skip_tutorial = false


func _ready() -> void:
    # Load settings from filesystem
    load_settings()


func from_dict(data: Dictionary) -> void:
    camera_rotation = data.get("camera_rotation", false)
    parallax_scrolling = data.get("parallax_scrolling", true)
    sfx = data.get("sfx", true)
    music = data.get("music", false)
    skip_tutorial = data.get("skip_tutorial", false)


func to_dict() -> Dictionary:
    return {
        "camera_rotation": camera_rotation,
        "parallax_scrolling": parallax_scrolling,
        "sfx": sfx,
        "music": music,
        "skip_tutorial": skip_tutorial
    }


func load_settings() -> void:
    # Try to load the config file
    var config_file := File.new()
    if not config_file.file_exists(CONFIG_FILENAME):
        prints(self, "Config file does not exist yet.")
        return

    var err = config_file.open(CONFIG_FILENAME, File.READ)
    if err != OK:
        printerr("Error opening config file to read: ", err)
        return

    # Parse config file as JSON
    var config_json = config_file.get_as_text()
    from_dict(parse_json(config_json))


func save_settings() -> void:
    prints(self, "Saving settings to filesystem...")

    # Try to save the config file
    var config_file := File.new()

    var err = config_file.open(CONFIG_FILENAME, File.WRITE)
    if err != OK:
        printerr("Error opening config file to write: ", err)
        return

    # Dump config to JSON
    var config_json = to_json(to_dict())
    config_file.store_line(config_json)
