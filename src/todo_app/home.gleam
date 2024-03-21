import wisp.{type Request, type Response}
import gleam/http
import gleam/string_builder
import todo_app/templates

pub fn index(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  let html =
    templates.base()
    |> templates.set_title("Todos App!")
    |> string_builder.from_string()

  wisp.ok()
  |> wisp.html_body(html)
}
