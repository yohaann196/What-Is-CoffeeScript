# compare.coffee
# each block shows the CoffeeScript version and then the JavaScript it compiles to
# run with: coffee compare.coffee


# function definition

# coffeescript
double = (x) -> x * 2

# compiled js:
# var double;
# double = function(x) {
#   return x * 2;
# };

console.log double 7    # => 14


# multiline function

# coffeescript
describe = (lang, year) ->
  "#{lang} first showed up in #{year}."

# compiled js:
# var describe;
# describe = function(lang, year) {
#   return `${lang} first showed up in ${year}.`;
# };

console.log describe "Python", 1991    # => Python first showed up in 1991.


# conditional

# coffeescript
classify = (n) ->
  if n > 0
    "positive"
  else if n < 0
    "negative"
  else
    "zero"

# compiled js:
# var classify;
# classify = function(n) {
#   if (n > 0) {
#     return "positive";
#   } else if (n < 0) {
#     return "negative";
#   } else {
#     return "zero";
#   }
# };

console.log classify -3    # => negative
console.log classify 0     # => zero


# for loop

# coffeescript
langs = ["C", "Java", "Python"]
for lang in langs
  console.log lang

# compiled js:
# var i, lang, langs, len;
# langs = ["C", "Java", "Python"];
# for (i = 0, len = langs.length; i < len; i++) {
#   lang = langs[i];
#   console.log(lang);
# }


# list comprehension
# notice the compiled version wraps everything in an IIFE
# CoffeeScript needs to do this to collect results into an array

# coffeescript
nums    = [1, 2, 3, 4, 5]
doubled = (n * 2 for n in nums)

# compiled js:
# var doubled, i, len, n, nums;
# nums = [1, 2, 3, 4, 5];
# doubled = (function() {
#   var i, len, results;
#   results = [];
#   for (i = 0, len = nums.length; i < len; i++) {
#     n = nums[i];
#     results.push(n * 2);
#   }
#   return results;
# })();

console.log doubled    # => [ 2, 4, 6, 8, 10 ]


# existence check
# val? compiles to val != null, which catches both null and undefined

# coffeescript
checkValue = (val) ->
  if val?
    "Got: #{val}"
  else
    "Nothing"

# compiled js:
# var checkValue;
# checkValue = function(val) {
#   if (val != null) {
#     return `Got: ${val}`;
#   } else {
#     return "Nothing";
#   }
# };

console.log checkValue null       # => Nothing
console.log checkValue "hello"    # => Got: hello


# destructuring

# coffeescript
[a, b, c] = [10, 20, 30]

# compiled js:
# var a, b, c;
# [a, b, c] = [10, 20, 30];

console.log a, b, c    # => 10 20 30


# default parameters

# coffeescript
welcome = (name = "stranger") ->
  "Welcome, #{name}."

# compiled js:
# var welcome;
# welcome = function(name = "stranger") {
#   return `Welcome, ${name}.`;
# };

console.log welcome()          # => Welcome, stranger.
console.log welcome "Alice"    # => Welcome, Alice.


# object without braces

# coffeescript
config =
  host: "localhost"
  port: 8080
  debug: true

# compiled js:
# var config;
# config = {
#   host: "localhost",
#   port: 8080,
#   debug: true
# };

console.log config.port    # => 8080


# fat arrow
# => compiles to an ES6 arrow function, so this is always the outer this

# coffeescript
timer =
  seconds: 0
  start: ->
    tick = => @seconds += 1
    tick()
    tick()

# compiled js:
# var timer;
# timer = {
#   seconds: 0,
#   start: function() {
#     var tick;
#     tick = () => {
#       return this.seconds += 1;
#     };
#     tick();
#     tick();
#   }
# };

timer.start()
console.log timer.seconds    # => 2
