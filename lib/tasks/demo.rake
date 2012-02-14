# encoding: utf-8
require 'csv'
require 'find'

namespace :gm do
  namespace :demo do
    desc "Load demo products. All current products will be destroyed!"
    task :data, [:subdomain] => :environment do |task, args|
      if args[:subdomain].blank?
        raise "Please, specify account by subdomain: rake gm:demo:data[subdomain]"
      end

      demo_root = File.join(Rails.root, 'lib', 'tasks', 'demo')

      print "Loading account by subdomain ... "
      account = Account.where(subdomain: args[:subdomain]).first

      if account.nil?
        puts "Failed"
        raise "Account not found by subdomain #{args[:subdomain]}"
      elsif !account.active?
        puts "Failed"
        raise "Account found but not active! Please activate account."
      else
        puts "OK"
      end

      print "Deleting existing products ... "
        account.products.delete_all
      puts "OK"

      print "Reading images file names ... "
        images = {}
        Find.find(File.join(demo_root, "images")) do |path|
          id = File.basename(path).scan(/^\d+/).first
          images[id] = path
        end
      puts "OK"

      puts "Loading data ... "

      i = 0
      # id, description, functional_name, variant, brand, sub_brand, content_value, content_unit
      CSV.foreach(File.join(demo_root, 'data.csv'), headers: true, converters: :numeric)  do |d|


        product = account.products.new brand: d["brand"].try(:[], 0..69),
                                       sub_brand: d["sub_brand"].try(:[], 0..69),
                                       functional_name: d["functional_name"].try(:[], 0..34),
                                       variant: d["variant"].try(:[], 0..34),
                                       description: d["description"],
                                       country_of_origin: "RU",
                                       manufacturer: d["brand"].try(:[], 0..34)

        package = product.packages.build type: "BK"

        case d["content_unit"]
          when "кг"
            value = d["content_value"] * 1000
            unit = "GR"
          when "л"
            value = d["content_value"] * 1000
            unit = "ML"
          when "г"
            value = d["content_value"]
            unit = "GR"
          when "мл"
            value = d["content_value"]
            unit = "ML"
          when "шт"
            value = d["content_value"]
            unit = "1N"
          else
            value = ""
            unit = ""
        end

        package.contents.build value: value, unit: unit unless value.blank?

        product.product_codes.build name: "FOR_INTERNAL_USE_1", value: d["id"] unless d["id"].blank?

        product.save!

        i += 1

        puts "#{i} done" if i % 100 == 0
 	    end

      puts "All done"
    end

    desc "Load demo photos for demo products. All current photos will be destroyed!"
    task :photos, [:subdomain] => :environment do |task, args|
      if args[:subdomain].blank?
        raise "Please, specify account by subdomain: rake gm:demo:photos[subdomain]"
      end

      demo_root = File.join(Rails.root, 'lib', 'tasks', 'demo')

      print "Loading account by subdomain ... "
      account = Account.where(subdomain: args[:subdomain]).first

      if account.nil?
        puts "Failed"
        raise "Account not found by subdomain #{args[:subdomain]}"
      elsif !account.active?
        puts "Failed"
        raise "Account found but not active! Please activate account."
      else
        puts "OK"
      end

      print "Reading images file names ... "
        images = {}
        Find.find(File.join(demo_root, "images")) do |path|
          id = File.basename(path).scan(/^\d+/).first
          images[id] = path
        end
      puts "OK"

      print "Deleting old photos ... "
      account.photos.each do |photo|
        photo.delay.destroy
      end
      puts "OK"

      puts "Loading photos ... "

      account.products.each_with_index do |product, i|

        num = product.product_codes.first.value

        unless num.blank?
          image_path = images["#{num}"]
          unless image_path.blank?
            image = MiniMagick::Image.new(image_path)
            photo = product.photos.build(image: image)
            photo.save
            image.destroy!
          end

          puts "#{i + 1} done" if (i + 1) % 100 == 0
        end
 	    end

      puts "All done"
    end
  end
end