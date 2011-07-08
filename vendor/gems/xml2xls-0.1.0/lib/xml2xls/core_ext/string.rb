class String
  def format *args
    str = self.dup
    args.each_with_index do |a, i|
      str.gsub!("{#{i}}", a)
    end
    str
  end
  def format! *args
    args.each_with_index do |a, i|
      self.gsub!("{#{i}}", a)
    end
    self
  end
  def to_bool
    !!(self =~ /^(t|1|(true))$/i)
  end
end