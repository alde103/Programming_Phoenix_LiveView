defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Catalog.Product

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  @doc false
  def markdown_product_changeset(%Product{unit_price: current_unit_price} = product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_number(:unit_price, less_than: current_unit_price)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
end
