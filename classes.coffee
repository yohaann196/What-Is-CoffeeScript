# classes.coffee
# CoffeeScript class syntax, inheritance, and a few useful patterns
# run with: coffee classes.coffee


# basic class
# @ in the constructor is shorthand for this.
# constructor: (@name, @year) is the same as writing:
#   constructor: (name, year) ->
#     this.name = name
#     this.year = year

class Language
  constructor: (@name, @year) ->

  describe: ->
    "#{@name} has been around since #{@year}."

  age: ->
    2025 - @year


python = new Language "Python", 1991
console.log python.describe()    # => Python has been around since 1991.
console.log python.age()         # => 34


# inheritance
# extends works the same as in JavaScript
# super() calls the same method on the parent class

class CompiledLanguage extends Language
  constructor: (name, year, @compilesTo) ->
    super name, year

  describe: ->
    base = super()
    "#{base} It compiles down to #{@compilesTo}."


coffee = new CompiledLanguage "CoffeeScript", 2009, "JavaScript"
console.log coffee.describe()
# => CoffeeScript has been around since 2009. It compiles down to JavaScript.
console.log coffee.age()    # => 16, inherited from Language, no override needed


# class-level (static) variables and methods
# @ on a property or method inside the class body means it belongs to the
# class itself, not to instances of it

class Registry
  @all = []

  @register: (lang) ->
    Registry.all.push lang

  @count: ->
    Registry.all.length


Registry.register "C"
Registry.register "Java"
Registry.register "Rust"

console.log Registry.count()    # => 3
console.log Registry.all        # => [ 'C', 'Java', 'Rust' ]


# mixins
# CoffeeScript doesn't have a built-in mixin keyword but you can
# copy methods onto a class prototype with a small helper

Serialisable =
  toJSON:  -> JSON.stringify { name: @name, year: @year }
  fromKey: -> "#{@name}-#{@year}"

applyMixin = (target, mixin) ->
  target::[key] = val for key, val of mixin

applyMixin Language, Serialisable

rust = new Language "Rust", 2015
console.log rust.toJSON()      # => {"name":"Rust","year":2015}
console.log rust.fromKey()     # => Rust-2015


# versioned language subclass

class VersionedLanguage extends Language
  constructor: (name, year, @version) ->
    super name, year

  fullName: ->
    "#{@name} v#{@version}"

  isModern: ->
    @year >= 2010


ts = new VersionedLanguage "TypeScript", 2012, "5.4"
console.log ts.fullName()     # => TypeScript v5.4
console.log ts.isModern()     # => true

c = new VersionedLanguage "C", 1972, "C23"
console.log c.fullName()      # => C vC23
console.log c.isModern()      # => false


# putting it all together

catalogue = [
  new Language "FORTRAN",      1957
  new Language "C",            1972
  new Language "C++",          1985
  new Language "Python",       1991
  new Language "Java",         1995
  new Language "JavaScript",   1995
  new Language "Ruby",         1995
  new Language "CoffeeScript", 2009
  new Language "Rust",         2015
]

console.log "\nbefore 1990:"
for lang in catalogue when lang.year < 1990
  console.log "  #{lang.name} (#{lang.year})"

console.log "\nafter 2000:"
for lang in catalogue when lang.year > 2000
  console.log "  #{lang.name} (#{lang.year})"

oldest = catalogue.reduce (a, b) -> if a.year < b.year then a else b
console.log "\noldest in the list: #{oldest.name} (#{oldest.year})"
