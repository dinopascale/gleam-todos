import wisp.{type Request, type Response}
import todos/home_page

pub fn route(request: Request) -> Response {
  case wisp.path_segments(request) {
    [] -> home_page.index(request)
    _ -> wisp.not_found()
  }
}
