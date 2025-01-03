# frozen_string_literal: true

require 'json'

module Cosensee
  # parse a line
  class LineParser
    INDENT_PATTERN = /\A([\t ]*)(.*)\z/
    QUOTE_PATTERN = /\A(>)(.*)\z/
    CODEBLOCK_PATTERN = /\A(code:)(.+)\z/
    COMMANDLINE_PATTERN = /\A([$%]) (.+)\z/

    def self.parse(line)
      new.parse(line)
    end

    def initialize
      @bracket_parser = Cosensee::BracketParser.new
    end

    # Rule:
    # quoteとcodeblockは併存しない
    def parse(line)
      indent, rest = parse_indent(line)
      line_content, rest2 = parse_whole_line(rest)

      return ParsedLine.new(indent:, line_content:) unless rest2

      content = rest2
                  .then { |data| parse_code(data) }
                  .then { |data| parse_double_bracket(data) }
                  .then { |data| parse_bracket(data) }
                  .then { |data| parse_url(data) }
                  .then { |data| parse_hashtag(data) }

      ParsedLine.new(indent:, line_content:, content:)
    end

    def parse_indent(line)
      matched = line.match(INDENT_PATTERN)
      [Cosensee::Indent.new(matched[1]), matched[2]]
    end

    def parse_whole_line(line)
      # parse quote
      matched = line.match(QUOTE_PATTERN)
      return [Cosensee::Quote.new(matched[1]), matched[2]] if matched

      # parse codeblock
      matched = line.match(CODEBLOCK_PATTERN)
      return [Cosensee::Codeblock.new(matched[2]), nil] if matched

      # parse command line
      matched = line.match(COMMANDLINE_PATTERN)
      return [Cosensee::CommandLine.new(content: matched[2], prompt: matched[1]), nil] if matched

      [nil, line]
    end

    def parse_code(line)
      parsed = []
      strs = line.split('`', -1)
      loop do
        str = strs.shift
        return parsed unless str

        parsed << str

        str = strs.shift
        return parsed unless str

        if strs.empty?
          parsed.last.concat("`#{str}")
          return parsed
        else
          parsed << Code.new(str)
        end
      end
    end

    def parse_hashtag(elements)
      parsed = []

      elements.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(/(^|\s)#(\S+)/)
            if matched
              parsed << "#{matched.pre_match}#{matched[1]}"
              parsed << Cosensee::HashTag.new(matched[2])
              elem = matched.post_match
            else
              parsed << elem
              break # loop
            end
          end
        else
          parsed << elem
        end
      end

      clean_elements(parsed)
    end

    def parse_url(elements)
      parsed = []

      elements.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(%r{(^|\s)(https?://[^\s]+)})
            if matched
              parsed << "#{matched.pre_match}#{matched[1]}"
              parsed << Cosensee::Link.new(matched[2])
              elem = matched.post_match
            else
              parsed << elem
              break # loop
            end
          end
        else
          parsed << elem
        end
      end

      clean_elements(parsed)
    end

    def parse_double_bracket(elements)
      parsed = []

      elements.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(/\[\[(.+?)\]\]/)
            if matched
              parsed << matched.pre_match
              parsed << Cosensee::DoubleBracket.new(matched[1])
              elem = matched.post_match
            else
              parsed << elem
              break # loop
            end
          end
        else
          parsed << elem
        end
      end

      clean_elements(parsed)
    end

    def parse_bracket(elements)
      parsed = []
      stack = nil
      target_char = '[' # or "]"

      elements.each do |elem|
        case elem
        when Cosensee::Code, Cosensee::DoubleBracket
          if target_char == '['
            parsed << elem
          else
            stack << elem
          end
        else # elem is String
          loop do
            n = elem.index(target_char)
            if n
              if target_char == '['
                parsed << elem[0, n]
                target_char = ']'
                stack = []
              else
                stack << elem[0, n]
                target_char = '['
                parsed << @bracket_parser.parse(stack)
                stack = nil
              end
              elem = elem[(n + 1)..]
            else
              if target_char == '['
                parsed << elem
              else
                stack << elem
              end
              break
            end
          end
        end
      end

      if stack
        # parsed += ['['] + stack
        parsed << '['
        parsed.concat(stack)
      end

      clean_elements(parsed)
    end

    def clean_elements(elements)
      fixed = []
      elements.each do |elem|
        last_elem = fixed.last
        if last_elem.is_a?(String) && elem.is_a?(String)
          last_elem.concat(elem)
        else
          fixed << elem
        end
      end

      fixed.filter { |elem| !elem.nil? && elem != '' }
    end
  end
end
