package lang

import "core:fmt"
import "core:os"
import "core:strings"



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

		if empty(&t) { break outer }

		// handle invalid characters
		if expect_invalid(&t) {
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
		if is_num(peek(&t)) {
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

		// At this point, we've handled digits, punctuation, and whitespace in earlier branches.
		// If we get here and it's not alphabetic, something impossible has happened.
		// TODO: remove when unicode support added
		if !is_alpha(peek(&t)) {
			fmt.eprintfln("ERROR: impossible symbol: '%c'(U+%04X)", peek(&t), peek(&t) )
			fmt.eprintfln("HINT: something has gone horribly wrong")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// finally start to do identifiers
		token.kind = .IDENT
		words := make([dynamic]string)
		word_start := t.pos

		inner: for {

			for expect_ident_num(&t) { }

			append(&words, string(t.text[word_start:t.pos]))

			if expect_only(&t, ' ') {

				for expect(&t, ' ') { }
				word_start = t.pos
			}

			if !expect_ident(&t) { break inner }
		}


		token.text = strings.join(words[:], " ")
		delete(words)
		append(&t.tokens, token)

	}

	return t.tokens[:], true
}

