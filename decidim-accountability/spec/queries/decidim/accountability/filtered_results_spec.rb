# frozen_string_literal: true

require "spec_helper"

describe Decidim::Accountability::FilteredResults do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:accountability_component, participatory_space: participatory_process) }
  let(:another_component) { create(:accountability_component, participatory_space: participatory_process) }

  let(:results) { create_list(:result, 3, component:) }
  let(:old_results) { create_list(:result, 3, component:, created_at: 10.days.ago) }
  let(:another_results) { create_list(:result, 3, component: another_component) }

  it "includes all results for the given component" do
    expect(described_class.for(component)).to include(*results)
  end

  it "does not includes results from another component" do
    expect(described_class.for(component)).not_to include(*another_results)
  end

  it "returns results included in a collection of components" do
    expect(described_class.for([component, another_component])).to match_array results.concat(old_results, another_results)
  end

  it "returns results created in a date range" do
    expect(described_class.for([component, another_component], 2.weeks.ago, 1.week.ago)).to match_array old_results
  end
end
