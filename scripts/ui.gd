class_name GameUI
extends Control

@onready var wave_label: Label = get_node_or_null("WaveLabel")
@onready var coins_label: Label = get_node_or_null("CoinsLabel")
@onready var castle_health_label: Label = get_node_or_null("CastleHealthLabel")
@onready var wave_status_label: Label = get_node_or_null("WaveStatusLabel")
@onready var passive_label: Label = get_node_or_null("PassiveLabel")
@onready var boss_health_label: Label = get_node_or_null("BossHealthLabel")
@onready var damage_upgrade_button: Button = get_node_or_null("DamageUpgradeButton")
@onready var attack_speed_upgrade_button: Button = get_node_or_null("AttackSpeedUpgradeButton")
@onready var critical_chance_upgrade_button: Button = get_node_or_null("CriticalChanceUpgradeButton")
@onready var critical_damage_upgrade_button: Button = get_node_or_null("CriticalDamageUpgradeButton")
@onready var arrow_speed_upgrade_button: Button = get_node_or_null("ArrowSpeedUpgradeButton")
@onready var range_upgrade_button: Button = get_node_or_null("RangeUpgradeButton")
@onready var castle_health_upgrade_button: Button = get_node_or_null("CastleHealthUpgradeButton")

var upgrade_manager: UpgradeManager
var active_boss: Enemy
var upgrade_buttons: Array[Button] = []

func _ready() -> void:
	GameState.wave_changed.connect(_on_wave_changed)
	Economy.coins_changed.connect(_on_coins_changed)
	var castle := get_node_or_null("../Castle") as Castle
	if castle:
		castle.health_changed.connect(set_castle_health)
		set_castle_health(castle.health, castle.max_health)
	var wave_manager := get_node_or_null("../WaveManager") as WaveManager
	if wave_manager:
		wave_manager.wave_started.connect(_on_wave_started)
		wave_manager.wave_completed.connect(_on_wave_completed)
		wave_manager.intermission_started.connect(_on_intermission_started)
		wave_manager.intermission_ended.connect(_on_intermission_ended)
		wave_manager.boss_spawned.connect(_on_boss_spawned)
		wave_manager.boss_defeated.connect(_on_boss_defeated)
	upgrade_manager = get_node_or_null("../UpgradeManager") as UpgradeManager
	if upgrade_manager:
		upgrade_manager.passive_unlocked.connect(_on_passive_unlocked)
		upgrade_manager.upgrades_changed.connect(_on_upgrades_changed)
		set_passive_text(upgrade_manager.get_first_passive_text())
		_update_upgrade_buttons()

	upgrade_buttons = [
		damage_upgrade_button,
		attack_speed_upgrade_button,
		critical_chance_upgrade_button,
		critical_damage_upgrade_button,
		arrow_speed_upgrade_button,
		range_upgrade_button,
		castle_health_upgrade_button
	]
	_set_upgrades_visible(false)

	if damage_upgrade_button:
		damage_upgrade_button.pressed.connect(_on_damage_upgrade_pressed)
	if attack_speed_upgrade_button:
		attack_speed_upgrade_button.pressed.connect(_on_attack_speed_upgrade_pressed)
	if critical_chance_upgrade_button:
		critical_chance_upgrade_button.pressed.connect(_on_critical_chance_upgrade_pressed)
	if critical_damage_upgrade_button:
		critical_damage_upgrade_button.pressed.connect(_on_critical_damage_upgrade_pressed)
	if arrow_speed_upgrade_button:
		arrow_speed_upgrade_button.pressed.connect(_on_arrow_speed_upgrade_pressed)
	if range_upgrade_button:
		range_upgrade_button.pressed.connect(_on_range_upgrade_pressed)
	if castle_health_upgrade_button:
		castle_health_upgrade_button.pressed.connect(_on_castle_health_upgrade_pressed)
	_on_wave_changed(GameState.current_wave)
	_on_coins_changed(Economy.get_coins())

func _on_wave_changed(wave: int) -> void:
	if wave_label:
		wave_label.text = "Wave: %d" % wave

func _on_coins_changed(amount: int) -> void:
	if coins_label:
		coins_label.text = "Coins: %d" % amount
	_update_upgrade_buttons()

func _on_wave_started(wave: int) -> void:
	_set_upgrades_visible(false)
	if wave_status_label:
		if wave % WaveManager.MAJOR_BOSS_INTERVAL == 0:
			wave_status_label.text = "Wave %d: MAJOR BOSS INCOMING" % wave
		elif wave % WaveManager.MINI_BOSS_INTERVAL == 0:
			wave_status_label.text = "Wave %d: MINI BOSS INCOMING" % wave
		else:
			wave_status_label.text = "Wave %d: enemies incoming" % wave

func _on_wave_completed(wave: int) -> void:
	if wave_status_label:
		wave_status_label.text = "Wave %d cleared. Preparing intermission..." % wave

func _on_intermission_started(wave: int, duration: float) -> void:
	_set_upgrades_visible(true)
	if wave_status_label:
		wave_status_label.text = "Wave %d cleared. Upgrade your archer. Next wave in %.0f seconds." % [wave, duration]

func _on_intermission_ended(_wave: int) -> void:
	_set_upgrades_visible(false)

func _set_upgrades_visible(visible: bool) -> void:
	for button in upgrade_buttons:
		if button:
			button.visible = visible

func _on_boss_spawned(boss: Enemy) -> void:
	active_boss = boss
	var boss_name := get_boss_name(boss)
	if boss_health_label:
		boss_health_label.visible = true
		boss_health_label.text = "%s: %.0f / %.0f" % [boss_name, boss.stats.health, boss.stats.max_health]
	boss.boss_health_changed.connect(_on_boss_health_changed)
	boss.boss_phase_changed.connect(_on_boss_phase_changed)
	boss.boss_shield_changed.connect(_on_boss_shield_changed)
	if wave_status_label:
		wave_status_label.text = "%s HAS ARRIVED: defeat it for %d coins!" % [boss_name, boss.coin_reward]

