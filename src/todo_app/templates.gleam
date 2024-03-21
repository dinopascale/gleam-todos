import gleam/string

pub fn base() -> String {
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
}

pub fn set_title(base: String, title: String) -> String {
  string.replace(base, each: "#title", with: title)
}

pub fn set_main_content(base: String, content: String) -> String {
  string.replace(base, each: "#main_content", with: content)
}
