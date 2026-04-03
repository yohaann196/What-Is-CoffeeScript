# main.coffee
# drives the whole page: tab switching, source loading, and dynamic content
# compile with: coffee --compile main.coffee

# ── data ──────────────────────────────────────────────────────

# all the syntax comparison rows, kept here instead of hardcoded in HTML
syntaxRows = [
  ["Function",           "const f = (x) => x * 2",                "f = (x) -> x * 2"]
  ["Bound function",     "const f = () => this.val",               "f = => @val"]
  ["String interpolation", "`Hello ${name}`",                      '"Hello #{name}"']
  ["List comprehension", "arr.map(x => x * 2)",                    "(x * 2 for x in arr)"]
  ["Existence check",    "x !== null && x !== undefined",          "x?"]
  ["Array slice",        "arr.slice(1, 4)",                        "arr[1..3]"]
  ["Conditional",        "if (x > 0) { ... }",                     "if x > 0  # no braces"]
  ["Unless",             "if (!condition) { ... }",                "unless condition"]
  ["Default param",      "function f(x = 0) {}",                  "f = (x = 0) ->"]
  ["this.prop",          "this.name",                              "@name"]
  ["Class property",     "this.count = 0",                        "@count = 0"]
  ["Existential assign", "x = x !== null ? x : 'default'",        "x ?= 'default'"]
]

# files shown in the file list widget
repoFiles = [
  { icon: "☕", name: "main.coffee",     desc: "tab switching, dynamic content, source loading" }
  { icon: "☕", name: "examples.coffee", desc: "15 annotated examples of core features" }
  { icon: "☕", name: "compare.coffee",  desc: "CoffeeScript source next to the compiled JS" }
  { icon: "☕", name: "classes.coffee",  desc: "classes, inheritance, static methods, mixins" }
  { icon: "📄", name: "main.js",         desc: "compiled from main.coffee" }
  { icon: "📄", name: "examples.js",     desc: "compiled from examples.coffee" }
  { icon: "📄", name: "compare.js",      desc: "compiled from compare.coffee" }
  { icon: "📄", name: "classes.js",      desc: "compiled from classes.coffee" }
  { icon: "🎨", name: "style.css",       desc: "all styles" }
  { icon: "📖", name: "README.md",       desc: "readme and docs" }
]

# shell commands shown in the install box
installSteps = [
  { comment: "# install CoffeeScript (requires Node.js)", cmd: "npm install -g coffeescript" }
  { comment: "# run a file directly",                     cmd: "coffee examples.coffee" }
  { comment: "# compile to JavaScript",                   cmd: "coffee --compile examples.coffee" }
  { comment: "# watch and recompile on save",             cmd: "coffee --compile --watch examples.coffee" }
]

# ── helpers ───────────────────────────────────────────────────

# create an element with optional className and innerHTML
el = (tag, cls, html) ->
  node = document.createElement tag
  node.className = cls if cls
  node.innerHTML = html if html
  node

esc = (str) ->
  str
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'

# ── build syntax table ─────────────────────────────────────────

buildSyntaxTable = ->
  tbody = document.querySelector '.compare-table tbody'
  return unless tbody?
  tbody.innerHTML = ''
  for [feature, js, cs] in syntaxRows
    tr = document.createElement 'tr'
    tr.innerHTML = """
      <td>#{esc feature}</td>
      <td><code>#{esc js}</code></td>
      <td><code>#{esc cs}</code></td>
    """
    tbody.appendChild tr

# ── build file list ────────────────────────────────────────────

buildFileList = ->
  container = document.querySelector '.file-list'
  return unless container?
  # keep the header, rebuild the items
  header = container.querySelector '.file-list-header'
  container.innerHTML = ''
  container.appendChild header if header

  for file in repoFiles
    item = el 'div', 'file-list-item'
    item.innerHTML = """
      <span class="icon">#{file.icon}</span>
      <span class="filename">#{esc file.name}</span>
      <span class="desc">#{esc file.desc}</span>
    """
    container.appendChild item

# ── build install box ──────────────────────────────────────────

buildInstallBox = ->
  box = document.querySelector '.install-box'
  return unless box?
  box.innerHTML = ''
  for step, i in installSteps
    comment = el 'span', 'comment', esc step.comment
    box.appendChild comment
    box.appendChild document.createElement 'br'
    box.appendChild document.createTextNode step.cmd
    unless i is installSteps.length - 1
      box.appendChild document.createElement 'br'
      box.appendChild document.createElement 'br'

# ── tab switching ──────────────────────────────────────────────

buttons = document.querySelectorAll 'nav button'
panels  = document.querySelectorAll '.tab-panel'

showTab = (name) ->
  panel.classList.remove 'active' for panel in panels
  btn.classList.remove 'active'   for btn in buttons
  document.getElementById("tab-#{name}")?.classList.add 'active'
  document.querySelector("nav button[data-tab='#{name}']")?.classList.add 'active'

