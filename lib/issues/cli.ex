defmodule Issues.CLI do
    @default_count 4
    
    @moduledoc """
    Handle the command line parsing and disptach to various functions 
    that end up generating a table of the last n issues in a github project
    """

    def run(argv) do
        argv
        |> parse_args
        |> process
    end

    @doc """
    `argv` can be -h or --help, which returns :help
    Otherwise it is a GH user name, project name and optional number of entries to get

    returns a tuple of {user,project,count} or `:help`
    """
    def parse_args(argv) do
        # parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
        # case parse do
        #     {[help: true], _, _} -> :help
        #     {_, [user, project, count], _ } -> {user, project, String.to_integer(count) }
        #     {_, [user, project], _} -> {user, project, @default_count}
        #     _ -> :help
        # end 
        OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end

    def args_to_internal_representation([user, project, count]) do
        {user, project, String.to_integer(count) }
    end
    def args_to_internal_representation([user, project]) do
        {user, project, @default_count }
    end
    def args_to_internal_representation(_) do
        :help
    end

    def process(:help) do
        IO.puts """ 
        usage: issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end
    def process({user, project, count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response()
        |> sort_into_descending_order()
        |> last(count)
    end  

    def decode_response({:ok, body}), do: body
    def decode_response({:error, error}) do
        IO.puts "Error fetching from github: #{error["message"]}"
        System.halt(2)
    end

    def sort_into_descending_order(list_of_issues) do
        list_of_issues |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
    end

    def last(list, count) do
        list
        |> Enum.take(count)
        |> Enum.reverse
    end
end