module Users::RegistrationsHelper

  def setup_account(user)
    user.tap do |a|
      a.accounts.build if a.accounts.empty?
    end
  end
end