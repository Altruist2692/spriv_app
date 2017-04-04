class AuthenticationsController < ApplicationController
  def login
  end

  def add_login
    @user = User.find_by_user_login(authentication_params[:user_login])
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
    redirect_to login_path
  end

  def add_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
    params = {
      "strEndUsername" => @user.user_login,
      "strPCFingerprint" => request.user_agent,
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false,
      "strMessage" => 'Hello There Naiya'
    }
    response = Spriv::Client.new.add_verification(params)
    response = Spriv::Poller.new.get_decision(response['ID'])
    redirect_to login_path
  end

  def add_two_way_sms_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
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
    redirect_to login_path
  end

  def add_totp
    @user = User.find_by_user_login(authentication_params[:user_login])
    params = {
      "strEndUsername" => @user.user_login,
      "strKey" => authentication_params[:key],
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false
    }
    response = Spriv::Client.new.add_totp(params)
    redirect_to login_path
  end

  private

  def authentication_params
    params.require(:authentication).permit!
  end
end
