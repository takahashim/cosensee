# frozen_string_literal: true

require 'json'

module Cosensee
  # parse a line
  class LineParser
    INDENT_PATTERN = /\A([\t ]*)/

    def self.parse(line)
      new.parse(line)
    end

    def initialize; end

    # Rule:
    # blockquoteとcodeblockは併存しない
    # codeblockが使われる場合はrest3やrest5は存在しない
    def parse(line)
      indent, rest = parse_indent(line)
      blockquote, rest2 = parse_blockquote(rest)
      codeblock, rest3 = parse_codeblock(rest2)
      rest4 = parse_code(rest3)
      rest5 = parse_bracket(rest4)
      [indent, blockquote, codeblock, rest5]
    end

    def parse_indent(line)
      matched = line.match(/\A([\t ]*)(.*)\z/)
      [Cosensee::Indent.new(matched[1]), matched[2]]
    end

    def parse_blockquote(line)
      matched = line.match(/\A(>)(.*)\z/)
      if matched
        [Cosensee::Blockquote.new(matched[1]), matched[2]]
      else
        ['', line]
      end
    end

    def parse_codeblock(line)
      matched = line.match(/\A(code:)(.+)\z/)
      if matched
        [Cosensee::Codeblock.new(matched[2]), '']
      else
        ['', line]
      end
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

    def parse_bracket(rest)
      parsed = []
      stack = nil
      target_char = '[' # or "]"

      rest.each do |elem|
        if elem.is_a?(Cosensee::Code)
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
                parsed << Cosensee::Bracket.new(stack)
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
        parsed << '['
        parsed.concat(stack)
      end

      clean_elements(parsed)
    end

    def clean_elements(elements)
      prev = nil
      fixed = []
      elements.each do |elem|
        if prev.is_a?(String) && elem.is_a?(String)
          prev.concat(elem)
        else
          fixed << elem
          prev = elem
        end
      end

      fixed.filter { |elem| !elem.nil? && elem != '' }
    end
  end
end
