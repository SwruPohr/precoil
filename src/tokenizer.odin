package lang

Tokenizer :: struct {
	pos: int,
	col, row: int,
	text: []byte,
	tokens: [dynamic]Token,
}

peek :: proc(t: ^Tokenizer) -> u8 {
	if t.pos >= len(t.text) do return 0

	return t.text[t.pos]
}

advance :: proc(t: ^Tokenizer) {
	t.pos += 1
	t.col += 1
}

advance_line :: proc(t: ^Tokenizer) {
	t.pos += 1
	t.col = 1
	t.row += 1
}

is_invalid :: proc(v: u8) -> bool {
	return v <= ' '
}

is_newline :: proc(v: u8) -> bool {
	return v == '\n'
}

is_tab :: proc(v: u8) -> bool {
	return v == '\t'
}

is_whitespace :: proc(v: u8) -> bool {
	return v == ' '
}

is_lowercase_alpha :: proc(v: u8) -> bool {
	return (v >= 'a' && v <= 'z') 
}

is_uppercase_alpha :: proc(v: u8) -> bool {
	return (v >= 'A' && v <= 'Z') 
}

is_num :: proc(v: u8) -> bool {
	return (v >= '0' && v <= '9') 
}

is_alpha :: proc(v: u8) -> bool {
	return is_lowercase_alpha(v) || is_uppercase_alpha(v)
}

is_alphanum :: proc(v: u8) -> bool {
	return is_alpha(v) || is_num(v)
}

is_ident :: proc(v: u8) -> bool {
	return is_alphanum(v) || v == '_' || v == ' '
}

is_ident_start :: proc(v: u8) -> bool {
	return is_alpha(v) || v == '_'
}
