# Chat

Chat is a Web Application that takes converts the user's enters time to in each
of the saved cities timezone.

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

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.