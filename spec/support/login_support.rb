module LoginSupport
  def sign_up_as(user)
    visit root_path
    click_link "SignUp"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password_confirmation
    click_button "SignUp"
  end

  def login_as(user)
    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
