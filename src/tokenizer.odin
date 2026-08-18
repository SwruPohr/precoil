package lang

Tokenizer :: struct {
	pos: int,
	col, row: int,
	text: []byte,
	tokens: [dynamic]Token,
}

// hope that k < 0 
peek :: proc(t: ^Tokenizer, k: int = 0) -> u8 {
	if t.pos + k >= len(t.text) do return 0
	return t.text[t.pos + k]
}

advance :: proc(t: ^Tokenizer, k: int = 1) {
	t.pos += k
	t.col += k
}

consume :: proc(t: ^Tokenizer) -> u8 {
	advance(t)
	return peek(t, -1)
}

expect :: proc(t: ^Tokenizer, char: u8) -> bool {
	if peek(t) != char do return false
	advance(t)
	return true
}

expect_only :: proc(t: ^Tokenizer, char: u8) -> bool {
	return peek(t) == char
}

expect_not :: proc(t: ^Tokenizer, char: u8) -> bool {
	if peek(t) == char do return false
	advance(t)
	return true
}

expect_num :: proc(t: ^Tokenizer) -> bool {
	if !is_num(peek(t)) do return false
	advance(t)
	return true
}

expect_ident_num :: proc(t: ^Tokenizer) -> bool {
	if ! (is_num(peek(t)) || is_ident(peek(t))) do return false
	advance(t)
	return true
}

expect_newline :: proc(t: ^Tokenizer) -> bool {
	if peek(t) != '\n' do return false
	t.pos += 1
	t.col = 1
	t.row += 1
	return true
}


expect_invalid :: proc(t: ^Tokenizer) -> bool {
	p := peek(t)

	// Control characters
	if is_invalid(p) {
		return true
	}

	return false 
}



peek_simples :: proc(t: ^Tokenizer) -> Token_Kind {
	switch peek(t) {
		case '!': return .BANG
		case '$': return .DOLLAR
		case '%': return .PERCENT
		case '&': return .AMPERSAND
		case '(': return .LPAREN
		case ')': return .RPAREN
		case '*': return .ASTERISK
		case '+': return .PLUS
		case ',': return .COMMA
		case '-': return .MINUS
		case '.': return .PERIOD
		case '/': return .SLASH
		case ':': return .COLON
		case ';': return .SEMICOLON
		case '<': return .LT
		case '=': return .EQ
		case '>': return .GT
		case '?': return .QUESTION
		case '@': return .AT
		case '[': return .LBRACK
		case '\\':return .BACKSLASH
		case ']': return .RBRACK
		case '^': return .CARET
		case '_': return .UNDERSCORE
		case '`': return .GRAVE
		case '{': return .LCURLY
		case '|': return .BAR
		case '}': return .RCURLY
		case '~': return .TILDE
		case    : return .INVALID
	}
}

is_invalid :: proc(v: u8) -> bool {
	return (v <= ' ' || v == 0x7F)

	/* ONLY POSSIBLE AFTER EVERYTHING IS MADE UNICODE-FRIENDLY
	// Line/paragraph separators
	if p == 0x2028 || p == 0x2029 {
		return true
	}

	// Zero-width characters
	if p == 0x200B || p == 0x200C || p == 0x200D || p == 0xFEFF {
		return true
	}

	// Bidirectional overrides
	if p >= 0x202A && p <= 0x202E {
		return true
	}

	return false
	*/
}

is_space :: proc(v: u8) -> bool {
	return v == ' '
}

is_num :: proc(v: u8) -> bool {
	return (v >= '0' && v <= '9') 
}

is_alpha :: proc(v: u8) -> bool {
	return (v >= 'a' && v <= 'z') || (v >= 'A' && v <= 'Z')
}


is_ident :: proc(v: u8) -> bool {
	return is_alpha(v) || v >= 0x7F
}
