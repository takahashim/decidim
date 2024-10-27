# frozen_string_literal: true

require "spec_helper"

describe Decidim::Blogs::FilteredPosts do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:post_component, participatory_space: participatory_process) }
  let(:another_component) { create(:post_component, participatory_space: participatory_process) }

  let(:posts) { create_list(:post, 3, component:) }
  let(:old_posts) { create_list(:post, 3, component:, created_at: 10.days.ago) }
  let(:another_posts) { create_list(:post, 3, component: another_component) }

  it "includes all posts for the given component" do
    expect(described_class.for(component)).to include(*posts)
  end

  it "does not includes posts from another component" do
    expect(described_class.for(component)).not_to include(*another_posts)
  end

  it "returns posts included in a collection of components" do
    expect(described_class.for([component, another_component])).to match_array posts.concat(old_posts, another_posts)
  end

  it "returns posts created in a date range" do
    expect(described_class.for([component, another_component], 2.weeks.ago, 1.week.ago)).to match_array old_posts
  end
end
