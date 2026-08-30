package lang

import "core:fmt"
import "core:os"
import "core:strings"
import cursor "local:linedcursor"
import mustr "local:mustr"
import token "local:token"

tokenize :: proc(text: []byte) -> ([]Token, bool) {
	return pre_tokenize(text)
}

pre_tokenize :: proc(text: []byte) -> ([]Token, bool) {
	t: Tokenizer

	t.col = 1
	t.row = 1
	t.tokens = make([dynamic]Token, 0, 32)
	t.text = text


	outer: for {
		token: Token

		// handle spaces
		for cursor.expect(&t, ' ') { }

		// handle newlines
		if cursor.expect_newline(&t) {
			for {
				if cursor.expect(&t, ' ') {
					fmt.eprintfln("ERROR: You may not indent with spaces.")
					fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
					return nil, false
				}
				else if !cursor.expect(&t, '\t') { continue outer }
			}
		}

		if cursor.empty(&t) { break outer }

		// handle invalid characters
		if cursor.expect_invalid(&t) {
			fmt.eprintfln("ERROR: could not tokenize symbol: '%c'(U+%04X)", cursor.peek(&t), cursor.peek(&t) )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		if (cursor.peek(&t) >= 0x7F) {
			fmt.eprintfln("TODO: UNICODE CHARACTERS NOT YET IMPLEMENTED")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle comments
		if cursor.expect(&t, '#') {
			for cursor.expect_not(&t, '\n') { }
			continue outer
		}

		token.col = t.col
		token.row = t.row
		start := t.pos

		// handle character literals
		if cursor.expect(&t, '\'') {
			fmt.eprintfln("TODO: CHAR LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}


		// handle string literals
		if cursor.expect(&t, '"') {
			fmt.eprintfln("TODO: STRING LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle numeric literals
		if mustr.is_num(cursor.peek(&t)) {
			fmt.eprintfln("TODO: NUMBER LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle simple tokens
		token.kind = get_simples(cursor.peek(&t))
		if token.kind != .INVALID {
			cursor.advance(&t)
			append(&t.tokens, token)
			continue outer
		}

		// At this point, we've handled digits, punctuation, and whitespace in earlier branches.
		// If we get here and it's not alphabetic, something impossible has happened.
		// TODO: remove when unicode support added
		if !mustr.is_alpha(cursor.peek(&t)) {
			fmt.eprintfln("ERROR: impossible symbol: '%c'(U+%04X)", cursor.peek(&t), cursor.peek(&t) )
			fmt.eprintfln("HINT: something has gone horribly wrong")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// finally start to do identifiers
		token.kind = .IDENT
		words := make([dynamic]string)
		word_start := t.pos

		inner: for {

			for cursor.expect_ident_num(&t) { }

			append(&words, string(t.text[word_start:t.pos]))

			if cursor.expect_only(&t, ' ') {

				for cursor.expect(&t, ' ') { }
				word_start = t.pos
			}

			if !cursor.expect_ident(&t) { break inner }
		}


		token.text = strings.join(words[:], " ")
		delete(words)
		append(&t.tokens, token)

	}

	return t.tokens[:], true
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
