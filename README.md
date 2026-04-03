# What is CoffeeScript?

CoffeeScript is a small language that compiles to JavaScript. You write `.coffee` files, run the compiler, and get plain `.js` files back.

Jeremy Ashkenas built it in 2009 because JavaScript at the time was pretty painful to write. No arrow functions, no template strings, no destructuring. CoffeeScript gave you all of that years before ES6 existed.

> This repo is written in CoffeeScript, about CoffeeScript.

---

## Why it exists

In 2009, writing clean JavaScript meant a lot of boilerplate. `function` keyword everywhere, no string interpolation, clunky loops. CoffeeScript cleaned all that up by compiling nicer syntax down to whatever JavaScript the browsers could actually run.

ES6 landed in 2015 and solved most of the same problems natively. By then CoffeeScript had done its job. A lot of what you write in modern JavaScript today traces directly back to ideas CoffeeScript popularised first.

---

## What it looks like

CoffeeScript:
```coffeescript
greet = (name) -> "Hello, #{name}!"

languages = ["C", "Python", "JavaScript"]
console.log greet lang for lang in languages
```

The JavaScript it compiles to:
```javascript
var greet, languages;

greet = function(name) {
  return `Hello, ${name}!`;
};

languages = ["C", "Python", "JavaScript"];
for (let lang of languages) {
  console.log(greet(lang));
}
```

---

## Quick syntax reference

| What you want | JavaScript | CoffeeScript |
|---|---|---|
| Function | `const f = (x) => x * 2` | `f = (x) -> x * 2` |
| Bound function | `const f = () => this.val` | `f = => @val` |
| String interpolation | `` `Hello ${name}` `` | `"Hello #{name}"` |
| List comprehension | `arr.map(x => x * 2)` | `(x * 2 for x in arr)` |
| Null/undefined check | `x !== null && x !== undefined` | `x?` |
| Array slice | `arr.slice(1, 4)` | `arr[1..3]` |
| Unless | `if (!condition)` | `unless condition` |
| this.prop | `this.name` | `@name` |

---

## Files

| File | What it covers |
|---|---|
| `examples.coffee` | 15 annotated examples of core features |
| `compare.coffee` | CoffeeScript source next to the compiled JS output |
| `classes.coffee` | Classes, inheritance, static methods, mixins |
| `examples.js` | Compiled output of examples.coffee |
| `compare.js` | Compiled output of compare.coffee |
| `classes.js` | Compiled output of classes.coffee |
| `index.html` | GitHub Pages explainer |

---

## Running it

You need Node.js. Then:

```bash
npm install -g coffeescript
```

Run a file:
```bash
coffee examples.coffee
```

Compile to JavaScript:
```bash
coffee --compile examples.coffee
```

Watch and recompile on save:
```bash
coffee --compile --watch examples.coffee
```

---

## Should you use it for a new project?

Probably not. ES6+ covers most of what CoffeeScript offered, and TypeScript is the better choice if you want a compile-to-JS language with real tooling behind it.

That said, it is worth knowing:

- A lot of older codebases still use it, especially Rails apps
- ES6 syntax owes a lot to CoffeeScript
- It compiles to readable JavaScript, so picking it up is low risk
- The source for this repo is CoffeeScript, so you can see exactly how it works
