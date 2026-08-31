package cursor


// Character is the typical return character type
// it is u8 or a byte since this is an ASCII cursor.
Character   :: u8


Predicate   :: proc(Character) -> bool


// ASCIICursor provides a forward-only cursor over a byte slice.
//
// The cursor's position is always in the range:
//
//     0 <= pos <= len(text)
//
// A position equal to len(text) represents EOF.
//
// All procedures except empty require the cursor not to be at EOF.
// Callers should check !empty(t) before calling them.
ASCIICursor :: struct {
	text: []Character,
	pos:  int,
}


make :: #force_inline proc(text: []Character) -> ASCIICursor {
	return ASCIICursor{text = text, pos = 0}
}

reset :: #force_inline proc(t: ^ASCIICursor) {
	t.pos = 0
}

// empty reports whether the cursor is at or past the end of the input.
//
// This is the only operation that may be called when the cursor is at EOF.
empty :: #force_inline proc(t: ^ASCIICursor) -> bool {
	return t.pos >= len(t.text)
}

line :: #force_inline proc(t: ^ASCIICursor) -> bool {
	if peek(t) != '\n' {
		return false
	}

	t.pos += 1

	return true
}

// Everything below;
// Preconditions:
//     !empty(t)


peek :: #force_inline proc(t: ^ASCIICursor) -> Character {
	#no_bounds_check return t.text[t.pos]
}

advance :: #force_inline proc(t: ^ASCIICursor) {
	t.pos += 1
}

consume :: #force_inline proc(t: ^ASCIICursor) -> Character {
	result := peek(t)
	advance(t)
	return result
}


hope_char :: #force_inline proc(t: ^ASCIICursor, char: Character) -> bool {
	return peek(t) == char
}

hope_pred :: #force_inline proc(t: ^ASCIICursor, $pred: Predicate) -> bool {
	return pred(peek(t))
}


expect_char :: #force_inline proc(t: ^ASCIICursor, char: Character) -> bool {
	if hope_char(t, char) {
		advance(t)
		return true
	}

	return false
}

expect_not_char :: #force_inline proc(t: ^ASCIICursor, char: Character) -> bool {
	if hope_char(t, char) {
		return false
	}

	advance(t)
	return true
}

expect_pred :: #force_inline proc(t: ^ASCIICursor, $pred: Predicate) -> bool  {
	if hope_pred(t, pred) {
		advance(t)
		return true
	}

	return false
}

expect_not_pred :: #force_inline proc(t: ^ASCIICursor, $pred: Predicate) -> bool {
	if hope_pred(t, pred) {
		return false
	}

	advance(t)
	return true
}

hope :: proc{
	hope_char,
	hope_pred
}

expect :: proc{
	expect_char,
	expect_pred
}

expect_not :: proc{
	expect_not_char,
	expect_not_pred
}
