package lang

import utf "core:unicode/utf8"

ASCIICursor :: struct {
	pos: int,
	text: []byte,
}



peek :: proc(t: ^ASCIICursor) -> u8 {
	if t.pos >= len(t.text) do return 0
	return t.text[t.pos]
}
