require "spec_helper"

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  scenario "under an account" do
    visit root_url
    page.current_url.should == root_url + "sign_in"

    click_link "New User?"
    fill_in "Email", with: "rick@example.com"
    fill_in "Password", with: "rickroll"
    fill_in "Confirm password", with: "rickroll"

    click_button "Sign up"

    page.should have_content("You have signed up successfully.")
    page.current_url.should == root_url
  end
end