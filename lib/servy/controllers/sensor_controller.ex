defmodule Servy.Controllers.SensorController do
  alias Servy.Conv
  alias Servy.SensorServer
  alias Servy.Helpers
  @templates_path Path.expand("../../../templates/sensors", __DIR__)
  def index(conv) do
    images = SensorServer.get_sensor_data()
    res_body = Helpers.render(Path.join(@templates_path, "index.eex"), images: images)
    %Conv{conv | status: 200, res_body: res_body}
  end
end
