defmodule TimeManager.Management.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :utc_datetime
    field :status, :boolean, default: false
    
    belongs_to :user, TimeManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
