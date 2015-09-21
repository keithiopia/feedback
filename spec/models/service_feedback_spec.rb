require 'spec_helper'
require 'gds_api/test_helpers/support_api'

describe ServiceFeedback do
  include ValidatorHelper
  include GdsApi::TestHelpers::SupportApi

  context "valid service feedback" do
    let(:subject) { ServiceFeedback.new(options) }
    let(:options) { { service_satisfaction_rating: "5", improvement_comments: "Could it be any more black", url: "/done/abc" } }
    it { should be_valid }

    it "should raise an exception if the support-api isn't available" do
      support_api_isnt_available
      lambda { subject.save }.should raise_error(GdsApi::BaseError)
    end

    its(:options) { should include(service_satisfaction_rating: 5) }
    its(:options) { should include(path: "/done/abc") }
  end

  it { should_not allow_value(nil).for(:service_satisfaction_rating) }
  it { should allow_value(nil).for(:improvement_comments) }
  it { should validate_inclusion_of(:service_satisfaction_rating).in_array(('1'..'5').to_a) }

  it { should validate_length_of(:improvement_comments).is_at_most(Ticket::FIELD_MAXIMUM_CHARACTER_COUNT).with_long_message(/can be max 1250 characters/) }
  it { should validate_length_of(:slug).is_at_most(512) }

  context "with empty comments" do
    let(:subject) { ServiceFeedback.new(improvement_comments: "") }
    its(:options) { should include(details: nil) }
  end

  context "with an invalid URL" do
    let(:subject) { ServiceFeedback.new(url: "```") }
    its(:options) { should include(path: nil) }
  end
end
