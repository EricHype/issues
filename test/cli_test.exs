defmodule CLI_Test do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]
  test ":help is returns from -h or -help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["-help", "anything"]) == :help
  end

  test "three values are returned if three values are passed in" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values are passed in" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
