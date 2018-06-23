defmodule FalloutPasswordCracker.CLI do
  alias FalloutPasswordCracker.Cracker

  def main([]) do
    {:ok, _pid} = Cracker.start_link

    IO.puts ~S"""
    =========================================================================

      WELCOME TO PASWORDAMA 3000

      USAGE:

        - ADD <word>
        - ADDCLUE <clue> <matching_char_count>
        - GUESS

    =========================================================================

    """

    ####
    Cracker.set_words ~w[CURIOSITY DIRECTION EVERYTIME GENERATED GOSSIPING SITUATION SUMMONING TRIUMPHED UNLOCKING]
    Cracker.add_clue "SITUATION", 1
    ####

    prompt()
    Enum.each(IO.stream(:stdio, :line), &process_input/1)
  end

  defp process_input(input) do
    input |> String.trim |> String.upcase |> do_process_input
    prompt()
  end

  defp do_process_input("ADD " <> word), do: word |> String.upcase |> Cracker.add_word

  defp do_process_input(("ADDCLUE " <> input) = raw_cmd) do
    case Regex.run(~r{([a-zA-Z0-9]+)\s+([0-9]+)}, input) do
      [_, word, number] = match ->
        {number, _} = Integer.parse(number)
        Cracker.add_clue(word, number)

      nil -> error_prompt(raw_cmd)
    end
  end

  defp do_process_input("GUESS"), do: Cracker.guess |> info_prompt
  defp do_process_input("CLUES"), do: Cracker.clues |> info_prompt
  defp do_process_input("WORDS"), do: Cracker.words |> Enum.join(", ") |> info_prompt
  defp do_process_input("\n"),    do: nil
  defp do_process_input("EXIT"),  do: System.halt(0)
  defp do_process_input(input),   do: error_prompt(input)

  defp error_prompt(str), do: IO.puts(">>>>> ENOENT 0x#{random_str(10)} #{inspect(str)}")
  defp info_prompt(str),  do: IO.puts(">>>" <> inspect(str))
  defp prompt,            do: IO.write("> ")

  defp random_str(length), do: :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
end
