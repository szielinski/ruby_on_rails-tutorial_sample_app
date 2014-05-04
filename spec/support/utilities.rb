include ApplicationHelper

def enter_new_user_data
	enter_valid_name
	enter_valid_email
	enter_valid_password
	enter_valid_password_confirmation
end

def enter_valid_name
	fill_in "Name",	with: "Example User"
end

def enter_valid_email
	fill_in "Email", with: "user@example.com"
end

def enter_valid_password
	fill_in "Password", with: "foobar"
end

def enter_valid_password_confirmation
	fill_in "Confirmation", with: "foobar"
end




def new_valid_user
	enter_new_user_data
	click_button "Create new account"
end

def valid_signin(user)
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector("div.alert.alert-error", text:message)
	end
end