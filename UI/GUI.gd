extends CanvasLayer

onready var health_bar = $MarginContainer/Rows/BottomRow/HealthSection/HealthBar
onready var current_ammo_label = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo_label = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo
onready var score_label = $MarginContainer/Rows/TopRow/Score

var player: Player

func _ready():
	print('_ready call')
	
func set_new_health_value(new_health: int):
	print('set_new_health_value call')
	health_bar.value = new_health
	
func set_ammo_info(new_ammo: int, max_ammo: int):
	print('set_current_ammo call')
	current_ammo_label.text = str(new_ammo)
	max_ammo_label.text = str(max_ammo)
	
func set_kills_stat(kills: int):
	print('set_new_score_value call')
	score_label.text = str(kills)
