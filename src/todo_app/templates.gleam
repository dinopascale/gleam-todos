import gleam/string
import gleam/option.{type Option}

pub type Template {
  Template(title: Option(String), content: Option(String))
}

pub fn base() -> Template {
  Template(option.None, option.None)
}

pub fn set_title(base: Template, title: String) -> Template {
  Template(..base, title: option.Some(title))
}

pub fn set_main_content(base: Template, content: String) -> Template {
  Template(..base, content: option.Some(content))
}

pub fn render(t: Template) -> String {
  "
<!DOCTYPE html>
  <html>
    <head>
    </head>
    <body>
      <navbar>
        <a href=\"/\">Home</a>
        <a href=\"/todos\">Todo List</a>
      </navbar>
      <h1>#title</h1>
      <main>#main_content</main>
    </body>
  </html>
  "
  |> maybe_render_title(t.title)
  |> maybe_render_content(t.content)
}

fn maybe_render_title(partial: String, title: Option(String)) -> String {
  title
  |> option.map(fn(t) { string.replace(partial, each: "#title", with: t) })
  |> option.lazy_unwrap(fn() {
    string.replace(partial, each: "<h1>#title</h1>", with: "")
  })
}

fn maybe_render_content(partial: String, content: Option(String)) -> String {
  content
  |> option.map(fn(c) {
    string.replace(partial, each: "#main_content", with: c)
  })
  |> option.lazy_unwrap(fn() {
    string.replace(partial, each: "<main>#main_content</main>", with: "")
  })
}
