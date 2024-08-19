defmodule XlWebsiteWeb.LayoutComponents do
  use Phoenix.Component
  use XlWebsiteWeb, :verified_routes
  import XlWebsiteWeb.CoreComponents

  attr :route, :string, default: nil

  def layout_header(assigns) do
    ~H"""
    <header class="h-[60px] bg-[#4d1e93] sticky top-0 z-10">
      <div class="h-full flex items-center max-w-[1200px] m-auto px-5">
        <.link href={~p"/"} class="text-white text-[40px] tracking-wider font-['Jersey_10'] ml-[1px]">
          XL
        </.link>
        <nav class="ml-auto">
          <menu class="text text-white flex gap-6">
            <.link
              href={~p"/exercises"}
              class={[
                "text-lg",
                @route == "Exercises" && "underline underline-offset-4"
              ]}
            >
              exercises
            </.link>
            <.link
              href={~p"/ecosystem"}
              class={[
                "text-lg",
                @route == "Ecosystem" && "underline underline-offset-4"
              ]}
            >
              ecosystem
            </.link>
            <.link
              href={~p"/about"}
              class={[
                "text-lg",
                @route == "About" && "underline underline-offset-4"
              ]}
            >
              about
            </.link>
          </menu>
        </nav>
      </div>
      <.dark_mode_toggler class="absolute bottom-1/2 right-5 translate-y-1/2" />
    </header>
    """
  end

  attr :class, :string, default: nil
  attr :mode, :atom, values: [:light, :dark], default: :light

  def dark_mode_toggler(assigns) do
    ~H"""
    <button type="button" class={@class} id="dark-mode-toggler">
      <.icon data-icon="light" name="hero-sun-solid" class="text-white h-6 w-6 dark:hidden" />
      <.icon data-icon="dark" name="hero-moon-solid" class="text-white h-5 w-5 hidden dark:block" />
      <div
        data-icon="auto"
        class="bg-white border-2 border-[#4d1e93] text-[#4d1e93] absolute text-xs font-bold -right-2 top-0 rounded px-[2px]"
      >
        A
      </div>
    </button>
    """
  end
end
