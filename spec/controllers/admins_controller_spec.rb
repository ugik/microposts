require 'spec_helper'

describe AdminsController do

  render_views

#----------------------------------------------
  describe "GET 'index/show'" do

    describe "for non-signed-in admins" do

      before(:each) do
        @admin = Factory(:admin)
      end

      it "should deny access" do
        get :index
        response.should redirect_to(root_path)
        #flash[:notice].should =~ /sign in/i
      end
      
      it "should not show admin" do
        get :show, :id => @admin
        response.should redirect_to(signin_path)
      end
    end
  end

#----------------------------------------------
  describe "GET 'new'" do

    it "should not be successful without administrator" do
      get 'new'
      response.should_not be_success
    end
  end

#----------------------------------------------  
  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a admin" do
        lambda do
          post :create, :admin => @attr
        end.should_not change(Admin, :count)
      end

      it "should have the right title" do
        post :create, :admin => @attr
        response.should have_selector("title", :content => "Create Admin")
      end

      it "should render the 'new' page" do
        post :create, :admin => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do

      before(:each) do
        @attr = { :name => "New Admin", :email => "admin@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a admin" do
        lambda do
          post :create, :admin => @attr
        end.should change(Admin, :count).by(1)
      end

      it "should redirect to the admin show page" do
        post :create, :admin => @attr
        response.should redirect_to(admin_path(assigns(:admin)))
      end    
      
      it "should have a welcome message" do
        post :create, :admin => @attr
        flash[:success].should =~ /admin created/i
      end

      it "should sign the admin in" do
        post :create, :admin => @attr
        controller.should be_signed_in
      end
    end   
  end

#----------------------------------------------
  describe "GET 'show' for signed-in admins" do

    before(:each) do
      @admin = Factory(:admin)
      test_sign_in(@admin)
    end

    it "should show admin" do
      get :show, :id => @admin
      response.should be_success
    end

    it "should find the right admin" do
      get :show, :id => @admin
      assigns(:admin).should == @admin
    end
   
    it "should have the right title" do
      get :show, :id => @admin
      response.should have_selector("title", :content => @admin.name)
    end

    it "should include the admin's name" do
      get :show, :id => @admin
      response.should have_selector("h4", :content => @admin.name)
    end

  end

#----------------------------------------------  
  describe "GET 'edit' for signed-in admins" do

    before(:each) do
      @admin = Factory(:admin)
      test_sign_in(@admin)
    end

    it "should be successful" do
      get :edit, :id => @admin
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @admin
      response.should have_selector("title", :content => "Edit admin")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @admin
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end

#----------------------------------------------
  describe "PUT 'update'" do

    before(:each) do
      @admin = Factory(:admin)
      test_sign_in(@admin)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @admin, :admin => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @admin, :admin => @attr
        response.should have_selector("title", :content => "Edit admin")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "admin@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the admin's attributes" do
        put :update, :id => @admin, :admin => @attr
        @admin.reload
        @admin.name.should  == @attr[:name]
        @admin.email.should == @attr[:email]
      end

      it "should redirect to the admin show page" do
        put :update, :id => @admin, :admin => @attr
        response.should redirect_to(admin_path(@admin))
      end

      it "should have a flash message" do
        put :update, :id => @admin, :admin => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

#----------------------------------------------
  describe "authentication of show/edit/update pages" do

    before(:each) do
      @admin = Factory(:admin)
    end

    describe "for non-signed-in admins" do

      it "should deny access to 'show'" do
        get :show, :id => @admin
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'edit'" do
        get :edit, :id => @admin
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @admin, :admin => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in admins" do

      before(:each) do
        wrong_admin = Factory(:admin, :email => "admin@example.net")
        test_sign_in(wrong_admin)
      end

      it "should require matching admins for 'show'" do
        get :show, :id => @admin
        response.should redirect_to(root_path)
      end

      it "should require matching admins for 'edit'" do
        get :edit, :id => @admin
        response.should redirect_to(root_path)
      end

      it "should require matching admins for 'update'" do
        put :update, :id => @admin, :admin => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
#----------------------------------------------
  describe "Administrator admin" do

    before(:each) do
      @admin = Factory(:admin)
    end

    describe "delete as a non-signed-in admin" do
      it "should deny access" do
        delete :destroy, :id => @admin
        response.should redirect_to(root_path)
      end
    end

    describe "delete as a non-administrator admin" do
      it "should protect the page" do
        test_sign_in(@admin)
        delete :destroy, :id => @admin
        response.should redirect_to(root_path)
      end
    end

    describe "should be able to destroy" do
      before(:each) do
        administrator = Factory(:admin, :email => "administrator@example.com", :administrator => true)
        test_sign_in(administrator)
      end

      it "should destroy the admin" do
        lambda do
          delete :destroy, :id => @admin
        end.should change(Admin, :count).by(-1)
      end

      it "should redirect to the admins page" do
        delete :destroy, :id => @admin
        response.should redirect_to(admins_path)
      end
    end

    describe "should be able to see other admins" do
      before(:each) do
        administrator = Factory(:admin, :email => "administrator@example.com", :administrator => true)
        test_sign_in(administrator)
        another = Factory(:admin, :name => "Bob", :email => "another@example.org")
      end

      it "should be successful" do
        get :show, :id => 2
        response.should be_success     
      end      
        
      it "should be successful" do
        get :edit, :id => 2
        response.should be_success     
      end      

      it "NEW should have the right title" do
        get 'new'
        response.should have_selector("title", :content => "Create Admin")
      end
    
      describe "should be able to see index" do
        before(:each) do
          second = Factory(:admin, :name => "Bob", :email => "another@example.com")
          third  = Factory(:admin, :name => "Ben", :email => "another@example.net")

          @admins = [@admin, second, third]
          30.times do
            @admins << Factory(:admin, :email => Factory.next(:email))
          end
        end

        it "should be successful" do
          get :index
          response.should be_success
        end

        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "All admins")
        end

        it "should have an element for each admin" do
          get :index
          @admins.each do |admin|
            response.should have_selector("li", :content => admin.name)
          end
        end

        it "should have an element for each admin" do
          get :index
          @admins[0..2].each do |admin|
            response.should have_selector("li", :content => admin.name)
          end
        end

        it "should paginate admins" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          #response.should have_selector("a", :href => "/admins?escape=false&amp;page=2", :content => "2")
          #response.should have_selector("a", :href => "/admins?page=2", :content => "Next")
        end
      end
    end
  end
end
