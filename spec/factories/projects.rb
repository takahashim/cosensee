# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: 'Cosensee::Project' do
    name { 'sample_project' }
    display_name { 'Sample Project' }
    exported { Time.now.to_i }
    users { [build(:user)] }
    pages { build_list(:page, 3) }
    source { { name:, displayName: display_name, exported:, users:, pages: pages.map(&:to_obj) }.to_json }
    renderer_class { Cosensee::TailwindRenderer }

    initialize_with do
      new(name:, display_name:, exported:, users:, pages:, source:, renderer_class:)
    end
  end
end
