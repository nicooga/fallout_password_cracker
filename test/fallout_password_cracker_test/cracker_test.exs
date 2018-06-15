defmodule FalloutPasswordCrackerTest.CrackerTest do
  use FalloutPasswordCracker.Test.Case
  doctest FalloutPasswordCracker.Cracker
  alias FalloutPasswordCracker.Cracker

  @moduletag timeout: 1923123123

  setup do
    setup_server(Cracker.Server)
    :ok
  end

  describe "words" do
    test "when just initialized should be an empty map", do: assert Cracker.words == MapSet.new
    test "should return the current words" do
      Cracker.add_word "pete"
      assert Cracker.words == MapSet.new(~w[pete])
    end
  end

  describe "adding a word" do
    test "should not allow duplicates" do
      Cracker.add_word "pete"
      Cracker.add_word "pete"
      assert Cracker.words == MapSet.new(~w[pete])
    end

    test "when the word is the same length as the current ones" do
      Cracker.add_word "pete"
      Cracker.add_word "poto"
      assert Cracker.words == MapSet.new(~w[pete poto])
    end

    test "when the word is not the same length as the current ones" do
      Cracker.add_word "poto"
      Cracker.add_word "potos"
      Cracker.add_word "potosi"
      assert Cracker.words == MapSet.new(~w[poto])
    end
  end

  test "setting all the words at once" do 
    Cracker.set_words ~w[pete poto]
    assert Cracker.words == MapSet.new(~w[pete poto])
  end

  describe "adding a clue" do
    setup do: Cracker.set_words ~w[pete poto asdf qwer uiop]

    test "when the clue is valid" do
      Cracker.add_clue "pete", 2
      assert Cracker.guess == "poto"
    end

    test "when the clue is not valid" do
      Cracker.add_clue "pepe", 3
      assert Cracker.guess == "pete"
    end
  end

  describe "guessing" do 
    setup do: Cracker.set_words ~w[asdfq qwerq uiopa petua petea balua]

    test "with no clues", do: assert Cracker.guess == "petua"

    test "with clues" do
      Cracker.add_clue "asdfq", 1
      assert Cracker.guess == "qwerq"
    end
  end
end
