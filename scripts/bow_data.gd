class_name BowData
extends Resource

## Data-driven bow definition.
## Create individual .tres resources for each bow so new equipment can be
## added without modifying gameplay code.

@export_category("Identity")
@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

@export_category("Economy")
@export var price: int = 0
@export var required_strength: int = 1

@export_category("Performance")
@export var max_draw_strength: float = 100.0
@export var draw_speed: float = 55.0
@export var min_launch_speed: float = 360.0
@export var max_launch_speed: float = 760.0

@export_category("Visuals")
@export var limb_color: Color = Color("8d603d")
@export var string_color: Color = Color("d8d0bb")
@export var limb_width: float = 10.0
@export var string_width: float = 3.75
@export var limb_height: float = 70.0
@export var arrow_spawn_offset: float = 28.0
