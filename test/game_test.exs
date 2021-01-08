defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Player, Game}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Rafael"
        },
        status: :started,
        turn: :player
      }

      assert Game.info() == expected_response
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Rafael"
        },
        status: :started,
        turn: :player
      }

      assert Game.info() == expected_response

      new_state = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Rafael"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{
        new_state
        | turn: :computer,
          status: :continue
      }

      assert Game.info() == expected_response
    end
  end

  describe "player/0" do
    test "return the player state" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{
          move_avg: :soco,
          move_heal: :cura,
          move_rnd: :chute
        },
        name: "Rafael"
      }

      assert Game.player() == expected_response
    end
  end

  describe "turn/0" do
    test "return the game turn" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_response = :player

      assert Game.turn() == expected_response
    end
  end

  describe "fetch_player/1" do
    test "return the player state" do
      player = Player.build("Rafael", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{
          move_avg: :soco,
          move_heal: :cura,
          move_rnd: :chute
        },
        name: "Rafael"
      }

      assert Game.fetch_player(:player) == expected_response

      expected_response = %Player{
        life: 100,
        moves: %{
          move_avg: :soco,
          move_heal: :cura,
          move_rnd: :chute
        },
        name: "Robotinik"
      }

      assert Game.fetch_player(:computer) == expected_response
    end
  end
end
