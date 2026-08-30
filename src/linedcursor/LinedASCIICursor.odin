package linedcursor

import utf "core:unicode/utf8"
import "local:mustr"

ASCIICursor :: struct {
	text: []byte,
	pos: int,
	col, row: int,
}

peek :: proc(t: ^ASCIICursor) -> u8 {
	if t.pos >= len(t.text) do return 0
	return t.text[t.pos]
}

empty :: proc(t: ^ASCIICursor) -> bool {
	return t.pos == len(t.text)
}

advance :: proc(t: ^ASCIICursor) {
	t.pos += 1
	t.col += 1
}

consume :: proc(t: ^ASCIICursor) -> u8 {
	x := peek(t)
	advance(t)
	return x
}

expect :: proc(t: ^ASCIICursor, char: u8) -> bool {
	if peek(t) != char do return false
	advance(t)
	return true
}

expect_only :: proc(t: ^ASCIICursor, char: u8) -> bool {
	return peek(t) == char
}

expect_not :: proc(t: ^ASCIICursor, char: u8) -> bool {
	if peek(t) == char do return false
	advance(t)
	return true
}

expect_ident :: proc(t: ^ASCIICursor) -> bool {
	if !mustr.is_ident(peek(t)) do return false
	advance(t)
	return true
}

expect_ident_num :: proc(t: ^ASCIICursor) -> bool {
	if ! (mustr.is_num(peek(t)) || mustr.is_ident(peek(t))) do return false
	advance(t)
	return true
}

expect_newline :: proc(t: ^ASCIICursor) -> bool {
	if peek(t) != '\n' do return false
	t.pos += 1
	t.col = 1
	t.row += 1
	return true
}


expect_invalid :: proc(t: ^ASCIICursor) -> bool {
	p := peek(t)

	// Control characters
	if mustr.is_invalid(p) {
		return true
	}

	return false 
}
