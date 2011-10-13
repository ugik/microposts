class AdminsController < ApplicationController
  before_filter :authenticate, :only => [:show, :edit, :update]
  before_filter :correct_admin, :only => [:show, :edit, :update]
  before_filter :administrator_admin,   :only => [:index, :new, :destroy]

  def show
    @admin = Admin.find(params[:id])
    @title = @admin.name
  end

  def edit
    @title = "Edit admin"
  end

  def new
    @admin = Admin.new
    @title = "Create Admin"
  end

  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      sign_in @admin
      flash[:success] = "New admin created"
      redirect_to @admin
    else
      @title = "Create Admin"
      render 'new'
    end
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      flash[:success] = "Profile updated."
      redirect_to @admin
    else
      @title = "Edit admin"
      render 'edit'
    end
  end
  
  def edit
    @admin = Admin.find(params[:id])
    @title = "Edit admin"
  end

  def index
    @title = "All admins"
    @admins = Admin.paginate(:page => params[:page])
  end

  def show
    @admin = Admin.find(params[:id])
    @title = @admin.name
  end

  def destroy
    Admin.find(params[:id]).destroy
    flash[:success] = "Admin destroyed."
    redirect_to admins_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_admin  # either correct admin or administrator
      @admin = Admin.find(params[:id])
      redirect_to(root_path) unless current_admin?(@admin) or (current_admin != nil and current_admin.administrator?)
    end

    def administrator_admin
      redirect_to(root_path) unless (current_admin != nil and current_admin.administrator?)
    end

end