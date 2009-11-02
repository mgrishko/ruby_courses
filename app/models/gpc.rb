class Gpc < ActiveRecord::Base
  def self.find_complete_values(word)
    # XXX
    # Need to finish this for using masks (*)
    # this must work in mysql, but does not work under sqlite3
    #word.gsub('%', '%%').gsub(/[^\\]\*/, '%').gsub('\\*', '*')
    self.find(:all, {
      :conditions => ['LOWER(name) LIKE ?', word + '%'],
      :order => "name ASC",
      :limit => 10
    })
  end
end
