defmodule FalloutPasswordCracker.Cracker.Server do
  @moduledoc "This server holds state for the password cracker service"
  use GenServer
  alias FalloutPasswordCracker.Cracker.Implementation, as: Impl

  defdelegate str_length(str), to: String, as: :length

  @initial_state %{words: MapSet.new, clues: %{}, word_length: nil}

  def start_link, do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def init([]), do: {:ok, @initial_state}

  @doc "Returns the current words the cracker is working with"
  def handle_call(:words, _from, state), do: {:reply, state.words, state}

  @doc "Returns the current clues in the cracker"
  def handle_call(:clues, _from, state), do: {:reply, state.clues, state}

  @doc "Sets the entire list of words again. Clues are emptied"
  def handle_call({:set_words, words}, _from, state) when is_list(words) do
    state = put_in(state.words, MapSet.new(words))
    state = put_in(state.clues, %{})
    {:reply, :ok, state}
  end

  @doc "Adds a new word to the list"
  def handle_call({:add_word, word}, _from, state) when is_binary(word) do
    if valid_word?(word, state) do
      {:reply, {:error, :invalid_word_length}, state}
    else
      state = update_in(state.words, &MapSet.put(&1, word))
      state = put_in(state.word_length, str_length(word))
      {:reply, :ok, state}
    end
  end

  @doc "Adds a single clue about a word already in the list"
  def handle_call({:add_clue, word, matching_char_count}, _from, state) when is_binary(word) do
    if valid_clue?(word, state),
      do: {:reply, :ok, put_in(state, [:clues, word], matching_char_count)},
      else: {:reply, {:error, :invalid_word}, state}
  end

  @doc "Performs a guess about which would be the password"
  def handle_call(:guess, _from, state), do: {:reply, Impl.guess(state.words, state.clues), state}

  @doc "Resets words and clues"
  def handle_call(:reset, _from, _state), do: {:reply, :ok, @initial_state}

  # Words must be all the same length.
  defp valid_word?(word, state), do: state.word_length && str_length(word) != state.word_length
  defp valid_clue?(word, state), do: word in state.words
end
