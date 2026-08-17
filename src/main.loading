package main 

import "core:fmt"
import "core:os"
import "core:strings"


ANSIESC :: enum(u8) {
	black = 30,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	magenta = 35,
	cyan = 36,
	white = 37,

	bright_black = 90,
	bright_red = 91,
	bright_green = 92,
	bright_yellow = 93,
	bright_blue = 94,
	bright_magenta = 95,
	bright_cyan = 96,
	bright_white = 97,

	reset = 0,
}

Commands :: enum(u8) {
	Help,
	Tokenize,
	Parse,
	Link,
	Optimize,
	Compile
}

ansi_fg :: #force_inline proc (c: ANSIESC) -> string {
	// "\x1b[" + code + "m" (fits into 16 bytes for 0..97)
	code: u8 = u8(c)

	out: [16]u8
	out[0] = 0x1b // ESC
	out[1] = '['
	i := 2

	// handle 0..99 as decimal
	if code >= 10 {
		out[i] = (code / 10) + '0'
		i += 1
	}
	out[i] = (code % 10) + '0'
	i += 1

	out[i] = 'm'
	i += 1

	out[i] = 0
	return string(out[:])
}


validate_args :: proc() -> Commands {
	//args : []string = os.args
	program_name := os.base(os.args[0])
	
	
	if program_name != "coil.exe" {
		fmt.eprintln(
			ansi_fg(ANSIESC.red),
			"[ERROR] [ARGS]",
			" Invalid Program name",
			", please rename it to coil",
			ansi_fg(ANSIESC.reset)
			)
		os.exit(1)
	}

	if len(os.args) == 1 {
		fmt.eprintln(
			ansi_fg(ANSIESC.red),
			"[ERROR] [ARGS]",
			"Command not given.",
			ansi_fg(ANSIESC.reset)
			)
		print_help()
		os.exit(1)
	}
	
	command := os.base(os.args[1])

	if command == "help" {
		return .Help
	} else if command == "tokenize" {
		return .Tokenize
	} else if command == "parse" {
		return .Parse
	} else if command == "link" {
		return .Link
	} else if command == "optimize" {
		return .Optimize
	} else if command == "build" {
		return .Compile
	}

	fmt.eprintln(
		ansi_fg(ANSIESC.red),
		"[ERROR] [ARGS]",
		"Invalid Command.",
		"Try help.",
		ansi_fg(ANSIESC.reset)
		)
	os.exit(1)
}

print_help :: proc() {
	fmt.println(
		ansi_fg(ANSIESC.blue),
		"\t[help] | \n",
		"\t[tokenize file [> log] [>2 log] ] | \n",
		"\t[parse [< file] [> log] ] | \n",
		"\t[link [< file] [> log] ] | \n",
		"\t[optimize [< file] [> log] ] | \n",
		"\t[build [< file] [> log] ] | \n",
		ansi_fg(ANSIESC.reset)
		)
}

main :: proc() {
	cmd := validate_args()
	if cmd == .Help {
		print_help()
		os.exit(0)
	}

	fmt.eprintln("[END] Tokenization not yet implemented")

	if cmd == .Tokenize do os.exit(0)

	fmt.eprintln(
		ansi_fg(ANSIESC.red),
		"[ERROR] [ARGS]",
		"Unimplemented Command.",
		"Try help.",
		ansi_fg(ANSIESC.reset)
	)
	os.exit(1)
}

