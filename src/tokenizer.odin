package lang

import "local:cursor"

Tokenizer :: struct {
	using lined_cursor: cursor.LinedASCIICursor,
	tokens: [dynamic]Token,
}

get_simples :: proc(char: u8) -> Token_Kind {
	switch char {
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
