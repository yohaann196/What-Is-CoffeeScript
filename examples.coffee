# examples.coffee
# core CoffeeScript features with notes on each one
# run with: coffee examples.coffee

# 1. variables
# no var, let, or const needed. CoffeeScript figures out scope on its own.

language = "CoffeeScript"
year     = 2009
active   = true

console.log "#{language} was created in #{year}."
# => CoffeeScript was created in 2009.


# 2. functions
# use -> to define a function. the last expression gets returned automatically,
# so you don't need a return statement most of the time.

square = (x) -> x * x

add = (a, b) ->
  result = a + b
  result   # this line gets returned

console.log square 5     # => 25
console.log add 3, 4     # => 7


# 3. default arguments
# just set a default right in the function signature

greet = (name = "World") ->
  "Hello, #{name}!"

console.log greet()          # => Hello, World!
console.log greet "Alice"    # => Hello, Alice!


# 4. string interpolation
# double-quoted strings support #{} interpolation
# single-quoted strings are always treated as literals

name  = "CoffeeScript"
major = 2

console.log "Version: #{major}"     # => Version: 2
console.log 'Version: #{major}'     # => Version: #{major}


# 5. conditionals
# no parentheses around the condition, no curly braces
# indentation does the work, same as Python

score = 85

if score >= 90
  console.log "Grade: A"
else if score >= 80
  console.log "Grade: B"
else
  console.log "Grade: C"
# => Grade: B

# you can also put the condition at the end of the line
console.log "Passing" if score >= 60


# 6. unless
# unless is just "if not". it reads more naturally in a lot of situations.

loggedIn = false
console.log "Please log in." unless loggedIn
# => Please log in.


# 7. loops
# for...in goes over arrays

languages = ["C", "Python", "JavaScript", "Rust"]

for lang in languages
  console.log lang

# or put the loop at the end of the line if it fits
console.log lang for lang in languages


# 8. list comprehensions
# this is one of my favourite CoffeeScript features.
# build a new array by describing what you want, not how to build it.

numbers = [1, 2, 3, 4, 5]
squares = (n * n for n in numbers)
console.log squares
# => [ 1, 4, 9, 16, 25 ]

# add a when clause to filter
evens = (n for n in numbers when n % 2 is 0)
console.log evens
# => [ 2, 4 ]


# 9. ranges
# two dots is inclusive, three dots leaves off the last value

inclusive = [1..5]    # [1, 2, 3, 4, 5]
exclusive = [1...5]   # [1, 2, 3, 4]

console.log inclusive
console.log exclusive

# ranges work for slicing arrays too
letters = ["a", "b", "c", "d", "e"]
console.log letters[1..3]    # => [ 'b', 'c', 'd' ]


# 10. existence operator
# the ? operator checks that something is not null and not undefined.
# saves you from writing that long condition every single time.

maybeValue = null

if maybeValue?
  console.log "Got: #{maybeValue}"
else
  console.log "Nothing there."
# => Nothing there.

# ?= only assigns if the variable is currently null or undefined
config = null
config ?= "default"
console.log config    # => default


# 11. destructuring
# unpack arrays and objects into named variables in one line

[first, second, rest...] = [10, 20, 30, 40, 50]
console.log first    # => 10
console.log second   # => 20
console.log rest     # => [ 30, 40, 50 ]

{ name: authorName, year: publishYear } = { name: "Ashkenas", year: 2009 }
console.log authorName    # => Ashkenas
console.log publishYear   # => 2009


# 12. splats
# use ... to collect any number of arguments into an array
# same idea as JavaScript's rest parameters

sum = (numbers...) ->
  total = 0
  total += n for n in numbers
  total

console.log sum 1, 2, 3, 4, 5    # => 15


# 13. object literals
# you can write objects without braces when they're indented.
# commas between properties are optional too.

person =
  name: "Ada Lovelace"
  born: 1815
  field: "Mathematics"

console.log person.name    # => Ada Lovelace
console.log person.born    # => 1815


# 14. chained comparisons
# works the same way as Python

x = 5
console.log 1 < x < 10    # => true
console.log 0 < x < 4     # => false


# 15. fat arrow
# => binds this to whatever this is in the outer context.
# use -> for normal functions, => when you need to keep this working.

counter =
  count: 0
  increment: ->
    addOne = => @count += 1
    addOne()

counter.increment()
console.log counter.count    # => 1