for btn in buttons
  do (btn) ->
    btn.addEventListener 'click', ->
      tab = btn.getAttribute 'data-tab'
      if tab?
        showTab tab
        loadSource tab if tab in ['examples', 'compare', 'classes']

# keyboard: left/right arrows move between tabs
tabOrder = ['overview', 'examples', 'compare', 'classes', 'readme']

currentTab = ->
  active = document.querySelector 'nav button.active'
  active?.getAttribute 'data-tab'

document.addEventListener 'keydown', (e) ->
  return if e.target.tagName in ['INPUT', 'TEXTAREA']
  idx = tabOrder.indexOf currentTab()
  if e.key is 'ArrowRight' and idx < tabOrder.length - 1
    next = tabOrder[idx + 1]
    showTab next
    loadSource next if next in ['examples', 'compare', 'classes']
  if e.key is 'ArrowLeft' and idx > 0
    prev = tabOrder[idx - 1]
    showTab prev
    loadSource prev if prev in ['examples', 'compare', 'classes']

# ── source file loading ────────────────────────────────────────
# fetches the raw .coffee file and drops it into the code block
# highlight.js re-runs on the element after content is set

loadSource = (name) ->
  el = document.getElementById "code-#{name}"
  return unless el?
  return if el.dataset.loaded is 'true'

  fetch "#{name}.coffee"
    .then (res) ->
      throw new Error "#{res.status}" unless res.ok
      res.text()
    .then (src) ->
      el.textContent = src
      el.dataset.loaded = 'true'
      hljs.highlightElement el
    .catch (err) ->
      el.textContent = "could not load #{name}.coffee (#{err.message})"

# ── readme tab: render a mini version inline ───────────────────

buildReadme = ->
  container = document.getElementById 'readme-body'
  return unless container?

  sections = [
    {
      heading: "What is CoffeeScript?"
      level: 2
      body: """
        CoffeeScript is a small language that compiles to JavaScript.
        You write <code>.coffee</code> files, run the compiler, and get
        plain <code>.js</code> files back.
      """
    }
    {
      heading: null
      body: """
        Jeremy Ashkenas built it in 2009. It was widely used from about
        2012 to 2016, before ES6 brought most of its ideas into JavaScript itself.
      """
    }
    {
      heading: "Files"
      level: 3
      list: ["main.coffee: tab switching and dynamic content",
             "examples.coffee: annotated examples of core features",
             "compare.coffee: CoffeeScript source next to the compiled JS",
             "classes.coffee: classes, inheritance, static methods, mixins"]
    }
    {
      heading: "Running the code"
      level: 3
      pre: "npm install -g coffeescript\ncoffee examples.coffee\ncoffee --compile examples.coffee"
    }
    {
      heading: "References"
      level: 3
      body: 'Ashkenas, J. <em>CoffeeScript: Accelerated JavaScript Development.</em> Pragmatic Bookshelf, 2011.'
    }
    {
      heading: null
      body: '<a href="https://coffeescript.org" style="color:#0969da;">coffeescript.org</a>'
    }
  ]

  for section in sections
    if section.heading
      tag = if section.level is 2 then 'h2' else 'h3'
      h = document.createElement tag
      h.style.cssText = if section.level is 2
        'font-size:1.4rem; margin-bottom:0.75rem; margin-top:1.5rem;'
      else
        'font-size:1.05rem; font-weight:600; margin:1.25rem 0 0.4rem;'
      h.textContent = section.heading
      container.appendChild h

    if section.body
      p = el 'p', null, section.body
      p.style.margin = '0.5rem 0'
      container.appendChild p

    if section.list
      ul = document.createElement 'ul'
      ul.style.cssText = 'padding-left:1.5rem; margin:0.5rem 0;'
      for item in section.list
        li = document.createElement 'li'
        li.style.margin = '0.25rem 0'
        [label, desc] = item.split ': '
        li.innerHTML = "<code style=\"background:#f6f8fa;border:1px solid #d0d7de;border-radius:3px;padding:0.1em 0.35em;font-size:0.85em;\">#{esc label}</code>: #{esc desc}"
        ul.appendChild li
      container.appendChild ul

    if section.pre
      pre = document.createElement 'pre'
      pre.style.cssText = 'background:#f6f8fa;border:1px solid #d0d7de;border-radius:6px;padding:0.75rem 1rem;font-size:0.85rem;overflow-x:auto;margin:0.75rem 0;'
      code = document.createElement 'code'
      code.textContent = section.pre
      pre.appendChild code
      container.appendChild pre

# ── init ──────────────────────────────────────────────────────

buildSyntaxTable()
buildFileList()
buildInstallBox()
buildReadme()
showTab 'overview'
loadSource 'examples'   # pre-load so it's ready when user clicks the tab
