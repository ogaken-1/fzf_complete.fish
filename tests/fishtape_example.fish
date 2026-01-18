@test "math works" (math 1 + 1) -eq 2
@test "string comparison" "hello" = "hello"
@test "echo output" (echo foo) = "foo"
