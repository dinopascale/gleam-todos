import wisp.{type Request, type Response}
import gleam/http
import gleam/string_builder
import todo_app/templates

pub fn handle(req: Request) -> Response {
  case req.method {
    http.Get -> todos()
    http.Post -> create_todo(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn todos() -> Response {
  let html =
    templates.base()
    |> templates.set_title("Todos")
    |> templates.set_main_content(
      "
      <form method=\"post\">
        <input type=\"text\" name=\"name\">
        <button>Submit</button>
      </form>
    ",
    )
    |> templates.render
    |> string_builder.from_string

  wisp.ok()
  |> wisp.html_body(html)
}

fn create_todo(_req: Request) -> Response {
  let html =
    templates.base()
    |> templates.set_title("Created successfully")
    |> templates.render
    |> string_builder.from_string
  wisp.ok()
  |> wisp.html_body(html)
}
