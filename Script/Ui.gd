extends Node2D



func _process(delta: float) -> void:	
	$Attack/AttackLable.text = str(Global.atk)
	$Defense/DefenseLable.text = str(Global.def)
	$HP/HPLable.text = str(Global.hp)
	$armor/armorLable.text = str(Global.arm)
	$money/moneyLable.text = str(Global.money)
	$ykey/ykeyLable.text = str(Global.ykey)
	$bkey/bkeyLable.text = str(Global.bkey)
	$rkey/rkeyLable.text = str(Global.rkey)
	$gkey/gkeyLable.text = str(Global.gkey)

	
