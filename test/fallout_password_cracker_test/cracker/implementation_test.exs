defmodule FalloutPasswordCracker.Cracker.ImplementationTest do
  use FalloutPasswordCracker.Test.Case
  doctest FalloutPasswordCracker.Cracker
  import FalloutPasswordCracker.Cracker.Implementation

  describe "#matching_char_count/2" do
    test "when both arguments are words" do
      assert matching_char_count("asdf", "asdf") == 4
      assert matching_char_count("asdq", "asdf") == 3
      assert matching_char_count("aseq", "asdf") == 2
    end

    test "when second argument is a word list" do
      assert matching_char_count("asdf", ~w[asdf asdf asdf]) == 12
      assert matching_char_count("asdf", ~w[asdf aswf asdf]) == 11
      assert matching_char_count("asdf", ~w[asdf aswf vsdf]) == 10
    end
  end

  describe "#guess/1" do
    test "returns the word with the higher change to be the answer" do
      assert guess(~w[bababa babata batata bataba cccccc dddddd]) == "bababa"
    end
  end

  describe "#guess/2" do
    test "returns the word with the higher change to be the answer" do
      actual =
        guess(
          ~w[popote patata botana paliza sabana vivote pipiti patito],
          %{"vivote" => 3, "pipiti" => 3, "patito" => 2}
        )

      assert actual == "popote"
    end
  end

  describe "#possible_match?/2" do
    test "when given a single clue" do
      assert possible_match?("popote", {"vivote", 3}) == true
      assert possible_match?("popite", {"vivote", 3}) == false
      assert possible_match?("popote", {"sabana", 0}) == true
      assert possible_match?("papote", {"sabana", 0}) == false
    end

    test "when given a list of clues" do
      assert possible_match?("popote", [{"vivote", 3}, {"sabana", 0}]) == true
      assert possible_match?("popote", [{"vivote", 0}, {"sabana", 0}]) == false
    end
  end
end
