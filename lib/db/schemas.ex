defmodule People.PeopleSchema do
  use Ecto.Schema

  # people is the DB table
  schema "people" do
    field :name, :string
    field :email, :string


    timestamps()
  end
end
