package lang

import token "local:token"

TK :: enum {
	INVALID,

	IDENT,
	RAW_IDENT, // $`_hi` for working with other langs
	KEYWORD, // a keyword is just an ident that is in the list of keywords

	LIT_NUM, // numeric literal with 0..9
	LIT_STR, // string literal, with ""
	LIT_RAW, // raw string literal, with ``
	LIT_CHR, // char literal, with ''


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
	LCURLY,
	BAR,
	RCURLY,
	TILDE,

	DBL_DOLLAR, // $$
	DBL_PERCENT, // %%
	DBL_AMPERSAND, // &&
	DBL_ASTERISK, // **
	DBL_PLUS, // ++
	DBL_MINUS, // --
	DBL_PERIOD, // ..
	DBL_SLASH, // //
	DBL_COLON, // ::
	DBL_LT, // <<
	DBL_EQ, // ==
	DBL_GT, // >>
	DBL_QUESTION, // ??
	DBL_CARET, // ^^
	DBL_BAR, // ||

	BANG_EQ, // !=
	DOLLAR_EQ, // $=
	PERCENT_EQ, // %=
	AMPERSAND_EQ, // &=
	ASTERISK_EQ, // *=
	PLUS_EQ, // +=
	MINUS_EQ, // -=
	PERIOD_EQ, // .=
	SLASH_EQ, // /=
	COLON_EQ, // :=
	LT_EQ, // <=
	GT_EQ, // >=
	QUESTION_EQ, // ?=
	AT_EQ, // @=
	CARET_EQ, // ^=
	BAR_EQ, // |=
	TILDE_EQ, // ~=

	TRPL_ASTERISK, // ***
	TRPL_PLUS,     // +++
	TRPL_MINUS,    // ---
	TRPL_PERIOD,   // ...
	TRPL_COLON,    // :::
	TRPL_EQ,       // ===

	STICKY,
	// -, >, <, =, and | are sticky (ie if you have -><=|=><- this is one operator, there are infinite operators.)
}
// NOTE: DBL_AT is does not exist because @ is for references

Token :: token.DBGToken(TK)
Tokenizer :: token.DBGTokenizer(TK)

get_simples :: proc(char: u8) -> TK {
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
		case '{': return .LCURLY
		case '|': return .BAR
		case '}': return .RCURLY
		case '~': return .TILDE
		case    : return .INVALID
	}
}


is_sticky :: proc(kind: TK) -> bool {
	#partial switch kind {
	case .MINUS, .LT, .GT, .EQ, .BAR:
		return true
	}
	return false
}
