# frozen_string_literal: true

module Cosensee
  class TailwindRenderer
    IconBracket = Data.define(:content) do
      include HtmlEncodable

      def render
        # XXX use icon image finder with project object
        %(<span>[icon:#{escape_html(content.icon_name)}]</span>)
      end
    end
  end
end
