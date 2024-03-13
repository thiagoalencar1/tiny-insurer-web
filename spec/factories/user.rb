# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email    { 'jhondoe@email.com' }
    password { 'password' }
  end
end
