package token

import cursor "local:linedcursor"

DBGTokenizer :: struct($K: typeid) {
	using lined_cursor: cursor.ASCIICursor,
	tokens: [dynamic]DBGToken(K),
}

Tokenizer :: struct($K: typeid) {
	using lined_cursor: cursor.ASCIICursor,
	tokens: [dynamic]Token(K),
}

DBGToken :: struct($K: typeid) {
	kind: K,
	text: Maybe(string),
	col, row: int,
}

Token :: struct($K: typeid) {
	kind: K,
	text: Maybe(string),
}
