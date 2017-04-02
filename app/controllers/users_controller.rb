require 'net/http'

class UsersController < ApplicationController
  before_filter :assign_user, only: [:edit, :update, :destroy, :invite]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge!(User::DEFAULT_VALUES))
    params = add_user_to_company(@user)
    response = Spriv::User.new.add_user_to_company(params)
    if response['Info'].present?
      @user.reference_id = response['Info']
      if @user.save
        flash[:success] = "User added successfully"
        redirect_to users_path
      else
        flash[:error] = @user.errors.full_messages
        render :new
      end
    else
      flash[:error] = "Unable to create user successfully."
      render :new
    end
  end

  def edit
  end

  def update
    response = Spriv::User.new.update_company_end_user(update_company_end_user)
    if response["Result"] == "Success"
      if @user.update_attributes(user_params)
        flash[:success] = "User updated successfully"
        redirect_to users_path
      else
        flash[:error] = @user.errors.full_messages
        render :edit
      end
    else
      flash[:error] = "Unable to update user successfully."
      render :edit
    end
  end

  def show
  end

  def destroy
    response = Spriv::User.new.delete_end_user_from_company(delete_end_user_from_company)
    if response["Result"] == "Success"
      if @user.destroy
        flash[:success] = "User Removed successfully"
      else
        flash[:error] = "Unable to Remove user"
      end
    else
      flash[:error] = "Unable to remove user from Spriv. Please try again after some time."
    end
    redirect_to users_path
  end

  def invite
    response = Spriv::User.new.send_invitation(send_invitation)
    if response["Result"] == 'Success'
      flash[:success] = 'User invited successfully.'
    else
      flash[:error] = "Unable to invite new user. Please try again."
    end
    redirect_to users_path
  end

  private

  def add_user_to_company(user)
    {
        "strUsername" => ENV['SPRIV_USERNAME'],
        "strPassword" => ENV['SPRIV_PASSWORD'],
        "strAccount" => user.user_login,
        "nClientID" => user.company_id,
        "strFirstName" => user.first_name,
        "strLastName" => user.last_name,
        "strEmail" => user.email,
        "strMobilePhone" => user.phone,
        "bAsHTML" => user.as_html,
        "strPersonID" => user.person_id,
        "nStatusID" => user.status_id,
        "nStatusTimeout" => user.status_timeout
      }

  end

  def update_company_end_user
    {
        "strUsername" => ENV['SPRIV_USERNAME'],
        "strPassword" => ENV['SPRIV_PASSWORD'],
        "lID" => @user.reference_id,
        "strAccount" => user_params[:user_login],
        "nClientID" => user_params[:company_id],
        "strFirstName" => user_params[:first_name],
        "strLastName" => user_params[:last_name],
        "strEmail" => user_params[:email],
        "strMobilePhone" => user_params[:phone],
        "bAsHTML" => user_params[:as_html],
        "strPersonID" => user_params[:person_id],
        "nStatusID" => @user.status_id,
        "nStatusTimeout" => @user.status_timeout,
        "bPaired" => true,
        "bLockedOut" => false
      }

  end

  def delete_end_user_from_company
    {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "lID" => @user.reference_id
    }
  end

  def send_invitation
    {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "strEndUsers" => @user.reference_id
    }

  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_login,
      :company_id, :email, :phone, :person_id, :as_html
    )
  end

  def assign_user
    @user = User.find(params[:id])
  end
end
