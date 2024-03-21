import wisp.{type Request, type Response}
import todo_app/home
import todo_app/todos

pub fn route(request: Request) -> Response {
  case wisp.path_segments(request) {
    [] -> home.index(request)
    ["todos"] -> todos.handle(request)
    _ -> wisp.not_found()
  }
}
