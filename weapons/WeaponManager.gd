extends Node2D

#signal weapon_changed(new_weapon)

onready var current_weapon: Weapon = $Pistol

var weapons: Array = []

func _ready():
	print('WeaponManager._ready call')
	weapons = get_children()
	
	for weapon in weapons:
		weapon.hide()
		
	current_weapon.show()
	connectWeaponFiredEvent(current_weapon)
	
	
func connectWeaponFiredEvent(weapon: Weapon):
	if weapon.connected == false:
		weapon.connect("weapon_fired", self, "on_weapon_fired")
		weapon.connected = true
	pass 
	
	
func emitGuiAmmoChanged():
	var cAmmo = current_weapon.current_ammo
	var mAmmo = current_weapon.max_ammo
	GlobalSignals.emit_signal("gui_ammo_changed", cAmmo, mAmmo)
	
func on_weapon_fired(current: int):
	print('weapon_fired call,', current)
	emitGuiAmmoChanged()
	
func get_current_weapon() -> Weapon:
	return current_weapon
	
func switch_weapon(weapon: Weapon):
	print('switch_weapon call')
	if weapon == current_weapon:
		return
	
	current_weapon.hide()
	# disconnect

	weapon.show()	
	current_weapon = weapon
	# podpiecie zdarzen obslugi broni
	connectWeaponFiredEvent(weapon)
	# wyslanie informacji o zaktualizowaniu gui
	emitGuiAmmoChanged()
	#emit_signal("weapon_changed", current_weapon)
	
func _process(delta: float) -> void:
	if not current_weapon.semi_auto and Input.is_action_pressed("shoot"):
		current_weapon.shoot()

func _unhandled_input(event: InputEvent) -> void:
	 #zbyt dużo wykonań funkcji
	if current_weapon.semi_auto and event.is_action_released("shoot"):
		current_weapon.shoot()
	elif event.is_action_released("reload"):
		current_weapon.start_reload()
	elif event.is_action_released("weapon_1"):
		switch_weapon(weapons[0])
	elif event.is_action_released("weapon_2"):
		switch_weapon(weapons[1])

func reload():
	current_weapon.start_reload()
	
	
	
