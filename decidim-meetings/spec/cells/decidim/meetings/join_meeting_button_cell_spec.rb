# frozen_string_literal: true

require "spec_helper"

module Decidim::Meetings
  describe JoinMeetingButtonCell, type: :cell do
    controller Decidim::Meetings::MeetingsController

    subject { Capybara.string(cell("decidim/meetings/join_meeting_button", meeting).send(:registration_terms_text).to_s) }

    let(:meeting) do
      create(
        :meeting,
        :published,
        :with_registrations_enabled,
        author_trait,
        registration_form_enabled: false,
        registration_terms: { en: meeting_terms }
      )
    end
    let(:meeting_terms) do
      <<~HTML
        <p>Registration terms</p>
        <img src="/uploads/decidim/registration_terms.jpg" alt="Registration terms image">
        <iframe src="https://example.org/embed"></iframe>
      HTML
    end

    context "when the meeting is official" do
      let(:author_trait) { :official }

      it "renders the media entered by the administrators in the registration terms" do
        expect(subject).to have_css("img[alt='Registration terms image']")
        expect(subject).to have_css("div.disabled-iframe", visible: :all)
      end
    end

    context "when the meeting is created by a participant" do
      let(:author_trait) { :participant_author }

      it "strips the media from the registration terms" do
        expect(subject).to have_text("Registration terms")
        expect(subject).to have_no_css("img")
        expect(subject).to have_no_css("iframe, div.disabled-iframe", visible: :all)
      end
    end
  end
end
