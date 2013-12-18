require "spec_helper"

feature "Accounts" do
  scenario "creating an account" do
    visit subscribem.root_path
    click_link "Sign up"
    
    fill_in 'Name', with: "Rick Astley"
    fill_in 'Subdomain', with: "rickroll"
    fill_in 'Email', with: "subscribem@example.com"
    fill_in 'Password', with: "rickroll", exact: true
    fill_in 'Confirm password', with: "rickroll"

    click_button 'Create Account'

    success_message = 'Your account has been created.'
    page.should have_content(success_message)
    page.should have_content("Signed in as subscribem@example.com")

    page.current_url.should == "http://rickroll.example.com/"
  end

  scenario "ensure subdomain uniqueness" do
    Subscribem::Account.create!(subdomain: "rickroll", name: "Rick Astley")
    visit subscribem.root_path
    click_link "Sign up"

    fill_in 'Name', with: "Rick Astley"
    fill_in 'Subdomain', with: "rickroll"
    fill_in 'Email', with: "subscribem@example.com"
    fill_in 'Password', with: "rickroll", exact: true
    fill_in 'Confirm password', with: "rickroll"

    click_button 'Create Account'

    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain has already been taken")
  end

  scenario "Subdomain with restricted name" do
    visit subscribem.root_path
    click_link "Sign up"

    fill_in 'Name', with: "Rick Astley"
    fill_in 'Subdomain', with: "Admin"
    fill_in 'Email', with: "subscribem@example.com"
    fill_in 'Password', with: "rickroll", exact: true
    fill_in 'Confirm password', with: "rickroll"

    click_button 'Create Account'

    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain is not allowed. Please choose another subdomain.")
  end

  scenario "Subdomain with funky name" do
    visit subscribem.root_path
    click_link "Sign up"
    
    fill_in 'Name', with: "Rick Astley"
    fill_in 'Subdomain', with: "<rickroll>"
    fill_in 'Email', with: "subscribem@example.com"
    fill_in 'Password', with: "rickroll", exact: true
    fill_in 'Confirm password', with: "rickroll"

    click_button 'Create Account'

    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain is not allowed. Please choose another subdomain.")
  end
end