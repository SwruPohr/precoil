package lang

import token "local:token"

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

Token :: token.Token(Token_Kind)
Tokenizer :: token.Tokenizer(Token_Kind)
