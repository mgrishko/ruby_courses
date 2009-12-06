module MigrationHelpers
  def get_user
    User.find_or_create_by_gln(
      :gln => 123,
      :pw_hash => '21232f297a57a5a743894a0e4a801fc3',
      :is_admin => true
    )
  end
end
