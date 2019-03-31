; random placement of letters layout
; force vowels on left hand

chars := StrSplit("abcdefghijklmnopqrstuvwxyz,./'")
rndres := []

nbTodo := chars.Length()

while nbTodo > 0 {
	outputdebug "todo " nbTodo
	idx := Random(1,nbTodo)
	char := chars[idx]
	if (instr("aeiouy", char)) {
		pos := Mod(rndres.Length(),11)
		if (pos > 5) {
			outputdebug "skip " char " at pos " pos 
			continue
		}
	}
	rndres.Push(char)
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