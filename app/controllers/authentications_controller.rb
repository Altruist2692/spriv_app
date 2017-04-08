class AuthenticationsController < ApplicationController
  def login
  end

  def add_login
    @user = User.find_by_user_login(authentication_params[:user_login])
    if @user.present?
      params = {
        "strEndUsername" => @user.user_login,
        "strPCFingerprint" => request.user_agent,
        "strIPAddress" => request.ip,
        "strService" => "Web Access",
        "nMethod" => 1,
        "bAsHTML" => false
      }
      response = Spriv::Client.new.add_login(params)
      response = Spriv::Poller.new.get_decision(response['ID'])
      set_flash(response)
    else
      flash[:danger] = 'Unable to find user with this login'
    end
    redirect_to login_path

  end

  def add_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
    if @user.present?
      params = {
        "strEndUsername" => @user.user_login,
        "strPCFingerprint" => request.user_agent,
        "strIPAddress" => request.ip,
        "strService" => "Web Access",
        "nMethod" => 1,
        "bAsHTML" => false,
        "strMessage" => 'Hello There Dev'
      }
      response = Spriv::Client.new.add_verification(params)
      response = Spriv::Poller.new.get_decision(response['ID'])
      set_flash(response)
    else
      flash[:danger] = 'Unable to find user with this login'
    end
    redirect_to login_path
  end

  def add_two_way_sms_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
    if @user.present?
      params = {
        "strEndUsername" => @user.user_login,
        "strPCFingerprint" => request.user_agent,
        "strIPAddress" => request.ip,
        "strService" => "Web Access",
        "nMethod" => 2,
        "bAsHTML" => false,
        "strMessage" => 'Hello There Naiya!!'
      }
      response = Spriv::Client.new.add_verification(params)
      response = Spriv::Poller.new.get_decision(response['ID'])
      set_flash(response)
    else
      flash[:danger] = 'Unable to find user with this login'
    end
    redirect_to login_path
  end

  def add_totp
    @user = User.find_by_user_login(authentication_params[:user_login])
    if @user.present?
      params = {
        "strEndUsername" => @user.user_login,
        "strKey" => authentication_params[:key],
        "strIPAddress" => request.ip,
        "strService" => "Web Access",
        "nMethod" => 1,
        "bAsHTML" => false
      }
      response = Spriv::Client.new.add_totp(params)
      set_flash(response)
    else
      flash[:danger] = 'Unable to find user with this login'
    end
    redirect_to login_path
  end

  private

  def authentication_params
    params.require(:authentication).permit!
  end

  def set_flash(response)
    if response['Decision'] == 1
      flash[:success] = "Authentication Done successfully"
    elsif response['Decision'] == 3
      flash[:danger] = "Authentication Denied."
    elsif response['Message'] == 'OK'
      flash[:success] = "Authentication Done successfully"
    elsif response['Message'].match(/Wrong TOTP/)
      flash[:danger] = "Wrong TOTP code, please try again"
    else
      flash[:danger] = "Unable to Get response from Azure"
    end
  end
end
