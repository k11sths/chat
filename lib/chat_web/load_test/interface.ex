defmodule ChatWeb.LoadTest.Interface do
  @moduledoc false

  require Logger

  alias ChatWeb.LoadTestSupervisor

  def update_number_of_users(number_of_users, room_id) do
    current_number_of_users =
      LoadTestSupervisor
      |> DynamicSupervisor.which_children()
      |> Enum.count()

    apply_changes(number_of_users - current_number_of_users, room_id)
  end

  def message_frequency(frequency_in_ms) do
    LoadTestSupervisor
    |> DynamicSupervisor.which_children()
    |> Enum.each(fn {_, pid, _, _} -> send(pid, {:update_frequency, frequency_in_ms}) end)
  end

  defp apply_changes(0, _), do: :ok

  defp apply_changes(users_diff, room_id) when users_diff > 0 do
    Logger.info("Load Test: Starting #{users_diff} new users")

    Enum.each(1..users_diff, fn _ ->
      DynamicSupervisor.start_child(LoadTestSupervisor, {ChatWeb.LoadTest.RoomLive, room_id})
    end)
  end

  defp apply_changes(users_diff, _) do
    Logger.info("Load Test: Killing #{users_diff * -1} users")

    Enum.each(-1..users_diff, fn _ ->
      [{_, pid, _, _} | _] = DynamicSupervisor.which_children(LoadTestSupervisor)
      DynamicSupervisor.terminate_child(LoadTestSupervisor, pid)
    end)
  end
end
