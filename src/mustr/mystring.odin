package mustr

is_invalid :: proc(v: u8) -> bool {
	return (v <= ' ' || v == 0x7F)

	/* ONLY POSSIBLE AFTER EVERYTHING IS MADE UNICODE-FRIENDLY
	// Line/paragraph separators
	if p == 0x2028 || p == 0x2029 {
		return true
	}

	// Zero-width characters
	if p == 0x200B || p == 0x200C || p == 0x200D || p == 0xFEFF {
		return true
	}

	// Bidirectional overrides
	if p >= 0x202A && p <= 0x202E {
		return true
	}

	return false
	*/
}

is_space :: proc(v: u8) -> bool {
	return v == ' '
}

is_num :: proc(v: u8) -> bool {
	return (v >= '0' && v <= '9') 
}

is_alpha :: proc(v: u8) -> bool {
	return (v >= 'a' && v <= 'z') || (v >= 'A' && v <= 'Z')
}


is_ident :: proc(v: u8) -> bool {
	return is_alpha(v) || v >= 0x7F
}

is_ident_or_num :: proc(v: u8) -> bool {
	return is_ident(v) || is_num(v)
}
