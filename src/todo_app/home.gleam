import wisp.{type Request, type Response}
import gleam/http
import gleam/string_builder

pub fn index(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  let html = string_builder.from_string("Todos App!")
  wisp.ok()
  |> wisp.html_body(html)
}
