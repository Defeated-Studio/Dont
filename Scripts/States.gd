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
