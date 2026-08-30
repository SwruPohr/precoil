package token

import cursor "local:linedcursor"

Tokenizer :: struct($K: typeid) {
	using lined_cursor: cursor.ASCIICursor,
	tokens: [dynamic]Token(K),
}

Token :: struct($K: typeid) {
	kind: K,
	text: Maybe(string),
	col, row: int,
}
