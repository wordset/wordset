class ApplicationMailer < ActionMailer::Base
  default from: "contact@wordset.org"
  layout 'mailer'
  helper LinkHelper
end
