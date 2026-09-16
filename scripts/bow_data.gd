class_name BowData
extends Resource

## Data-driven bow definition.
## Create individual .tres resources for each bow so new equipment can be
## added without modifying gameplay code.

@export var id: String = ""
@export var display_name: String = ""
@export var price: int = 0
@export var required_strength: int = 1
@export var max_draw_strength: float = 100.0
@export var draw_speed: float = 55.0
@export var min_launch_speed: float = 360.0
@export var max_launch_speed: float = 760.0
@export_multiline var description: String = ""
