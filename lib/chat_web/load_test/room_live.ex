defmodule ChatWeb.LoadTest.RoomLive do
  @moduledoc false
  use GenServer

  require Logger

  def start_link(room_id) do
    GenServer.start_link(__MODULE__, room_id)
  end

  @impl true
  def init(room_id) do
    user = add_test_user()
    room = Chat.Rooms.get(room_id)
    topic = "room: #{room_id}"
    {:ok, timer_ref} = :timer.send_interval(1000, :tick)

    {:ok, %{topic: topic, user: user, room: room, timer_ref: timer_ref}}
  end

  @impl true
  def handle_info(:tick, state) do
    %{user: %{id: current_user_id}, room: %{id: room_id}, topic: topic} = state

    case Chat.Messages.create("another test", current_user_id, room_id, :user) do
      {:ok, new_message} -> ChatWeb.Endpoint.broadcast(topic, "new_message", new_message)
      _ -> Logger.error("Failed to save message!")
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:update_frequency, frequency_in_ms}, %{timer_ref: timer_ref} = state) do
    :timer.cancel(timer_ref)
    {:ok, new_timer_ref} = :timer.send_interval(frequency_in_ms, :tick)

    {:noreply, %{state | timer_ref: new_timer_ref}}
  end

  defp add_test_user do
    {:ok, user} =
      Chat.Users.register_user(%{
        username: "test-user",
        email: "user#{System.unique_integer()}@example.com",
        password: "hello world!"
      })

    user
  end
end
