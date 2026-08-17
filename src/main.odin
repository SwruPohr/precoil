package lang

import "core:fmt"
import "core:os"

main :: proc() {
	data, err := os.read_entire_file("../assets/main.coil", context.allocator)

	tokens := tokenize(string(data))

	fmt.println(tokens)
}
