defmodule Youtex.TranscriptParser do
  @moduledoc false

  @spec parse(String.t()) :: [Youtex.transcription()]
  def parse({:ok, plain_data}) do
    plain_data
    |> xml_to_map()
    |> raw_transcripts()
    |> Enum.map(&to_transcript(&1))
  end

  def parse({:error, _data}), do: []

  defp xml_to_map(plain_data), do: XmlToMap.naive_map(plain_data)

  defp raw_transcripts(%{"transcript" => %{"text" => transcripts}}), do: transcripts

  defp to_transcript(%{"#content" => text, "-start" => start, "-dur" => duration}) do
    %{
      text: text,
      start: Float.parse(start),
      duration: Float.parse(duration)
    }
  end
end
