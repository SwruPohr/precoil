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
	LIT_CHR,
	

	BANG,
	DOLLAR,
	PERCENT,
	AMPERSAND,
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


	outer: for peek(&t) != 0 {

		// handle spaces
		for expect(&t, ' ') { }

		// handle newlines
		if expect_newline(&t) {
			for {
				if expect(&t, ' ') {
					fmt.eprintfln("ERROR: You may not indent with spaces.")
					fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
					return nil, false
				}
				else if !expect(&t, '\t') { continue outer }
			}
		}

		// handle invalid characters
		if expected_invalid(&t) {
			fmt.eprintfln("ERROR: could not tokenize symbol: '%c'(U+%04X)", peek(&t), peek(&t) )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		if (peek(&t) >= 0x7F) {
			fmt.eprintfln("TODO: UNICODE CHARACTERS NOT YET IMPLEMENTED")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle comments
		if expect(&t, '#') {
			for expect_not(&t, '\n') { }
			continue outer
		}

		token: Token
		token.col = t.col
		token.row = t.row
		start := t.pos

		// handle character literals
		if expect(&t, '\'') {
			fmt.eprintfln("TODO: CHAR LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}


		// handle string literals
		if expect(&t, '"') {
			fmt.eprintfln("TODO: STRING LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle numeric literals
		if expect_digit(&t) {
			fmt.eprintfln("TODO: NUMBER LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle simple tokens
		token.kind = peek_simples(&t)
		if token.kind != .INVALID {
			advance(&t)
			append(&t.tokens, token)
			continue outer
		}

		// handle identifiers
		if is_ident_start(peek(&t)) {
			token.kind = .IDENT
			pot_end := t.pos

			inner: for {
				if is_ident(peek(&t)) do advance(&t)
				else if is_space(peek(&t)) {
					//pot_end = t.pos
					break inner
				}
				else { break inner }
			}

			token.text = string(t.text[start:t.pos])
			//fmt.eprintfln("\"%s\"", token.text)
			append(&t.tokens, token)
			continue outer
		}


		if token.kind == .INVALID {
			fmt.eprintfln("ERROR: could not tokenize text: '%s'", t.text[start:t.pos+1])
			fmt.eprintfln("HINT: something has gone horribly wrong")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}
		
	}

	return t.tokens[:], true
}

