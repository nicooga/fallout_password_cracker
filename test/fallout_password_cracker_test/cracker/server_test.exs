defmodule FalloutPasswordCrackerTest.Cracker.ServerTest do
  use FalloutPasswordCracker.Test.Case
  doctest FalloutPasswordCracker.Cracker.Server
  alias FalloutPasswordCracker.Cracker.Server
  import GenServer, only: [call: 2]

  setup do: {:ok, server: setup_server(Server)}

  test "words are initialized as an empty set", context, do: assert call(context.server, :words) == MapSet.new

  test "setting all words at once", context do
    call(context.server, {:set_words, ~w[pepito popote]})
    assert call(context.server, :words) == MapSet.new(~w[pepito popote])
  end

  test "adding a single word", context do
    call(context.server, {:add_word, "pete"})
    assert call(context.server, :words) == MapSet.new(~w[pete])
  end

  describe "adding a clue" do
    test "when the clue is not part of the currect words", context do
      call(context.server, {:set_words, ~w[pepito petete popote]})
      assert call(context.server, {:add_clue, "putito", 6}) == {:error, :invalid_word}
    end

    test "when the clue is part of the current words should change the best guess", context do
      call(context.server, {:set_words, ~w[pepito petete popote]})
      assert call(context.server, :guess) == "pepito"
      call(context.server, {:add_clue, "popote", 6})
      assert call(context.server, :guess) == "popote"
    end
  end

  describe "requesting a guess" do
    test "when there are no clues", context do
      call(context.server, {:set_words, ~w[bababa babata batata bataba cccccc dddddd]})
      assert call(context.server, :guess) == "bababa"
    end

    test "when there are clues", context do
      call(context.server, {:set_words, ~w[popote patata botana paliza sabana vivote pipiti patito]})
      call(context.server, {:add_clue, "vivote", 3})
      call(context.server, {:add_clue, "pipiti", 3})
      call(context.server, {:add_clue, "patito", 2})
      assert call(context.server, :guess) == "popote"
    end
  end

  test "reseting", context do
    call(context.server, {:set_words, ~w[popote pepito]})
    assert call(context.server, :words) == MapSet.new(~w[popote pepito])
    call(context.server, :reset)
    assert call(context.server, :words) == MapSet.new
  end
end
