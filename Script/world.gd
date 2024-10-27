extends Node2D

@onready var AttackLable = $AttackLable
@onready var DefenseLable = $DefenseLable
@onready var HPLable = $HPLable

func _ready() -> void:
	HPLable.text = str(Global.PlayerStatus["hp"])
	AttackLable.text = str(Global.PlayerStatus["attack"])
	DefenseLable.text = str(Global.PlayerStatus["defense"])

func updateStatus() -> void:	
	AttackLable.text = str(Global.PlayerStatus["attack"])
	DefenseLable.text = str(Global.PlayerStatus["defense"])
	HPLable.text = str(Global.PlayerStatus["hp"])
	
