defmodule ChatWeb.RoomLive do
  @moduledoc false

  use ChatWeb, :live_view

  require Logger

  alias Chat.Messages
  alias Chat.Rooms
  alias Chat.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div id="chat_container" class="mx-auto max-w-sm">
      <h1 class="text-center">Chatting in <strong><%= @room.name %></strong></h1>
      <div id="chat_messages" phx-update="append">
        <%= for message <- @messages do %>
          <p id={message.id}>
            <strong><%= Map.get(message.user, :username, "system") %>:</strong> <%= message.content %>
          </p>
        <% end %>
      </div>
      <.simple_form for={@form} id="chat_form" phx-submit="send_message" phx-change="form_update">
        <.input
          field={@form[:message]}
          value={@message}
          type="text"
          placeholder="Enter Message"
          autofocus="true"
          required
        />
        <:actions>
          <.button>Send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => room_id}, %{"user_token" => user_token}, socket) do
    topic = "room: #{room_id}"
    %{id: current_user_id, username: username} = Users.get_user_by_session_token(user_token)

    case {Rooms.fetch(room_id), ChatWeb.Presence.get_by_key(topic, username)} do
      {{:ok, room}, []} ->
        messages = Messages.all_by_room_id(room_id, :user)

        if connected?(socket) do
          ChatWeb.Endpoint.subscribe(topic)
          ChatWeb.Presence.track(self(), topic, username, %{})
        end

        {:ok,
         socket
         |> assign(room: room)
         |> assign(current_user_id: current_user_id)
         |> assign(username: username)
         |> assign(topic: topic)
         |> assign(message: "")
         |> assign(form: to_form(%{})), temporary_assigns: [form: nil, messages: messages]}

      {{:error, :not_found}, _} ->
        {:ok,
         socket
         |> put_flash(:error, "Room not found.")
         |> redirect(to: ~p"/")}

      {_, _} ->
        {:ok,
         socket
         |> put_flash(:error, "You are already in the room with another session.")
         |> redirect(to: ~p"/")}
    end
  end

  @impl true
  def handle_event("send_message", %{"message" => content}, socket) do
    %{assigns: %{topic: topic, current_user_id: current_user_id, room: %{id: room_id}}} = socket

    case Messages.create(content, current_user_id, room_id, :user) do
      {:ok, new_message} ->
        ChatWeb.Endpoint.broadcast(topic, "new_message", new_message)

        {:noreply, assign(socket, message: "")}

      _ ->
        Logger.error("Failed to save message!")
        {:noreply, socket}
    end

    {:noreply, assign(socket, message: "")}
  end

  def handle_event("form_update", %{"message" => message}, socket),
    do: {:noreply, assign(socket, message: message)}

  @impl true
  def handle_info(%{event: "new_message", payload: new_message}, socket),
    do: {:noreply, assign(socket, messages: [new_message])}

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    joins =
      Enum.map(joins, fn {username, _} ->
        %{id: Ecto.UUID.generate(), content: "#{username} joined the chat", user: %{}}
      end)

    leaves =
      Enum.map(leaves, fn {username, _} ->
        %{id: Ecto.UUID.generate(), content: "#{username} left the chat", user: %{}}
      end)

    {:noreply, assign(socket, messages: List.flatten([joins | leaves]))}
  end
end
