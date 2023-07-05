# Chat

Chat is a Web Application that allows the user, after register/login, to create chat rooms that allow every user to join.
After joining a chat room the user can see live all the messages that being sent in this room and to participate by
writing messages for all other users to see.

To set up the application locally:
  * Install asdf if you haven't already
  * Add erlang and elixir plugins `asdf plugin add erlang` and `asdf plugin add elixir`
  * Run `KERL_BUILD_DOCS=yes asdf install erlang 25.2` to install erlang 
  * Run `asdf install elixir 1.14.2-otp-25` to install elixir
  * Use the above versions globally with `asdf global erlang 25.2` and `asdf global elixir 1.14.2-opt-25`
  * Mix local hex `mix local.hex`
  * Install phoenix cli `mix archive.install hex phx_new 1.7.6`
  * Start a PostgreSQL DB (quick setup recommendation `docker run --name chat_dev -e POSTGRES_PASSWORD=${YOUR_PASSWORD} -e POSTGRES_USER=${YOUR_USER} -p 5432:5432 -d postgres:alpine`) note that if you have to change the user and password in the according env config file.

To start your Phoenix server:
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To test the application:
  * Run `mix test` in order to perform the unit tests
  * Run `iex -S mix phx.server` and follow up by running `ChatWeb.LoadTest.Interface.update_number_of_users(number_of_users, room_id)`
  to perform a manually scalable load test (where number_of_users::integer and room_id::UUID) 
  