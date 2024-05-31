defmodule Pento.Search do
  defstruct [:sku]
  @types %{sku: :string}
  import Ecto.Changeset

  def changeset(%__MODULE__{} = search, attrs) do
    {search, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:sku])
    |> validate_length(:sku, min: 7)
  end
end
