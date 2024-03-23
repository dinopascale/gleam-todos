import wisp.{type Request, type Response}
import gleam/http
import gleam/list
import gleam/result
import gleam/dynamic
import gleam/string
import gleam/string_builder
import todo_app/templates
import sqlight
import todo_app/context.{type Context}

pub fn handle(req: Request, ctx: Context) -> Response {
  case req.method {
    http.Get -> todos(ctx)
    http.Post -> create_todo(req, ctx)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn todos(ctx: Context) -> Response {
  let sql = "select * from todos;"
  let assert Ok(todos) =
    sqlight.query(
      sql,
      on: ctx.db,
      with: [],
      expecting: dynamic.element(1, dynamic.string),
    )

  let todos_list =
    list.map(todos, fn(t) { "<div>" <> t <> "</div>" })
    |> string.join("")

  let html =
    templates.base()
    |> templates.set_title("Todos")
    |> templates.set_main_content("
      <form method=\"post\">
        <input type=\"text\" name=\"name\">
        <button>Submit</button>
      </form>
    " <> todos_list)
    |> templates.render
    |> string_builder.from_string

  wisp.ok()
  |> wisp.html_body(html)
}

fn create_todo(req: Request, ctx: Context) -> Response {
  use formdata <- wisp.require_form(req)
  let validation_result = {
    use name <- result.try(list.key_find(formdata.values, "name"))

    let sql = "insert into todos (name) values (?);"

    let assert Ok(_) =
      sqlight.query(
        sql,
        on: ctx.db,
        with: [sqlight.text(name)],
        expecting: dynamic.element(0, dynamic.string),
      )

    Ok(name)
  }

  validation_result
  |> result.map(create_todo_success_response)
  |> result.lazy_unwrap(create_todo_error_response)
}

fn create_todo_success_response(_) -> Response {
  wisp.redirect(to: "/todos")
}

fn create_todo_error_response() -> Response {
  wisp.bad_request()
}
