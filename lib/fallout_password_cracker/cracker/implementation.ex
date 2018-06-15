defmodule FalloutPasswordCracker.Cracker.Implementation do
  # For a list of words, returns the best guess for a matching password
  def guess([]), do: nil
  def guess(words), do: Enum.max_by(words, &matching_char_count(&1, words))
  def guess([], []), do: nil
  def guess(words, []), do: guess(words)
  def guess(words, clues) do
    words
    |> Enum.filter(&possible_match?(&1, clues))
    |> guess
  end

  # Same as others, but the word must match all the clues in the list
  def possible_match?(word, {clue_word, match_count}), do: matching_char_count(word, clue_word) == match_count
  def possible_match?(word, clues), do: Enum.all?(clues, &possible_match?(word, &1))

  # Returns the number of positionaly matching chars between two words
  def matching_char_count(left_word, right_word) when is_binary(left_word) and is_binary(right_word) do
    left_chars = String.codepoints(left_word)
    right_chars = String.codepoints(right_word)

    left_chars
    |> Enum.zip(right_chars)
    |> Enum.map(fn {lc, rc} -> lc == rc end)
    |> Enum.count(&(&1))
  end

  # Returns the number sum of matching chars between each word in the list and the target word
  def matching_char_count(word, words) do
    words
    |> Enum.map(&matching_char_count(word, &1))
    |> Enum.sum
  end
end

