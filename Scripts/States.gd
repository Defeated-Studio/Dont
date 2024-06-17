extends Node3D

func saveStates():
	var nodes = get_tree().get_nodes_in_group("StatesGroup")
	NodeStates.states = []
	for node in nodes:
		NodeStates.states.push_back(node.getState())


func setStates():
	var nodes = get_tree().get_nodes_in_group("StatesGroup")
	for i in range(len(NodeStates.states)):
		nodes[i].setState(NodeStates.states[i])


func savePapersTaken():
	var diary = get_tree().get_nodes_in_group("DiaryGroup")
	NodeStates.papers_taken = diary[0].papers_taken


func setPapersTaken():
	var diary = get_tree().get_nodes_in_group("DiaryGroup")
	diary[0].papers_taken = NodeStates.papers_taken
