defmodule ChatWeb.Utils do
  @moduledoc false

  def current_user_id(conn, opts \\ [])
  def current_user_id(%Plug.Conn{assigns: %{current_user_id: id}}, _opts), do: id
  def current_user_id(%Plug.Conn{assigns: %{current_user: %{id: id}}}, _opts), do: id
end
