package lang

import "core:fmt"
import "core:os"
import "core:strings"
import cursor "local:linedcursor"
import mustr "local:mustr"
import token "local:token"

tokenize :: proc(text: []byte) -> ([]Token, bool) {
	t: Tokenizer

	t.col = 1
	t.row = 1
	t.tokens = make([dynamic]Token, 0, 32)
	t.text = text

	outer: for {
		token: Token

		// handle spaces
		for {
			if cursor.empty(&t) {
				break outer
			}

			if !cursor.expect(&t, ' ') {
				break
			}
		}


		// handle newlines
		if cursor.line(&t) {
			// perfect example of DONE vs ERR vs NEXT
			for {
				if cursor.empty(&t) {
					break outer
				}

				if cursor.expect(&t, ' ') {
					fmt.eprintfln("ERROR: You may not indent with spaces.")
					fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
					return nil, false
				}

				if !cursor.expect(&t, '\t') { 
					continue outer 
				}
			}
		}

		if cursor.empty(&t) {
			break outer
		}

		if cursor.expect(&t, '\r') {
			fmt.eprintfln("ERROR: could not tokenize Carriage Return (CR, \\r)" )
			fmt.eprintfln("... at line #", t.row)
			return nil, false
		}

		// handle other invalid characters
		if cursor.hope(&t, mustr.is_invalid) {
			fmt.eprintfln("ERROR: could not tokenize symbol: '%c'(U+%04X)", cursor.peek(&t), cursor.peek(&t) )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		if (cursor.peek(&t) >= 0x7F) {
			fmt.eprintfln("TODO: NON-ASCII CHARACTERS NOT YET IMPLEMENTED")
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle comments
		if cursor.expect(&t, '#') {
			for {
				if cursor.empty(&t) {
					break outer
				}
				// we must handle these lines later in the line handler
				if cursor.hope(&t, '\n') {
					continue outer
				}
				cursor.advance(&t)
			}
			continue outer
		}

		token.col = t.col
		token.row = t.row
		start := t.pos

		if cursor.empty(&t) {
			break outer
		}

		// handle character literals
		if cursor.expect(&t, '\'') {
			fmt.eprintfln("TODO: CHAR LITERAL NOT YET IMPLEMENTED" )
			fmt.eprintfln("... at r, c = %i, %i", t.row, t.col)
			return nil, false
		}

		// handle raw literals
		if cursor.expect(&t, '`') {
			// remember, that if the last token was a "$", this is not a raw string but a raw identifier.
			fmt.eprintfln("TODO: RAW LITERAL NOT YET IMPLEMENTED" )
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
		if cursor.hope(&t, mustr.is_num) {
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
		if !cursor.hope(&t, mustr.is_alpha) {
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
			for {
				if cursor.empty(&t) {
					break inner
				}
				if !cursor.expect(&t, mustr.is_ident_or_num) {
					break
				}
			}

			append(&words, string(t.text[word_start:t.pos]))

			if cursor.empty(&t) {
				break inner
			}

			if cursor.hope(&t, ' ') {
				for {
					if cursor.empty(&t) {
						break inner
					}
					if !cursor.expect(&t, ' ') {
						break
					}
				}
				word_start = t.pos
			}

			if cursor.empty(&t) {
				break inner
			}

			if !cursor.expect(&t, mustr.is_ident) {
				break inner
			}
		}


		token.text = strings.join(words[:], " ")
		delete(words)
		append(&t.tokens, token)

	}

	return t.tokens[:], true
}
