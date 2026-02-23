extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var grace_period: Timer = $GracePeriod
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ability_manager: Node = $AbilityManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_component: Node = $MovementComponent
@export var health_regen: int = 1

var base_speed = 0
var enemies_colliding = 0
var enemy_damage: int = 0
var max_health = 10

func _ready() -> void:
	health_component.current_health = max_health + (MetaProgression.get_upgrade_quantity("max_health") * 5)
	base_speed = movement_component.max_speed
	var speed_progress = MetaProgression.get_upgrade_quantity("move_speed")
	if speed_progress:
		movement_component.max_speed = base_speed + \
		(base_speed * speed_progress * 0.1)
	else:
		movement_component.max_speed = base_speed
	progress_bar.max_value = health_component.get_health_value()
	health_component.died.connect(on_died)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_increased.connect(on_health_increased)
	Global.ability_upgrade_added.connect(on_ability_upgrade_added)
	health_update()


func _process(delta: float) -> void:
	var direction = movement_vector().normalized()
	
	velocity = movement_component.accelerate_to_direction(direction)
	move_and_slide()

	if direction.x != 0 || direction.y != 0:
		animated_sprite_2d.play("Run")
	else:
		animated_sprite_2d.play("Idle")
	
	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_2d.scale.x = face_sign


func movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)


func check_if_damaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(enemy_damage)
	grace_period.start()
	

func health_update():
	progress_bar.value = health_component.get_health_value()
	

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	enemy_damage = area.enemy_damage()
	enemies_colliding += 1
	check_if_damaged()


func _on_player_hurt_box_area_exited(area: Area2D) -> void:
	enemies_colliding -= 1


func on_died():
	queue_free()


func on_health_decreased():
	$AudioStreamPlayer2D.play()
	Global.player_damaged.emit()
	health_update()


func on_health_increased():
	health_update()


func _on_grace_period_timeout() -> void:
	check_if_damaged()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade is NewAbility:
		var new_ability = upgrade as NewAbility
		ability_manager.add_child(new_ability.new_ability_scene.instantiate())


func _on_health_regen_timer_timeout() -> void:
	var health_regen_bonus = MetaProgression.get_upgrade_quantity("health_regeneration")
	health_component.take_heal(health_regen + health_regen_bonus)
