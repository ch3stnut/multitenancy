require "spec_helper"

feature "User sign in" do
  extend SubdomainHelpers
  
  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:sign_in_url) { "http://#{account.subdomain}.example.com/sign_in" }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  within_account_subdomain do
    scenario "signs in as an account owner successfully" do
      visit root_url
      page.current_url.should == sign_in_url

      fill_in "Email", with: account.owner.email
      fill_in "Password", with: "rickroll"

      click_button "Sign in"

      page.should have_content("You are now signed in.")
      page.current_url.should == root_url
    end
  end

  scenario "attempts signin with an invalid password" do
    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")
    
    fill_in "Email", with: account.owner.email
    fill_in "Password", with: "jackroll"

    click_button "Sign in"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end
  scenario "attempts signin with an invalid email" do
    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")
    
    fill_in "Email", with: "not_the_right_guy@example.com"
    fill_in "Password", with: "rickroll"

    click_button "Sign in"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end

  scenario "signin in while not part of a subdomain" do
    other_account = FactoryGirl.create(:account)
    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")

    fill_in "Email", with: other_account.owner.email
    fill_in "Password", with: "rickroll"
    
    click_button "Sign in"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end

end