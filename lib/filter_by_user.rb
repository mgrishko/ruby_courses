#XXX
#This is very useful but not well tested and is a source of bugs
#
module FilterByUser
  @@user = nil

  def self.included(base)
    base.extend(FilterByUser)
  end

  def set_auth_user(user)
    @@user = user
  end

  def find(*args)
    if !@@user.nil? && !@@user.new_record? && !@@user.is_admin
      if args.size > 1 
        if args[1].is_a?(Hash) && args[1][:conditions]
          conditions = merge_conditions(args[1][:conditions], :user_id => @@user.id)
        else
          debugger
          conditions = {:user_id => @@user.id}
        end
        args[1][:conditions] = conditions
      else
        args.push(:conditions => {:user_id => @@user.id})
      end
    end

    super *args
  end

  def before_create
    self.user_id = @@user.id
  end

  def before_validation
    self.user_id = @@user.id
  end
end
