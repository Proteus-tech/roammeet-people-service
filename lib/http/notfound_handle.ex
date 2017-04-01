defmodule People.HTTP.NotFoundHandler do
    @behaviour :cowboy_http_handler
    @moduledoc """
        This is a stub handler
    """

    def init({ _any, :http }, req, []) do
        { :ok, req, :undefined }
    end

    def handle(req, state) do
        { :ok, req } = :cowboy_req.reply 404, [], "404 Not Found", req
        { :ok, req, state }
    end

    def terminate(_reason, _request, _state) do
        :ok
    end
end
