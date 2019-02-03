require "rails_helper"

RSpec.describe "Contributor search", :type => :system do
  describe 'working search form' do
    def fill_fields
      fill_in 'repo', with: "https://github.com/ruby/ruby"
      click_button 'Search'

      expect(page).to have_text("Results")
      expect(page).to have_text("nobu")
      expect(page).to have_text("akr")
      expect(page).to have_text("matzbot")
    end

    it 'is working in index' do
      visit "/"
      fill_fields
    end

    it 'is working in /search' do
      visit "/search?repo=invalid"
      expect(page).to have_text("Repository not found")
      fill_fields
    end
  end
end