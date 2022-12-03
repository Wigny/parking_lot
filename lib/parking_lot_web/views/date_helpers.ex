defmodule ParkingLotWeb.DateHelpers do
  def format_time(datetime, opts) do
    datetime
    |> Timex.Timezone.convert(opts[:timezone])
    |> Timex.lformat!("%d/%m/%y %H:%M:%S", opts[:locale], :strftime)
  end
end
