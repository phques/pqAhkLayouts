; random placement of letters layout

chars := StrSplit("abcdefghijklmnopqrstuvwxyz,./'")
rndres := []

nbTodo := chars.Length()

while nbTodo > 0 {
	idx := Random(1,nbTodo)
	rndres.Push(chars[idx])
	chars.RemoveAt(idx)
	nbTodo--
}

ln1 := ""
ln2 := ""
ln3 := ""
loop 10 {
	ln1 .= rndres[a_index] ' '
	ln2 .= rndres[a_index+10] ' '
	ln3 .= rndres[a_index+20]  ' '
}

outputdebug ln1
outputdebug ln2
outputdebug ln3