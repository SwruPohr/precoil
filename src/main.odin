package lang

import "core:fmt"
import "core:os"

main :: proc() {
	handle := "../in/stage.coil"
	fondle := "../out/output.txt"

	data, derr := os.read_entire_file(handle, context.allocator)
	if derr != nil {
		fmt.eprintfln("ERROR: could not open asset: %s", handle)
		return
	}

	tokens, tok := tokenize(data)
	if !tok {
		fmt.eprintfln("ERROR: could not tokenize data")
		return
	}
	defer delete(tokens)

	f, ferr := os.open(fondle, os.O_CREATE | os.O_WRONLY | os.O_TRUNC)
	if ferr != nil {
		fmt.eprintfln("ERROR: could not open output: %s", fondle)
		return
	}
	for token in tokens {
		fmt.fprintfln(f, "%v", token)
	}

}
