Dir[File.expand_path(File.join(Rails.root.to_s,'lib','*.rb'))].each {|f| require f}

