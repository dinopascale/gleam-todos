import gleam/string
import gleeunit
import gleeunit/should
import wisp/testing
import todo_app/router

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn home_test() {
  let request = testing.get("/", [])
  let response = router.route(request)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html")])
}

pub fn home_wrong_method_test() {
  let request = testing.post("/", [], "something")
  let response = router.route(request)

  response.status
  |> should.equal(405)
}

pub fn get_todos_test() {
  let request = testing.get("/todos", [])
  let response = router.route(request)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html")])
}

pub fn post_todos_happy_test() {
  let request = testing.post_form("/todos", [], [#("name", "pippo")])
  let response = router.route(request)

  response.status
  |> should.equal(200)

  response.headers
  |> should.equal([#("content-type", "text/html")])

  response
  |> testing.string_body
  |> string.contains("pippo")
  |> should.be_true()
}

pub fn post_todos_unhappy_test() {
  let request = testing.post_form("/todos", [], [#("a_key", "a_value")])
  let response = router.route(request)

  response.status
  |> should.equal(400)
}

pub fn todos_wrong_method_test() {
  let request = testing.delete("/todos", [], "something")
  let response = router.route(request)

  response.status
  |> should.equal(405)
}

pub fn not_found_test() {
  let request = testing.get("/pippo", [])
  let response = router.route(request)

  response.status
  |> should.equal(404)
}
