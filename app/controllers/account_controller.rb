class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end
=begin
  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end
=end

  def login
 
    return unless request.post?
    if using_open_id?
      open_id_authentication(params[:openid_url])
    elsif params[:login]
      password_authentication(params[:login], params[:password])
    end
  end
  def password_authentication(login, password)
        if self.current_user = User.authenticate(params[:login], params[:password])
          print "\n--->successful_login with #{self.current_user.login}\n"
          successful_login
        else
          failed_login("Invalid login or password")
        end
      end
      
      def open_id_authentication(openid_url)
        print "\n--->openid_url:  #{openid_url}; #{params['openid.identity']}\n"
            authenticate_with_open_id openid_url, :required => [:nickname, :email] do |result, identity_url, registration|     
              print "\n--->openid_url2:  #{openid_url}\n"
              if result.successful?
                @user = self.current_user = User.find_or_create_by_identity_url(identity_url)
                if !registration['login'] && !self.current_user['login'] && params['openid.identity']
                   print "\n--->openid_url1:  #{openid_url}\n"
                      self.current_user['login']= params['openid.identity']
                      self.current_user.save
                end
                if @user.new_record?
                  print "\n------->new record\n"
                  # registration is a hash containing the valid sreg keys given above
                  # use this to map them to fields of your user model
                  {'login=' => 'nickname', 'email=' => 'email'}.each do |attr, reg|
                    current_user.send(attr, registration[reg]) unless registration[reg].blank?
                  end
 
                  if @user.valid?
                    @user.save
                    self.current_user = @user
                    print "\n--->successful_login with #{self.current_user.login}\n"
                    successful_login
                  else
                    failed_login "Authentication failed on this website."
                  end
                else
                  self.current_user = @user
                  successful_login
                end

              else
                failed_login result.message
              end
            end
              print "\n--->openid_url3:  #{openid_url}\n"
          end

      
  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    #redirect_back_or_default(:controller => '/account', :action => 'index')
    redirect_back_or_default(:controller => '/mr', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
  
  private
      def successful_login
        
        session[:user_id] = @current_user.id
        #redirect_back_or_default({:action => :show})
        redirect_back_or_default(:controller => '/mr', :action => 'index')
        flash[:notice] = "Logged in successfully"
      end

      def failed_login(message)
        redirect_to(:action => 'login')
        flash[:warning] = message
      end
end
