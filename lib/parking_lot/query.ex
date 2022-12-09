defmodule ParkingLot.Query do
  @moduledoc false

  import Ecto.Query

  def where_include_deleted(query, true) do
    where(query, [q], not is_nil(q.deleted_at))
  end

  def where_include_deleted(query, false) do
    where(query, [q], is_nil(q.deleted_at))
  end
end
