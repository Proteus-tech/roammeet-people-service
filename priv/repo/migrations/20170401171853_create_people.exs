defmodule People.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :email, :string
      add :name, :string

      timestamps()
    end
    create unique_index(:people, :email, [])
  end
end
