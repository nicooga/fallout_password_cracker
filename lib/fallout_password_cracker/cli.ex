defmodule FalloutPasswordCracker.CLI do
  alias FalloutPasswordCracker.Cracker

  @prompt "@> "
  @error_prompt "@>>>>> INVALID COMMAND "
  @info_prompt "@>>> "

  def main([]) do
    {:ok, _pid} = Cracker.start_link

    IO.puts ~S"""
    =========================================================================

      WELCOME TO PASWORDAMA 3000

      COMMANDS:

        - ADD <someword>                       -- ADD THE WORD TO THE STACK
        - ADDCLUE <clue> <matching_char_count> -- ADD A CLUE
        - GUESS                                -- PERFORM A GUESS

    =========================================================================

    """

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
      [_, word, number] ->
        number = Integer.parse(number)
        Cracker.add_clue(word, number)

      nil -> error_prompt(raw_cmd)
    end
  end

  defp do_process_input("GUESS"), do: Cracker.guess |> info_prompt
  defp do_process_input("WORDS"), do: Cracker.words |> Enum.join(", ") |> info_prompt
  defp do_process_input("\n"),    do: nil
  defp do_process_input("EXIT"),  do: System.halt(0)
  defp do_process_input(input),   do: error_prompt(input)

  defp error_prompt(str), do: IO.puts(@error_prompt <> inspect(str))
  defp info_prompt(str),  do: IO.puts(@info_prompt <> str)
  defp prompt,            do: IO.write(@prompt)
end
