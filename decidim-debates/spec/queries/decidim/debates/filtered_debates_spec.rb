# frozen_string_literal: true

require "spec_helper"

describe Decidim::Debates::FilteredDebates do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:debates_component, participatory_space: participatory_process) }
  let(:another_component) { create(:debates_component, participatory_space: participatory_process) }

  let(:debates) { create_list(:debate, 3, component:) }
  let(:old_debates) { create_list(:debate, 3, component:, created_at: 10.days.ago) }
  let(:another_debates) { create_list(:debate, 3, component: another_component) }

  it "includes all debates for the given component" do
    expect(described_class.for(component)).to include(*debates)
  end

  it "does not includes debates from another component" do
    expect(described_class.for(component)).not_to include(*another_debates)
  end

  it "returns debates included in a collection of components" do
    expect(described_class.for([component, another_component])).to match_array debates.concat(old_debates, another_debates)
  end

  it "returns debates created in a date range" do
    expect(described_class.for([component, another_component], 2.weeks.ago, 1.week.ago)).to match_array old_debates
  end
end
