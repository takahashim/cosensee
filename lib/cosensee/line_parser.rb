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

    def self.merge_blocks(lines)
      prev_line = nil
      lines.each_with_object([]) do |line, result|
        if prev_line&.codeblock? && prev_line.indent_level < line.indent_level
          text = line.raw[prev_line.indent_level..]
          prev_line.append_text(text:, raw_line: line.raw)
        else
          result << line
          prev_line = line
        end
      end
    end

    def initialize
      @bracket_parser = BracketParser.new
    end

    def parse(line)
      parsed_line = ParsedLine.new(rest: line, raw: line)
      parsed_line
        .then { parse_indent(it) }
        .then { parse_whole_line(it) }
        .then { parse_code(it) }
        .then { parse_double_bracket(it) }
        .then { parse_bracket(it) }
        .then { parse_url(it) }
        .then { parse_hashtag(it) }
        .then { done_parsing(it) }
    end

    def parse_indent(line)
      matched = line.match(INDENT_PATTERN)
      ParsedLine.new(
        indent: Node::Indent.new(matched[1], matched[1]),
        rest: matched[2],
        raw: line.raw
      )
    end

    def parse_whole_line(line)
      # parse quote
      matched = line.match(QUOTE_PATTERN)
      if matched
        line.update(
          rest: matched[2],
          line_content: Node::Quote.new(content: nil, raw: matched[0], mark: matched[1])
        )
        return line
      end

      # parse codeblock
      matched = line.match(CODEBLOCK_PATTERN)
      if matched
        return line.update(
          rest: nil,
          line_content: Node::Codeblock.new(content: '', name: matched[2], raw: matched[0]),
          parsed: true
        )
      end

      # parse command line
      matched = line.match(COMMANDLINE_PATTERN)
      if matched
        return line.update(
          rest: nil,
          line_content: Node::CommandLine.new(content: matched[2], prompt: matched[1], raw: matched[0]),
          parsed: true
        )
      end

      line
    end

    def parse_code(line)
      return line if line.parsed?

      parsed = []
      strs = line.split_rest_by('`')
      loop do
        str = strs.shift
        if str.nil?
          return line.update(
            rest: nil,
            content: parsed
          )
        end

        parsed << str

        str = strs.shift
        if str.nil?
          return line.update(
            rest: nil,
            content: parsed
          )
        end

        if strs.empty?
          parsed.last.concat("`#{str}")
          return line.update(
            rest: nil,
            content: parsed
          )
        else
          parsed << Node::Code.new(str, "`#{str}`")
        end
      end
    end

    def parse_hashtag(line)
      return line if line.parsed?

      parsed = []

      line.content.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(/(^|\s)#(\S+)/)
            if matched
              parsed << "#{matched.pre_match}#{matched[1]}"
              parsed << Node::HashTag.new(content: matched[2], raw: "##{matched[2]}")
              elem = matched.post_match
            else
              parsed << elem
              break # from loop
            end
          end
        else
          parsed << elem
        end
      end

      line.update(content: clean_elements(parsed))
    end

    def parse_url(line)
      return line if line.parsed?

      parsed = []

      line.content.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(%r{(^|.*?)(https?://[^\s]+)})
            if matched
              parsed << "#{matched.pre_match}#{matched[1]}"
              parsed << Node::Link.new(matched[2], matched[2])
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

      line.update(content: clean_elements(parsed))
    end

    def parse_double_bracket(line)
      return line if line.parsed?

      parsed = []

      line.content.each do |elem|
        if elem.is_a?(String)
          loop do
            matched = elem.match(/\[\[(.+?)\]\]/)
            if matched
              parsed << matched.pre_match
              parsed << Node::DoubleBracket.new(content: [matched[1]], raw: matched[0])
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

      line.update(content: clean_elements(parsed))
    end

    def parse_bracket(line)
      return line if line.parsed?

      parsed = []
      stack = nil
      target_char = '[' # or "]"

      line.content.each do |elem|
        case elem
        when Node::Code, Node::DoubleBracket
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

      line.update(content: clean_elements(parsed))
    end

    def done_parsing(line)
      # If the line_content is Cosensee::Node::Quote, move content into it.
      if line.line_content.is_a?(Node::Quote)
        new_quote = line.line_content.replace_content(line.content)
        line.update(line_content: new_quote, content: [])
      end
      line.update(parsed: true)
    end

    def clean_elements(elements)
      fixed = []
      elements.each do |elem|
        last_elem = fixed.last
        if last_elem.is_a?(String) && elem.is_a?(String)
          fixed[-1] = "#{last_elem}#{elem}"
        else
          fixed << elem
        end
      end

      fixed.filter { |elem| !elem.nil? && elem != '' }
    end
  end
end
