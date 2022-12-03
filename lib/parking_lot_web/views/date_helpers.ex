defmodule ParkingLotWeb.DateHelpers do
  def format_time(datetime, opts) do
    datetime
    |> Timex.Timezone.convert(opts[:timezone])
    |> IO.inspect()
    |> Timex.lformat!("%d/%m/%y %H:%M:%S", opts[:locale], :strftime)
  end
end
