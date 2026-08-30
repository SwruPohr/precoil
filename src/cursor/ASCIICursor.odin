package cursor

import utf "core:unicode/utf8"

ASCIICursor :: struct {
	text: []byte,
	pos: int,
}


peek :: proc(t: ^ASCIICursor) -> u8 {
	if t.pos >= len(t.text) do return 0
	return t.text[t.pos]
}

empty :: proc(t: ^ASCIICursor) -> bool {
	return t.pos == len(t.text)
}


