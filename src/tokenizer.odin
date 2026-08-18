package lang

Tokenizer :: struct {
	pos: int,
	col, row: int,
	text: []byte,
	tokens: [dynamic]Token,
}


peek :: proc(t: ^Tokenizer, k: int = 0) -> u8 {
	if t.pos + k >= len(t.text) do return 0
	return t.text[t.pos + k]
}

empty :: proc(t: ^Tokenizer) -> bool {
	return t.pos == len(t.text)
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

expect_ident :: proc(t: ^Tokenizer) -> bool {
	if !is_ident(peek(t)) do return false
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
