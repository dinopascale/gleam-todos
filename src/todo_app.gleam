import wisp
import mist
import gleam/erlang/process
import todo_app/router
import todo_app/context
import sqlight

pub fn main() {
  let secret_key_base = wisp.random_string(64)

  use conn <- sqlight.with_connection(":memory")

  let sql =
    "
  create table if not exists todos (name text);

  insert into todos (name) values
  ('Test #1');
  "
  let assert Ok(Nil) = sqlight.exec(sql, conn)

  let context = context.Context(db: conn)

  let router_handler = router.route(_, context)

  let assert Ok(_) =
    router_handler
    |> wisp.mist_handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
