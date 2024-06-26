import gleeunit
import gleeunit/should
import wisp/testing
import todo_app/router
import todo_app/context.{type Context}
import sqlight

pub fn main() {
  gleeunit.main()
}

fn with_context(testcase: fn(Context) -> t) -> t {
  use conn <- sqlight.with_connection(":memory:")
  let sql =
    "create table if not exists todos (id INTEGER PRIMARY KEY AUTOINCREMENT, name text not null);"
  let assert Ok(Nil) = sqlight.exec(sql, conn)

  let context = context.Context(db: conn)

  testcase(context)
}

pub fn home_test() {
  use ctx <- with_context
  let request = testing.get("/", [])
  let response = router.route(request, ctx)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html")])
}

pub fn home_wrong_method_test() {
  use ctx <- with_context
  let request = testing.post("/", [], "something")
  let response = router.route(request, ctx)

  response.status
  |> should.equal(405)
}

pub fn get_todos_test() {
  use ctx <- with_context
  let request = testing.get("/todos", [])
  let response = router.route(request, ctx)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html")])
}

pub fn post_todos_happy_test() {
  use ctx <- with_context
  let request = testing.post_form("/todos", [], [#("name", "pippo")])
  let response = router.route(request, ctx)

  response.status
  |> should.equal(303)
}

pub fn post_todos_unhappy_test() {
  use ctx <- with_context
  let request = testing.post_form("/todos", [], [#("a_key", "a_value")])
  let response = router.route(request, ctx)

  response.status
  |> should.equal(400)
}

pub fn todos_wrong_method_test() {
  use ctx <- with_context
  let request = testing.delete("/todos", [], "something")
  let response = router.route(request, ctx)

  response.status
  |> should.equal(405)
}

pub fn not_found_test() {
  use ctx <- with_context
  let request = testing.get("/pippo", [])
  let response = router.route(request, ctx)

  response.status
  |> should.equal(404)
}
