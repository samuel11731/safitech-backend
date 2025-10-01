defmodule SafitechBackendWeb.LayoutView do
  use SafitechBackendWeb, :html

  def flash_group(assigns) do
    SafitechBackendWeb.Layouts.flash_group(assigns)
  end

  def theme_toggle(assigns) do
    SafitechBackendWeb.Layouts.theme_toggle(assigns)
  end
end
