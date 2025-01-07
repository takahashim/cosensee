# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Cosensee::User' do
    id { SecureRandom.uuid }
    name { 'sample_user' }
    display_name { 'Sample User' }
    email { 'sample_user@example.com' }

    initialize_with do
      new(id:, name:, email:, display_name:)
    end
  end
end
