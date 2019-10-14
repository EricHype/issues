defmodule Issues.GithubIssues do
  @user_agent[{"User-Agent", "username@gmail.com"}]

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
  
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get()
    |> handle_response
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
    status_code |> check_for_error,
    body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end