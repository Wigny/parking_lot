defmodule ParkingLot.ReqCacheFile do
  alias Req.{Request, Response}

  @user_cache_dir :filename.basedir(:user_cache, "")

  def attach(%Request{} = req, options \\ []) do
    req
    |> Request.register_options([:cache_dir])
    |> Request.merge_options(options)
    |> Request.append_request_steps(cache_file: &read_file/1)
    |> Request.prepend_response_steps(cache_file: &write_file/1)
  end

  defp read_file(request) do
    base_dir = Request.get_option(request, :cache_dir, @user_cache_dir)
    filename = Path.basename(request.url.path)

    filepath = Path.join(Path.expand(base_dir), filename)

    if File.exists?(filepath) do
      {request, Response.new(body: File.read!(filepath))}
    else
      Request.put_private(request, :filepath, filepath)
    end
  end

  defp write_file({request, response}) do
    if filepath = Request.get_private(request, :filepath) do
      File.mkdir_p!(Path.dirname(filepath))
      File.write!(filepath, response.body)
    end

    {request, response}
  end
end
