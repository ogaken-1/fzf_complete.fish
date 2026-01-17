# Run all tests
test:
    fish -c 'fishtape tests/*.fish'

# Run specific test file
test-file file:
    fish -c 'fishtape {{file}}'
