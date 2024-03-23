import wisp.{type Request, type Response}
import gleam/http
import gleam/list
import gleam/result
import gleam/string_builder
import todo_app/templates
import todo_app/context.{type Context}

pub fn handle(req: Request, _: Context) -> Response {
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

fn create_todo(req: Request) -> Response {
  use formdata <- wisp.require_form(req)
  let validation_result = {
    use name <- result.try(list.key_find(formdata.values, "name"))
    Ok(name)
  }

  validation_result
  |> result.map(create_todo_success_response)
  |> result.lazy_unwrap(create_todo_error_response)
}

fn create_todo_success_response(name: String) -> Response {
  let html =
    templates.base()
    |> templates.set_title("Created successfully with name: " <> name)
    |> templates.render
    |> string_builder.from_string
  wisp.ok()
  |> wisp.html_body(html)
}

fn create_todo_error_response() -> Response {
  wisp.bad_request()
}
