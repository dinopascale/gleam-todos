import wisp.{type Request, type Response}
import gleam/http
import gleam/string_builder

pub fn handle(req: Request) -> Response {
  case req.method {
    http.Get -> todos()
    http.Post -> create_todo(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn todos() -> Response {
  let html = string_builder.from_string("Todos!")
  wisp.ok()
  |> wisp.html_body(html)
}

fn create_todo(_req: Request) -> Response {
  let html = string_builder.from_string("Created!")
  wisp.ok()
  |> wisp.html_body(html)
}
