defmodule FalloutPasswordCracker.Cracker do
  @moduledoc "Service for cracking passwords. Holds a list of words that can be updated."

  @doc "Starts the server"
  def start_link, do: GenServer.start_link(__MODULE__.Server, [])

  @doc "Returns the current words"
  def words, do: call(:words)

  @doc "Returns the current clues"
  def clues, do: call(:clues)

  @doc "Adds a single word"
  def add_word(word), do: call({:add_word, word})

  @doc "Sets the entire list of words, and resets the clues"
  def set_words(words), do: call({:set_words, words})

  @doc "Adds a single clue ablut a word in the list"
  def add_clue(word, matching_char_count), do: call({:add_clue, word, matching_char_count})

  @doc "Returns a guess about which could be the password"
  def guess, do: call(:guess)

  defp call(term), do: GenServer.call(__MODULE__.Server, term, 12391293)
end
