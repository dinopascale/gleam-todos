import wisp.{type Request, type Response}
import todo_app/home
import todo_app/todos
import todo_app/context.{type Context}

pub fn route(request: Request, ctx: Context) -> Response {
  case wisp.path_segments(request) {
    [] -> home.index(request)
    ["todos"] -> todos.handle(request, ctx)
    _ -> wisp.not_found()
  }
}
