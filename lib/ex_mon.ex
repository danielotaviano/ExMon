defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Status, Actions}

  @computer_name "Robotinik"
  @computer_moves [:move_avg, :move_rnd, :move_heal]
  @low_computer_moves [:move_avg, :move_rnd, :move_heal, :move_heal]

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player)

    Status.print_round_message(Game.info())

    handle_start_game(Game.info())
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)

    computer_move(Game.info())
  end

  defp handle_start_game(%{turn: :computer, status: :started}) do
    move = {:ok, Enum.random(@computer_moves)}
    do_move(move)
  end

  defp handle_start_game(_), do: :ok

  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> do_move()
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)

  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp computer_move(%{turn: :computer, status: :continue} = state) do
    state
    |> Map.get(:computer)
    |> handle_select_computer_move()
    |> do_move()
  end

  defp computer_move(_), do: :ok

  defp handle_select_computer_move(%{life: life}) when life < 40 do
    {:ok, Enum.random(@low_computer_moves)}
  end

  defp handle_select_computer_move(_) do
    {:ok, Enum.random(@computer_moves)}
  end
end
