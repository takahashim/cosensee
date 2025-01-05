# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::ParsedLine do
  subject(:renderer) { Cosensee::TailwindRenderer::ParsedLine.new(parsed_line) }

  let(:parser) { Cosensee::LineParser.new }
  let(:parsed_line) { parser.parse(source) }

  describe '#parse' do
    where(:source, :rendered) do
      [
        [
          '',
          '<div class="relative pl-[0rem]"></div>'
        ],
        [
          'a',
          '<div class="relative pl-[0rem]">a</div>'
        ],
        [
          ' a',
          '<div class="relative pl-[2rem]">a</div>'
        ],
        [
          " \tabc",
          '<div class="relative pl-[4rem]">abc</div>'
        ],
        [
          '`a`bc',
          '<div class="relative pl-[0rem]"><code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">a</code>bc</div>'
        ],
        [
          '$ a b c',
          '<div class="relative pl-[0rem]"><code class="bg-gray-100 text-gray-800 px-4"><span class="text-red-400">$</span>a b c</code></div>'
        ],
        [
          '$ a [b] c',
          '<div class="relative pl-[0rem]"><code class="bg-gray-100 text-gray-800 px-4"><span class="text-red-400">$</span>a [b] c</code></div>'
        ],
        [
          '$ a `b` c',
          '<div class="relative pl-[0rem]"><code class="bg-gray-100 text-gray-800 px-4"><span class="text-red-400">$</span>a `b` c</code></div>'
        ],
        [
          '[',
          '<div class="relative pl-[0rem]">[</div>'
        ],
        [
          '[]',
          '<div class="relative pl-[0rem]"><span>[]</span></div>'
        ],
        [
          '[abc]',
          '<div class="relative pl-[0rem]"><span><a href="abc.html">abc</a></span></div>'
        ],
        [
          '12[abc]34',
          '<div class="relative pl-[0rem]">12<span><a href="abc.html">abc</a></span>34</div>'
        ],
        [
          'a[[b[]c]]d[e]f',
          '<div class="relative pl-[0rem]">a<span class="font-bold">b[]c</span>d<span><a href="e.html">e</a></span>f</div>'
        ],
        [
          'a[[b[]c]]d[e]f',
          '<div class="relative pl-[0rem]">a<span class="font-bold">b[]c</span>d<span><a href="e.html">e</a></span>f</div>'
        ],
        [
          '12 #abc 34',
          '<div class="relative pl-[0rem]">12 <span><a href="abc.html">#abc</a></span> 34</div>'
        ],
        [
          '12[a`bc]34',
          '<div class="relative pl-[0rem]">12<span><a href="a%60bc.html">a`bc</a></span>34</div>'
        ],
        [
          '   12[a`b`c]34',
          '<div class="relative pl-[6rem]">12<span>[a<code class="bg-gray-100 text-red-500 px-1 py-0.5 rounded">b</code>c]</span>34</div>'
        ],
        [
          '   12[ https://example.com #foo bar]34',
          '<div class="relative pl-[6rem]">12<span>[ <span><a href="https://example.com">https://example.com</a></span> <span><a href="foo.html">#foo</a></span> bar]</span>34</div>'
        ],
        [
          '>   12[ https://example.com #foo bar]34',
          '<div class="relative pl-[0rem]"><blockquote class="border-l-4 border-gray-300 bg-gray-100 px-4 text-gray-800">   12<span>[ <span><a href="https://example.com">https://example.com</a></span> <span><a href="foo.html">#foo</a></span> bar]</span>34</blockquote></div>'
        ],
        [
          '    >   12[ https://example.com #foo bar]34',
          '<div class="relative pl-[8rem]"><blockquote class="border-l-4 border-gray-300 bg-gray-100 px-4 text-gray-800">   12<span>[ <span><a href="https://example.com">https://example.com</a></span> <span><a href="foo.html">#foo</a></span> bar]</span>34</blockquote></div>'
        ]
      ]
    end

    with_them do
      it 'is rendered' do
        expect(renderer.render).to eq rendered
      end
    end
  end
end
