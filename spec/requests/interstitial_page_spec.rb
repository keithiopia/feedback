require 'spec_helper'
require 'uri'

describe "Interstitial page" do
  before do
    visit "/contact"
  end

  it "displays popular contact links" do
    within "#popular-links" do
      CONTACT_LINKS.popular.each do |link|
        expect(page).to have_link(link["Title"], href: link["URL"])
      end
    end
  end

  it "displays long-tail contact links" do
    within "#long-tail-links" do
      CONTACT_LINKS.long_tail.each do |link|
        expect(page).to have_link(link["Title"], href: link["URL"])
      end
    end
  end

  let(:all_urls) { (CONTACT_LINKS.long_tail + CONTACT_LINKS.popular).map { |link| URI(link["URL"]) } }
  let(:external_urls) { all_urls.select {|url| url.host && url.host != 'www.gov.uk' } }

  it "highlights external links" do
    external_urls.each do |url|
      expect(page).to have_css("a[href='#{url}'][rel='external']")
    end
  end
end
