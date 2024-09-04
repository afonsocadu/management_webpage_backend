module ControllerMacros
  def login_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      auth_headers = @user.create_new_auth_token
      @request.headers.merge!(auth_headers)
    end
  end
end
