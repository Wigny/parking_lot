defmodule Parking.Changeset do
  import Ecto.Changeset

  def mark_deletion(changeset) do
    now = DateTime.truncate(DateTime.utc_now(), :second)
    %{change(changeset, deleted_at: now) | action: :update}
  end
end
