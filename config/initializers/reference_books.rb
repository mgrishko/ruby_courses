REF_BOOKS={}
Dir[File.expand_path(File.join(Rails.root.to_s,'config','reference_books','*.yml'))].each do |f|
  REF_BOOKS[File.basename(f).split('.')[0]] = YAML.load(File.read(f))
end

