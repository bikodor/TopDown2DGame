extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var death_scene: PackedScene
@export var sprite: CompressedTexture2D
@onready var movement_component: Node = $MovementComponent


func _ready() -> void:
	health_component.died.connect(on_died)


func _process(delta: float) -> void:
	var direction = movement_component.get_direction()
	movement_component.move_to_player(self)

	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_2d.scale.x = face_sign


func on_died():
	var back_layer = get_tree().get_first_node_in_group("back_layer")
	var death_instance = death_scene.instantiate() as DeathComponent
	back_layer.add_child(death_instance)
	death_instance.gpu_particles_2d.texture = sprite
	death_instance.sprite_offset.position.y = animated_sprite_2d.offset.y
	death_instance.global_position = global_position
	queue_free()
