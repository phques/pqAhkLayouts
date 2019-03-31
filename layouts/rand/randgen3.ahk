; random placement of letters layout
; force vowels on mid row

rndres := []

; 1st random place vowels on mid row (index 11-20)
midRowIdxs := [11,12,13,14,15,16,17,18,19,20]
vowels := ["a","e","i","o","u","y"]
nbTodo := 6

while nbTodo > 0 {
	outputdebug "vowels todo " nbTodo
	idx := Random(1, midRowIdxs.Length())
	idx := midRowIdxs[idx]
	midRowIdxs.RemoveAt(idx)

	char := vowels.Pop()
	rndres[idx] := char
	nbTodo--
}


; then do rest, skipping already used spots
chars := StrSplit("bcdfghjklmnpqrstvwxz,./'")
nbTodo := chars.Length()
insertIdx := 1

while nbTodo > 0 {
	outputdebug "todo " nbTodo
	idx := Random(1,nbTodo)
	char := chars[idx]
	chars.RemoveAt(idx)

	while rndres[insertIdx] {
		insertIdx++
	}
	rndres[insertIdx] := char
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