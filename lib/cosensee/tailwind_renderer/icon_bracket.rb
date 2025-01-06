# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    IconBracket = Data.define(:content, :project) do
      include HtmlEncodable

      def render
        page = project.page_store.find_page_by_title(content.icon_name)
        icon_src = page&.first_image&.src
        %(<img src="#{icon_src}" alt="icon" class="inline-block h-5 w-5 align-middle">)
      end
    end
  end
end
