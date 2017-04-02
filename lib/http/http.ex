defmodule People.HTTP do
  @moduledoc """
      Websocket Server is created by cowboy.
  """

  def start_link do
    { :ok, _ } = :cowboy.start_http(
      :http,
      100,
      [port: 8008],
      [env: [
          dispatch: routes()
        ]
      ]
    )
  end

  def routes do
    :cowboy_router.compile([
      { :_,
        [
          {"/hello", People.Hello, []},
          {"/peoples", People.HTTP.Peoples, []},
          {"/people/:email", People.HTTP.People, []},
          {:_, People.HTTP.NotFoundHandler, []},
        ]
      }
    ])
  end
end
