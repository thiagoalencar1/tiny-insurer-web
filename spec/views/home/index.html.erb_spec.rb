require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :system do
  describe "User visit app" do
    it "and see initial page" do
      visit root_path
      expect(page).to have_content("Tiny Insurer App")
    end
  end
end
