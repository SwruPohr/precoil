package lang

Token :: struct {
	kind: Token_Kind,
	text: Maybe(string),
	col, row: int,
}

Token_Kind :: enum {
	INVALID,

	IDENT,
	KEYWORD,

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

