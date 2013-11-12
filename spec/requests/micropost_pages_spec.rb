require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    it { should have_button('Post') }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    let(:other_user) { FactoryGirl.create(:user) }

    describe "as correct user" do
      before { visit root_path }

      it { should have_link('delete') }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "user can't delete other micropost" do
      before {visit user_path(other_user)}

      it { should_not have_link('delete') }
    end
  end

end