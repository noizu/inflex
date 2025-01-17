defmodule Inflex.Pluralize do
  @moduledoc """
  # Inflex.Pluralize

  `Inflex.Pluralize` provides functionality to convert words from singular to plural form and vice versa.

  ## Usage

  The main functions in this module are `singularize/1` and `pluralize/1`. These functions take a word as an argument and return the singular or plural form of the word, respectively.

  Here is an example of how to use `singularize/1`:

     iex> Inflex.Pluralize.singularize("men")
     "man"

  In the example above, the word "men" is converted to "man".

  Here is an example of how to use `pluralize/1`:

     iex> Inflex.Pluralize.pluralize("child")
     "children"

  In this example, the word "child" is converted to "children".

  ## Functions

  - `singularize/1`: This function takes a word and returns the singular form of the word.

  - `pluralize/1`: This function takes a word and returns the plural form of the word.

  - `inflect/2`: This function takes a word and a number. If the number is 1, it returns the singular form of the word. If the number is not 1, it returns the plural form of the word.

  ## Notes

  Please note that these functions are designed to work with English words. Words in other languages may not be handled correctly.
  """

  @default true

  @uncountable [
    "aircraft",
    "bellows",
    "bison",
    "deer",
    "equipment",
    "fish",
    "hovercraft",
    "information",
    "jeans",
    "means",
    "measles",
    "money",
    "moose",
    "news",
    "pants",
    "police",
    "rice",
    "series",
    "sheep",
    "spacecraft",
    "species",
    "swine",
    "tights",
    "tongs",
    "trousers"
  ]

  @irregular [
    {~r/(alumn|cact|fung|radi|stimul|syllab)i/i, "\\1us"},
    {~r/(alg|antenn|amoeb|larv|vertebr)ae/i, "\\1a"},
    {~r/^(gen)era$/i, "\\1us"},
    {~r/(pe)ople/i, "\\1rson"},
    {~r/^(zombie)s$/i, "\\1"},
    {~r/(g)eese/i, "\\1oose"},
    {~r/(criteri)a/i, "\\1on"},
    {~r/^(m)en$/i, "\\1an"},
    {~r/^(echo)es/i, "\\1"},
    {~r/^(hero)es/i, "\\1"},
    {~r/^(potato)es/i, "\\1"},
    {~r/^(tomato)es/i, "\\1"},
    {~r/^(t)eeth/i, "\\1ooth"},
    {~r/^(l)ice$/i, "\\1ouse"},
    {~r/^(addend|bacteri|curricul|dat|memorand|quant)a$/i, "\\1um"},
    {~r/^(di)ce/i, "\\1e"},
    {~r/^(f)eet/i, "\\1oot"},
    {~r/^(phenomen)a/i, "\\1on"}
  ]

  @plural_irregular [
    {~r/(alumn|cact|fung|radi|stimul|syllab)us/i, "\\1i"},
    {~r/(alg|antenn|amoeb|larv|vertebr)a/i, "\\1ae"},
    {~r/^(gen)us$/i, "\\1era"},
    {~r/(pe)rson$/i, "\\1ople"},
    {~r/^(zombie)s$/i, "\\1"},
    {~r/(g)oose$/i, "\\1eese"},
    {~r/(criteri)on/i, "\\1a"},
    {~r/^(men)$/i, "\\1"},
    {~r/^(women)/i, "\\1"},
    {~r/^(echo)$/i, "\\1es"},
    {~r/^(hero)$/i, "\\1es"},
    {~r/^(potato)/i, "\\1es"},
    {~r/^(tomato)/i, "\\1es"},
    {~r/^(t)ooth$/i, "\\1eeth"},
    {~r/^(l)ouse$/i, "\\1ice"},
    {~r/^(addend|bacteri|curricul|dat|memorand|quant)um$/i, "\\1a"},
    {~r/^(di)e$/i, "\\1ce"},
    {~r/^(f)oot$/i, "\\1eet"},
    {~r/^(phenomen)on/i, "\\1a"}
  ]

  @singular @irregular ++
            [
              {~r/(child)ren/i, "\\1"},
              {~r/(wo|sea)men$/i, "\\1man"},
              {~r/^(m|l)ice$/i, "\\1ouse"},
              {~r/(bus|canvas|status|alias)(es)?$/i, "\\1"},
              {~r/(ss)$/i, "\\1"},
              {~r/(database)s$/i, "\\1"},
              {~r/([ti])a$/i, "\\1um"},
              {~r/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i,
                "\\1sis"},
              {~r/(analy)(sis|ses)$/i, "\\1sis"},
              {~r/(octop|vir)i$/i, "\\1us"},
              {~r/(hive)s$/i, "\\1"},
              {~r/(tive)s$/i, "\\1"},
              {~r/(er)ves$/i, "\\1ve"},
              {~r/([lora])ves$/i, "\\1f"},
              {~r/([^f])ves$/i, "\\1fe"},
              {~r/([^aeiouy]|qu)ies$/i, "\\1y"},
              {~r/(m)ovies$/i, "\\1ovie"},
              {~r/(x|ch|ss|sh)es$/i, "\\1"},
              {~r/(shoe)s$/i, "\\1"},
              {~r/(o)es$/i, "\\1"},
              {~r/s$/i, ""}
            ]

  @plural @plural_irregular ++
          [
            {~r/(child)$/i, "\\1ren"},
            {~r/(m)an$/i, "\\1en"},
            {~r/(m|l)ouse/i, "\\1ice"},
            {~r/(database)s$/i, "\\1"},
            {~r/(quiz)$/i, "\\1zes"},
            {~r/^(ox)$/i, "\\1en"},
            {~r/(matr|vert|ind)ix|ex$/i, "\\1ices"},
            {~r/(x|ch|ss|sh)$/i, "\\1es"},
            {~r/([^aeiouy]|qu)y$/i, "\\1ies"},
            {~r/(hive)$/i, "\\1s"},
            {~r/(sc[au]rf)$/i, "\\1s"},
            {~r/(?:([^f])fe|((hoo)|([lra]))f)$/i, "\\2\\1ves"},
            {~r/sis$/i, "ses"},
            {~r/([ti])um$/i, "\\1a"},
            {~r/(buffal|tomat)o$/i, "\\1oes"},
            {~r/(octop|vir)us$/i, "\\1i"},
            {~r/(bus|alias|status|canvas)$/i, "\\1es"},
            {~r/(ax|test)is$/i, "\\1es"},
            {~r/s$/i, "s"},
            {~r/data$/i, "data"},
            {~r/$/i, "s"}
          ]

  @singular @irregular ++
            [
              {~r/(child)ren/i, "\\1"},
              {~r/(wo|sea)men$/i, "\\1man"},
              {~r/^(m|l)ice$/i, "\\1ouse"},
              {~r/(bus|canvas|status|alias)(es)?$/i, "\\1"},
              {~r/(ss)$/i, "\\1"},
              {~r/(database)s$/i, "\\1"},
              {~r/([ti])a$/i, "\\1um"},
              {~r/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i,
                "\\1sis"},
              {~r/(analy)(sis|ses)$/i, "\\1sis"},
              {~r/(octop|vir)i$/i, "\\1us"},
              {~r/(hive)s$/i, "\\1"},
              {~r/(tive)s$/i, "\\1"},
              {~r/(er)ves$/i, "\\1ve"},
              {~r/([lora])ves$/i, "\\1f"},
              {~r/([^f])ves$/i, "\\1fe"},
              {~r/([^aeiouy]|qu)ies$/i, "\\1y"},
              {~r/(m)ovies$/i, "\\1ovie"},
              {~r/(x|ch|ss|sh)es$/i, "\\1"},
              {~r/(shoe)s$/i, "\\1"},
              {~r/(o)es$/i, "\\1"},
              {~r/s$/i, ""}
            ]

  @plural @plural_irregular ++
          [
            {~r/(child)$/i, "\\1ren"},
            {~r/(m)an$/i, "\\1en"},
            {~r/(m|l)ouse/i, "\\1ice"},
            {~r/(database)s$/i, "\\1"},
            {~r/(quiz)$/i, "\\1zes"},
            {~r/^(ox)$/i, "\\1en"},
            {~r/(matr|vert|ind)ix|ex$/i, "\\1ices"},
            {~r/(x|ch|ss|sh)$/i, "\\1es"},
            {~r/([^aeiouy]|qu)y$/i, "\\1ies"},
            {~r/(hive)$/i, "\\1s"},
            {~r/(sc[au]rf)$/i, "\\1s"},
            {~r/(?:([^f])fe|((hoo)|([lra]))f)$/i, "\\2\\1ves"},
            {~r/sis$/i, "ses"},
            {~r/([ti])um$/i, "\\1a"},
            {~r/(buffal|tomat)o$/i, "\\1oes"},
            {~r/(octop|vir)us$/i, "\\1i"},
            {~r/(bus|alias|status|canvas)$/i, "\\1es"},
            {~r/(ax|test)is$/i, "\\1es"},
            {~r/s$/i, "s"},
            {~r/data$/i, "data"},
            {~r/$/i, "s"}
          ]

  @doc """
  `Inflex.Pluralize.singularize/1` is a function that takes a word and returns the singular form of the word.

  ## Examples

      iex> Inflex.Pluralize.singularize("men")
      "man"

      iex> Inflex.Pluralize.singularize("man")
      "man"

      iex> Inflex.Pluralize.singularize("apples")
      "apple"
  """
  def singularize(word) when is_atom(word) do
    find_match(@singular, to_string(word))
  end

  def singularize(word), do: find_match(@singular, word)


  @doc """
  `Inflex.Pluralize.pluralize/1` is a function that takes a word and returns the plural form of the word.

  ## Examples

      iex> Inflex.Pluralize.pluralize("child")
      "children"

      iex> Inflex.Pluralize.pluralize(:child)
      "children"

      iex> Inflex.Pluralize.pluralize("apples")
      "apples"

      iex> Inflex.Pluralize.pluralize("peg")
      "pegs"

  ## Note
  irregular cases may not pluralize correctly if already in plural form children -> childrens for example.
  """
  def pluralize(word) when is_atom(word) do
    find_match(@plural, to_string(word))
  end

  def pluralize(word), do: find_match(@plural, word)


  @doc """
  `Inflex.Pluralize.inflect/2` is a function that takes a word and a number. If the number is 1, it returns the singular form of the word. If the number is not 1, it returns the plural form of the word.

  ## Examples

    iex> Inflex.Pluralize.inflect("child", 1)
    "child"

    iex> Inflex.Pluralize.inflect(:child, 1)
    "child"

    iex> Inflex.Pluralize.inflect("child", 22)
    "children"

    iex> Inflex.Pluralize.inflect(:pegs, 1)
    "peg"

    iex> Inflex.Pluralize.inflect("pegs", 22)
    "pegs"
  """
  def inflect(word, n) when n == 1, do: singularize(word)
  def inflect(word, n) when is_number(n), do: pluralize(word)

  defp find_match(set, word) do
    cond do
      uncountable?(word) -> word
      @default -> replace_match(set, word)
    end
  end

  defp replace_match(set, word) do
    find_in_set(set, word) |> replace(word)
  end

  defp find_in_set(set, word) do
    Enum.find(set, fn {reg, _} -> Regex.match?(reg, word) end)
  end

  defp replace({regex, replacement}, word) do
    Regex.replace(regex, word, replacement)
  end

  defp replace(_, word), do: word

  defp uncountable?(word), do: Enum.member?(@uncountable, word)
end
