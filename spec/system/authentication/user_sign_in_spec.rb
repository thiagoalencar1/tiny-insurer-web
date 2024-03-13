require 'rails_helper'

describe 'User signed in' do
  it 'with success' do
    User.create!(email: 'jhondoe@email.com', password: 'password')

    visit root_path
    click_on('See all policies')
    within('form#new_user') do
      fill_in('Email', with: 'jhondoe@email.com')
      fill_in('Password', with: 'password')
      click_on('Log in')
    end

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Log Out')
  end

  it 'and logout' do
    User.create!(email: 'jhondoe@email.com', password: 'password')

    visit root_path
    click_on('See all policies')
    within('form#new_user') do
      fill_in('Email', with: 'jhondoe@email.com')
      fill_in('Password', with: 'password')
      click_on('Log in')
    end
    click_on('Log Out')

    expect(page).to have_content('Signed out successfully')
  end
end
