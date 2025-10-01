defmodule SafitechBackendWeb.Layouts do
  use SafitechBackendWeb, :html

  embed_templates "layouts/*"

  def flash_group(assigns) do
    ~H"""
    <div class="flash-group">
      <!-- Add flash message rendering here -->
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <button class="theme-toggle">
      Toggle Theme
    </button>
    """
  end
end
