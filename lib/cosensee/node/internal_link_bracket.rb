# frozen_string_literal: true

module Cosensee
  module Node
    # for Icon
    InternalLinkBracket = Data.define(:content, :anchor, :raw) do
      include BracketSerializer
      include ::Cosensee::LinkEncodable

      def link
        make_link(anchor)
      end
    end
  end
end
