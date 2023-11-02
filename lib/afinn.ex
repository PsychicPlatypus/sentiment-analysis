defmodule Afinn do
  alias Language

  @type language :: :en | :dk
  @type rating :: :positive | :negative | :neutral

  @spec score(String.t(), language()) :: integer()
  def score(text, language) do
    dictionary = Language.read_dictionaries(language)

    Regex.replace(~r/[!'",.?]/, text, "")
    |> String.downcase()
    |> String.split(" ")
    |> Enum.map(fn x -> Map.get(dictionary, x, 0) end)
    |> Enum.sum()
  end

  @spec score_to_words(String.t(), language()) :: rating()
  def score_to_words(text, language) do
    score(text, language)
    |> then(fn score ->
      cond do
        score > 1 ->
          :positive

        score < -1 ->
          :negative

        score in -1..1 ->
          :neutral
      end
    end)
  end
end
