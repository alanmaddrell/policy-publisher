require "rails_helper"

RSpec.describe Policy do
  it "automatically generates a slug on creation" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    policy.name = "Immigration"
    policy.save!

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy = FactoryGirl.build(:policy, name: '')
    nil_policy = FactoryGirl.build(:policy, name: nil)

    expect(blank_policy).not_to be_valid
    expect(nil_policy).not_to be_valid
  end

  it "enforces unique names" do
    FactoryGirl.create(:policy, name: "Climate change")
    duplicate_policy = FactoryGirl.build(:policy, name: "Climate change")

    expect(duplicate_policy).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = FactoryGirl.create(:policy, name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = FactoryGirl.build(:policy, name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end

  it "can have a bi-directional relationship with other policies" do
    related_policy = FactoryGirl.create(:policy)
    policy = FactoryGirl.create(:policy, related_policies: [related_policy])

    expect([related_policy]).to eq(policy.related_policies)
    expect([policy]).to eq(related_policy.reload.parent_policies)
  end

  it "is a programme if it has a parent policy" do
    parent_policy = FactoryGirl.create(:policy)
    policy = FactoryGirl.create(:policy)

    expect(policy.programme?).to be(false)

    policy.parent_policies << parent_policy
    expect(policy.programme?).to be(true)
  end

  it "has a setter that can identify a new Policy as a programme" do
    policy = Policy.new(programme: true)

    expect(policy.programme?).to be(true)
  end

  it "cannot be associated with itself" do
    policy = FactoryGirl.create(:policy)

    expect { policy.related_policies = [policy] }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "gets a list of applicable nations" do
    policy = FactoryGirl.create(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "https://www.nidirect.gov.uk",
      scotland: false,
      scotland_policy_url: "http://www.gov.scot/",
      wales: false,
      wales_policy_url: "http://gov.wales/",
    )

    expect(policy.applicable_nations).to eq([:england])
  end

  it "doesn't allow invalid alternative policy URLs" do
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "bad-url",
    )

    expect(policy).not_to be_valid
    expect(policy.errors.messages).to eq({:northern_ireland=>["must have a valid alternative policy URL"]})
  end

  it "allows valid alternative policy URLs" do
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "http://example.ni",
    )

    expect(policy).to be_valid
  end

  it "allows specifying no alternative policy URL" do
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
    )

    expect(policy).to be_valid
  end
end