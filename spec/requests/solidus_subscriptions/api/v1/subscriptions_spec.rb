require "rails_helper"

RSpec.describe "Subscription endpoints", type: :request do
  let(:json_resp) { JSON.parse(response.body) }
  let(:user) { create :user }
  before { user.generate_spree_api_key! }

  describe "#cancel" do
    let(:subscription) do
      create :subscription, actionable_date: (Date.current + 1.month), user: user
    end

    it "returns the canceled record", :aggregate_failures do
      post solidus_subscriptions.cancel_api_v1_subscription_path(subscription), token: user.spree_api_key
      expect(json_resp["state"]).to eq "canceled"
      expect(json_resp["actionable_date"]).to be_nil
    end
  end

  describe "#skip" do
    let(:subscription) { create :subscription, :with_line_item, actionable_date: 1.day.from_now, user: user }
    before { Timecop.freeze(Date.parse("2016-09-26")) }
    after  { Timecop.return }

    let(:expected_date) { "2016-10-27" }

    it "returns the updated record", :aggregate_failures do
      post solidus_subscriptions.skip_api_v1_subscription_path(subscription), token: user.spree_api_key
      expect(json_resp["actionable_date"]).to eq expected_date
    end
  end
end
