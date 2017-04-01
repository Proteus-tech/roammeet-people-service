defmodule People do
  @moduledoc """
  Documentation for People.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(People.Repo, [], restart: :transient),
      worker(People.HTTP, [], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: People.Supervisor]
    Supervisor.start_link(children, opts)
   end
end
