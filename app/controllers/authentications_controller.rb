require 'net/http'

class AuthenticationsController < ApplicationController
  def login
  end

  def add_login
    @user = User.find_by_user_login(authentication_params[:user_login])
    uri = URI('https://m.spriv.com/wsM5.asmx/AddLogin')
    params = {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "strEndUsername" => @user.user_login,
      "strPCFingerprint" => request.user_agent,
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false
    }
    res = Net::HTTP.post_form(uri, params)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    redirect_to login_path
    #  {"Code"=>200, "Message"=>"OK", "ID"=>"65a0b79d0fa24519a9355ef7c9380e62", "PollServiceURL"=>"https://sprivservices.azurewebsites.net"}
  end

  def add_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
    uri = URI('https://m.spriv.com/wsM5.asmx/AddVerification')
    params = {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "strEndUsername" => @user.user_login,
      "strPCFingerprint" => request.user_agent,
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false,
      "strMessage" => 'Hello There Naiya'
    }
    res = Net::HTTP.post_form(uri, params)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    redirect_to login_path
  end

  def add_two_way_sms_verification
    @user = User.find_by_user_login(authentication_params[:user_login])
    uri = URI('https://m.spriv.com/wsM5.asmx/AddVerification')
    params = {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "strEndUsername" => @user.user_login,
      "strPCFingerprint" => request.user_agent,
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false,
      "strMessage" => 'Hello There Naiya'
    }
    res = Net::HTTP.post_form(uri, params)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    redirect_to login_path
  end

  def add_totp
    @user = User.find_by_user_login(authentication_params[:user_login])
    uri = URI('https://m.spriv.com/wsM5.asmx/AddTotp')
    params = {
      "strUsername" => ENV['SPRIV_USERNAME'],
      "strPassword" => ENV['SPRIV_PASSWORD'],
      "strEndUsername" => @user.user_login,
      "strKey" => authentication_params[:key],
      "strIPAddress" => request.ip,
      "strService" => "Web Access",
      "nMethod" => 1,
      "bAsHTML" => false
    }
    res = Net::HTTP.post_form(uri, params)
    JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    redirect_to login_path
  end

  private

  def authentication_params
    params.require(:authentication).permit!
  end
end
