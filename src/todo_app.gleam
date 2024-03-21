import wisp
import mist
import gleam/erlang/process
import todo_app/router

pub fn main() {
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    router.route
    |> wisp.mist_handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
