When /^I have a valid github account with email "(.*)" username "(.*)"/ do |email, username|
	OmniAuth.config.add_mock(:github, {
	    :uid => '12345',
	    :extra => {
	      :raw_info => {
	      	:email => email,
	      	:login => username
	      }
	    }
	  })
end

When /^I do not have a valid github account/ do
	OmniAuth.config.mock_auth[:github] = :invalid_credentials
end
		