# frozen_string_literal: true

require "spec_helper"

module Decidim::Proposals
  describe CostReportCell, type: :cell do
    controller Decidim::Proposals::ProposalsController

    subject { cell("decidim/proposals/cost_report", model).call }

    let(:model) do
      create(
        :proposal,
        cost_report: { en: '<p>Cost report</p><img src="/uploads/decidim/cost_report.jpg" alt="Cost report image">' },
        execution_period: { en: '<p>Execution period</p><img src="/uploads/decidim/execution_period.jpg" alt="Execution period image">' }
      )
    end

    it "renders the images entered by the administrators in the cost report" do
      expect(subject).to have_css("img[alt='Cost report image']")
    end

    it "renders the images entered by the administrators in the execution period" do
      expect(subject).to have_css("img[alt='Execution period image']")
    end
  end
end
