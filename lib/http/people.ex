defmodule People.People do
  @behaviour :cowboy_http_handler
  import Ecto.Query

  alias People.Repo, as: Repo
  alias People.PeopleSchema, as: PeopleSchema

  def init({ _any, :http }, req, []) do
    { :ok, req, :undefined }
  end

  def handle(req, state) do
    { method, _ } = :cowboy_req.method req
    IO.puts method
    # IO.inspect map_data
    case method do
      "GET" ->
        get_handle(req, state)
      "PUT" ->
        put_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def get_handle(req, state) do
    people = PeopleSchema
      |> select([m], %{
        "id" => m.id,
        "name" => m.name,
        "email" => m.email
        })
      |> Repo.all
    { :ok, req } = :cowboy_req.reply 200, [], Poison.encode!(people), req
    { :ok, req, state }
  end

  def put_handle(req, state) do
    # IO.inspect Ecto.Date.cast!("2015-05-12")
    # people = %PeopleSchema{name: "Ben", email: "555"}
    # Repo.insert!(people)
    { :ok, body, req } = :cowboy_req.body_qs(req)
    if body !== [] do
      body = body |> List.first |> elem 0
      body = Poison.decode!(body, keys: :atoms)
      require_field = [:name, :email]
      mf = miss_fieldes(require_field, Map.keys(body))
      if mf == [] do
        IO.inspect body
        people = %PeopleSchema{
          name: Map.get(body, :name),
          email: Map.get(body, :email)
        }
        Repo.insert!(people)
        status_code = 200
        data = Poison.encode!(body)
      else
        status_code = 400
        data = Poison.encode!(mf)
      end
    else
      status_code = 400
      data = "No body."
    end
    { :ok, req } = :cowboy_req.reply status_code, [], data, req
    { :ok, req, state }
  end

  def miss_fieldes(require_field, keys_body) do
    Enum.filter(require_field, fn(f) -> not Enum.member?(keys_body, f) end)
  end

  def terminate(_reason, _request, _state) do
    :ok
  end
end
