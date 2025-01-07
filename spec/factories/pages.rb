# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: 'Cosensee::Page' do
    id { SecureRandom.uuid }
    title { 'Sample Page' }
    created { Time.now.to_i }
    updated { Time.now.to_i }
    views { rand(0..100) }
    lines { ['Header line'] + Array.new(3) { "Line #{rand(1..100)}" } }

    initialize_with do
      new(id:, title:, created:, updated:, views:, lines:)
    end
  end
end