func _on_boss_health_changed(current: float, maximum: float) -> void:
	if boss_health_label == null or active_boss == null:
		return
	var boss_name := get_boss_name(active_boss)
	if active_boss.boss_shield_active:
		boss_health_label.text = "%s: %.0f / %.0f | SHIELD: %.0f / %.0f" % [boss_name, current, maximum, active_boss.boss_shield, active_boss.boss_shield_max]
	else:
		boss_health_label.text = "%s: %.0f / %.0f" % [boss_name, current, maximum]

func _on_boss_shield_changed(current: float, maximum: float) -> void:
	if boss_health_label == null or active_boss == null or not active_boss.is_major_boss:
		return
	if maximum <= 0.0:
		return
	boss_health_label.text = "%s: %.0f / %.0f | SHIELD: %.0f / %.0f" % [get_boss_name(active_boss), active_boss.stats.health, active_boss.stats.max_health, current, maximum]

func _on_boss_phase_changed(phase_name: String) -> void:
	if active_boss == null:
		return
	var boss_name := get_boss_name(active_boss)
	if phase_name == "SHIELDED":
		if wave_status_label:
			wave_status_label.text = "%s SHIELD ACTIVE: break it to continue!" % boss_name
		return
	if phase_name == "ENRAGED":
		if wave_status_label:
			wave_status_label.text = "%s ENRAGED: move faster, hits harder!" % boss_name

func _on_boss_defeated(boss: Enemy) -> void:
	var boss_name := get_boss_name(boss)
	var reward := boss.coin_reward
	active_boss = null
	if boss_health_label:
		boss_health_label.visible = false
	if wave_status_label:
		wave_status_label.text = "%s DEFEATED: +%d coins!" % [boss_name, reward]

func get_boss_name(boss: Enemy) -> String:
	if boss and boss.is_major_boss:
		return "MAJOR BOSS"
	return "MINI BOSS"

func _on_passive_unlocked(_display_name: String) -> void:
	set_passive_text("Passive: Sharpened Arrows (+1 Damage)")
	if wave_status_label:
		wave_status_label.text = "Passive unlocked: +1 Damage"

func _on_upgrades_changed() -> void:
	if upgrade_manager:
		set_passive_text(upgrade_manager.get_first_passive_text())
	_update_upgrade_buttons()

func _on_damage_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_damage_upgrade():
		if wave_status_label:
			wave_status_label.text = "Damage upgraded: +1"
	_update_upgrade_buttons()

func _on_attack_speed_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_attack_speed_upgrade():
		if wave_status_label:
			wave_status_label.text = "Attack Speed upgraded: +0.1"
	_update_upgrade_buttons()

func _on_critical_chance_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_critical_chance_upgrade():
		if wave_status_label:
			wave_status_label.text = "Crit Chance upgraded: +5%"
	_update_upgrade_buttons()

func _on_critical_damage_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_critical_damage_upgrade():
		if wave_status_label:
			wave_status_label.text = "Crit Damage upgraded: +0.5x"
	_update_upgrade_buttons()

func _on_arrow_speed_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_arrow_speed_upgrade():
		if wave_status_label:
			wave_status_label.text = "Arrow Speed upgraded: +100"
	_update_upgrade_buttons()

func _on_range_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_range_upgrade():
		if wave_status_label:
			wave_status_label.text = "Range upgraded: +100"
	_update_upgrade_buttons()

func _on_castle_health_upgrade_pressed() -> void:
	if upgrade_manager and upgrade_manager.buy_castle_health_upgrade():
		if wave_status_label:
			wave_status_label.text = "Castle Health upgraded: +25"
	_update_upgrade_buttons()

func _update_upgrade_buttons() -> void:
	if upgrade_manager == null:
		return
	if damage_upgrade_button:
		damage_upgrade_button.text = upgrade_manager.get_damage_upgrade_text()
		damage_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.DAMAGE_UPGRADE_COST)
	if attack_speed_upgrade_button:
		attack_speed_upgrade_button.text = upgrade_manager.get_attack_speed_upgrade_text()
		attack_speed_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.ATTACK_SPEED_UPGRADE_COST)
	if critical_chance_upgrade_button:
		critical_chance_upgrade_button.text = upgrade_manager.get_critical_chance_upgrade_text()
		critical_chance_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.CRITICAL_CHANCE_UPGRADE_COST)
	if critical_damage_upgrade_button:
		critical_damage_upgrade_button.text = upgrade_manager.get_critical_damage_upgrade_text()
		critical_damage_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.CRITICAL_DAMAGE_UPGRADE_COST)
	if arrow_speed_upgrade_button:
		arrow_speed_upgrade_button.text = upgrade_manager.get_arrow_speed_upgrade_text()
		arrow_speed_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.ARROW_SPEED_UPGRADE_COST)
	if range_upgrade_button:
		range_upgrade_button.text = upgrade_manager.get_range_upgrade_text()
		range_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.RANGE_UPGRADE_COST)
	if castle_health_upgrade_button:
		castle_health_upgrade_button.text = upgrade_manager.get_castle_health_upgrade_text()
		castle_health_upgrade_button.disabled = not Economy.can_spend(UpgradeManager.CASTLE_HEALTH_UPGRADE_COST)

func set_passive_text(text: String) -> void:
	if passive_label:
		passive_label.text = text

func set_castle_health(current: float, maximum: float) -> void:
	if castle_health_label:
		castle_health_label.text = "Castle: %.0f / %.0f" % [current, maximum]
