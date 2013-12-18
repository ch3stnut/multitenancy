require "spec_helper"

describe Subscribem::Account do
  it "can be created with an owner" do
    params =
    {
      name: "Rick Astley",
      subdomain: "rickroll",
      owner_attributes:
      {
        email: "rick@example.com",
        password: "rickroll",
        password_confirmation: "rickroll"
      }
    }

    account = Subscribem::Account.create_with_owner(params)
    account.should be_persisted
    account.users.first.should == account.owner
  end

  it "cannot create an account without a subdomain" do
    params =
    {
      name: "Jack Astley",
      owner_attributes:
      {
        email: "jack@example.com",
        password: "jackroll",
        password_confirmation: "jackroll"
      }
    }

    account = Subscribem::Account.create_with_owner(params)
    account.should_not be_valid
    account.users.should be_empty
  end

  def schema_exists?(account)
    query = %Q{SELECT nspname FROM pg_namespace
               WHERE nspname='#{account.subdomain}'}
    result = ActiveRecord::Base.connection.select_value(query)
    result.present?
  end

  it "creates a schema" do
    account = Subscribem::Account.create!\
    ({
      name: "First Account",
      subdomain: "first"
    })
    account.create_schema

    assert schema_exists?(account), "Schema #{account.subdomain} does not exist"
  end
end