package lang

import "core:fmt"
import "core:os"

main :: proc() {
	handle := "../assets/main.coil"
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

	f, ferr := os.open(fondle, os.O_WRONLY)
	if ferr != nil {
		fmt.eprintfln("ERROR: could not open output: %s", fondle)
		return
	}
	fmt.fprintfln(f, "%#v", tokens)

}
