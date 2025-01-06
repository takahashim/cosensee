# frozen_string_literal: true

RSpec.describe Cosensee::TailwindRenderer::IconBracket do
  describe '#render' do
    let(:project_json) { fixture_file('project.json') }
    let(:project) { Cosensee::Project.parse_file(project_json) }

    it 'convert IconBracket to HTML' do
      content = Cosensee::Node::IconBracket.new(content: ['Scrapbox.icon'], icon_name: 'Scrapbox', raw: '[Scrapbox.icon]')
      expect(Cosensee::TailwindRenderer::IconBracket.new(content:, project:).render).to eq %(<img src="https://gyazo.com/5f93e65a3b979ae5333aca4f32600611" alt="icon" class="inline-block h-5 w-5 align-middle">)
    end
  end
end
