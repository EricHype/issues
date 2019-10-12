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

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end
end