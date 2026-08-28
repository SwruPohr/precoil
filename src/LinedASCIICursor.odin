package lang

import utf "core:unicode/utf8"


LinedASCIICursor :: struct {
	using cursor: ASCIICursor,  // embed base cursor
	col, row: int,
}
