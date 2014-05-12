require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

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

      describe "micropost count" do
        before { user.microposts.delete_all }
        it { should have_content("0 microposts")}

        describe "one micropost" do
          before do
            FactoryGirl.create(:micropost, user: user)
            visit root_path
          end
          it { should have_content("1 micropost")}
        end

        describe "multiple microposts" do
          before do
            2.times { FactoryGirl.create(:micropost, user: user) }
            visit root_path
          end
          it { should have_content("2 microposts")}
        end
      end
    end
  end

  describe "pagination" do
    before { 
      user.microposts.delete_all
      31.times { FactoryGirl.create(:micropost, user:user) } 
      visit root_path
    }
    after(:all)  { user.microposts.delete_all }
    
    it { should have_selector('div.pagination') }
  
    #needs extra work to check for contents
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as incorrect user" do
      let(:other_user) { FactoryGirl.create(:user) }

      before {
        FactoryGirl.create(:micropost, user: other_user)
        visit user_path(other_user)
      }
      it { should_not have_link "delete"}
    end
  end  
end