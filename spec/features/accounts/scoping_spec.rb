require "spec_helper"

feature "Account scoping" do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    Thing.create(name: "Account A's thing", account: account_a)
    Thing.create(name: "Account B's thing", account: account_b)
  end

  scenario "displays only account A's records" do
    sign_in_as(user: account_a.owner, account: account_a)
    visit '/things'
    expect(page).to have_content("Account A's thing")
    expect(page).not_to have_content("Account B's thing")
  end

  scenario "displays only account B's records" do
    sign_in_as(user: account_b.owner, account: account_b)
    visit '/things'
    expect(page).to have_content("Account B's thing")
    expect(page).not_to have_content("Account A's thing")
  end
end