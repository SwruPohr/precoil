package lang

import "core:fmt"
import "core:os"

Token :: struct {
	kind: Token_Kind,
	text: Maybe(string),
	col, row: int,
}

Token_Kind :: enum {
	INVALID,

	IDENT,
	
	LIT_NUM,
	LIT_STR,
	

	BANG,
	QUOTE,
	HASH,
	DOLLAR,
	PERCENT,
	AMPERSAND,
	APOSTROPHE,
	LPAREN,
	RPAREN,
	ASTERISK,
	PLUS,
	COMMA,
	MINUS,
	PERIOD,
	SLASH,
	COLON,
	SEMICOLON,
	LT,
	EQ,
	GT,
	QUESTION,
	AT,
	LBRACK,
	BACKSLASH,
	RBRACK,
	CARET,
	UNDERSCORE,
	GRAVE,
	LCURLY,
	BAR,
	RCURLY,
	TILDE,

}



tokenize :: proc(text: []byte) -> ([]Token, bool) {
	return pre_tokenize(text)
}

pre_tokenize :: proc(text: []byte) -> ([]Token, bool) {
	t: Tokenizer
	t.col = 1
	t.row = 1
	t.tokens = make([dynamic]Token, 0, 32)
	t.text = text

	for peek(&t) != 0 {
		token: Token
		token.col = t.col
		token.row = t.row

		start := t.pos

		if is_newline(peek(&t)) {
			advance_line(&t)
			for {
				if is_whitespace(peek(&t)) {
					fmt.eprintfln("ERROR: You may not indent with spaces.")
					return nil, false
				}
				else if is_tab(peek(&t)) do advance(&t)
				else do break
			}
			continue
		}

		if is_whitespace(peek(&t)) {
			advance(&t)
			continue
		}

		if is_invalid(peek(&t)) {
			fmt.eprintfln("ERROR: could not tokenize symbol: '%c'(U+%04X)", peek(&t), peek(&t) )
			return nil, false
		}

		

		if is_ident_start(peek(&t)) {
			token.kind = .IDENT

			for is_ident(peek(&t)) {
				advance(&t)
			}

			token.text = string(t.text[start:t.pos])
			fmt.eprintfln("\"%s\"", token.text)
			append(&t.tokens, token)
			continue
		}

		switch peek(&t) {
			case '!': token.kind = .BANG
			case '"': token.kind = .QUOTE
			case '#': token.kind = .HASH
			case '$': token.kind = .DOLLAR
			case '%': token.kind = .PERCENT
			case '&': token.kind = .AMPERSAND
			case '\'': token.kind = .APOSTROPHE
			case '(': token.kind = .LPAREN
			case ')': token.kind = .RPAREN
			case '*': token.kind = .ASTERISK
			case '+': token.kind = .PLUS
			case ',': token.kind = .COMMA
			case '-': token.kind = .MINUS
			case '.': token.kind = .PERIOD
			case '/': token.kind = .SLASH
			case ':': token.kind = .COLON
			case ';': token.kind = .SEMICOLON
			case '<': token.kind = .LT
			case '=': token.kind = .EQ
			case '>': token.kind = .GT
			case '?': token.kind = .QUESTION
			case '@': token.kind = .AT
			case '[': token.kind = .LBRACK
			case '\\': token.kind = .BACKSLASH
			case ']': token.kind = .RBRACK
			case '^': token.kind = .CARET
			case '_': token.kind = .UNDERSCORE
			case '`': token.kind = .GRAVE
			case '{': token.kind = .LCURLY
			case '|': token.kind = .BAR
			case '}': token.kind = .RCURLY
			case '~': token.kind = .TILDE
		}

		if token.kind == .INVALID {
			fmt.eprintfln("ERROR: could not tokenize text: '%s'", t.text[start:t.pos+1])
			return nil, false
		}
		
		append(&t.tokens, token)
		advance(&t)
	}

	return t.tokens[:], true
}

