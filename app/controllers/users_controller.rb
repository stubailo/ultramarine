class UsersController < ApplicationController
  skip_authorization_check

  def show
    @user = User.find(params[:id])
    @is_me = @user == current_user
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end
  
  def edit_password
    @user = current_user
  end
  
  def update
    @user = current_user
    
    respond_to do |format|
      if params[:old_password]
        if @user.valid_password?(params[:old_password]) && @user.update_attributes(params[:user])
          format.html { redirect_to(user_path(@user), :notice => 'Credentials updated successfully.') }
          format.json { render :json => {}, :status => :ok }
        else
          flash[:fail] = "Old password entered incorrectly, please try again"
          format.html  { render :action => "edit_password" }
          format.json  { render :json => @user.errors, :status => :unprocessable_entity }
        end
      else
        if @user.update_attributes(params[:user])
          format.html { redirect_to(user_path(@user), :notice => 'Credentials updated successfully.') }
          format.json { render :json => {}, :status => :ok }
        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

end
