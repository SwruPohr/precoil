package cursor

import utf "core:unicode/utf8"
import "local:mustr"

LinedASCIICursor :: struct {
	using cursor: ASCIICursor,  // embed base cursor
	col, row: int,
}

advance :: proc(t: ^LinedASCIICursor) {
	t.cursor.pos += 1
	t.col += 1
}

consume :: proc(t: ^LinedASCIICursor) -> u8 {
	x := peek(t)
	advance(t)
	return x
}

expect :: proc(t: ^LinedASCIICursor, char: u8) -> bool {
	if peek(t) != char do return false
	advance(t)
	return true
}

expect_only :: proc(t: ^LinedASCIICursor, char: u8) -> bool {
	return peek(t) == char
}

expect_not :: proc(t: ^LinedASCIICursor, char: u8) -> bool {
	if peek(t) == char do return false
	advance(t)
	return true
}

expect_ident :: proc(t: ^LinedASCIICursor) -> bool {
	if !mustr.is_ident(peek(t)) do return false
	advance(t)
	return true
}

expect_ident_num :: proc(t: ^LinedASCIICursor) -> bool {
	if ! (mustr.is_num(peek(t)) || mustr.is_ident(peek(t))) do return false
	advance(t)
	return true
}

expect_newline :: proc(t: ^LinedASCIICursor) -> bool {
	if peek(t) != '\n' do return false
	t.pos += 1
	t.col = 1
	t.row += 1
	return true
}


expect_invalid :: proc(t: ^LinedASCIICursor) -> bool {
	p := peek(t)

	// Control characters
	if mustr.is_invalid(p) {
		return true
	}

	return false 
}
