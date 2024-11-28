extends Node
signal end 
signal delnpc

func emitend() :
	emit_signal("end")
	
func emitdel() :
	emit_signal("delnpc")

func showd(id : int,name : String) :
	var path = "%s%s%s" % ["res://Balloon/Talk_balloon_",id,".tscn"]
	DialogueManager.show_dialogue_balloon(path,load("res://dialogue.dialogue"),name)

func NPC_go_school():
	showd(1,"NPC_go_school")
	await(end)
	
func go_school() :
	showd(1,"go_school_1")
	await(end)

func base_end() :
	showd(1,"base_end_1")
	await(end)
	showd(3,"base_end_2")
	await(end)
	Global.money += 50

func start() :
	showd(1,"start1_1")
	await(end)
	showd(2,"start1_2")
	await(end)
	showd(3,"start1_3")
	await(end)
	showd(1,"start1_4")
	await(end)
	showd(3,"start1_5")
	await(end)

func base1() :
	showd(1,"base1_1")
	await(end)

func sayhello() :
	showd(2,"title1")
	await(end)
	
func sayhello2() :
	showd(2,"title2")
	await(end)

func sayhello3() :
	showd(2,"title3")
	await(end)

func sayhello4() :
	showd(2,"title4")
	await(end)

func sayhello5() :
	showd(2,"title5")
	await(end)

func sayhello6() :
	showd(2,"title6")
	await(end)

func sayhello7() :
	showd(2,"title7")
	await(end)

func NPC1() :
	showd(3,"NPC1")
