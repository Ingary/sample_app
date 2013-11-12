require 'spec_helper'

describe "Static pages" do

#let(:base_title) {"Ruby on Rails Tutorial Sample App" }
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end


  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_content ('| Home')} 

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should show the total microposts" do
        expect(page).to have_content("micropost".pluralize(user.microposts.count))                  
      end

      describe "micropost pagination" do
        after(:all) { user.microposts.delete_all unless user.microposts.nil? }

        before do
          90.times { FactoryGirl.create(:micropost, user: user) }
          visit root_path
        end

        it "should paginate the feed" do
          page.should have_selector('div.pagination')
        end

        it "should list each user" do
            user.microposts.paginate(page: 1).each do |micropost|
               page.should have_selector("li", text: micropost.content)
            end
        end
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
          # (Note that the first # in li##{item.id} is Capybara syntax for a CSS id, whereas 
          #the second # is the beginning of a Ruby string interpolation #{}.)
        end
      end
    end

  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' } #have_content
    let(:page_title) { 'About Us' } #have_title
    
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' } 
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Sign up"))
    click_link "sample app"
  end
end