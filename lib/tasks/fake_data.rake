namespace :db do
  namespace :seed do
    task :fake_data => :environment do

UOMS = { 'кг'=>'KGM',
          'л' => 'LTR',
          'шт' => 'PCE',
          'г' => 'GRM',
          'мл' => 'MLT',
          'м' => 'MTR'  }
############################################
#read structure data
############################################

      fsource =File.open(File.join(Rails.root,'data', "data3.csv"),'r')

      @rows = {}
      @bis_map = {}
      @mnfc={}
      begin
        header = fsource.readline
        while (line = fsource.readline)
          if line.size > 2
            row = line.split('|')
            @rows[row[0]] = row
            @mnfc[row[13]]=0
            if row[35].any? and row[35]!='4300'
              @bis_map[row[35]] ||= {'child'=> nil, 'parent' => nil}
              @bis_map[row[35]]['parent'] ||=[]
              @bis_map[row[35]]['parent'] << row[0]
            end
            @bis_map[row[0]] ||= {'child'=> nil, 'parent' => nil} unless row[35] == '4300'
          end
        end
      rescue EOFError
        fsource.close
      end
      new_names =%w{Unilever Henkel Coca-Cola Procter&Gamble Valio Mars Ferrero Pepsico Bacardi Campina Danone Haribo Dr.Oetker GSK SCA Schweppes Nestle Sunbird Sancor Rothschild}

      @mnfc.keys.each_with_index{|k, i|
        @mnfc[k] =new_names[i % new_names.count]
      }


############################################
#read netweight data
############################################
      fsource =File.open(File.join(Rails.root,'data', "netweight.csv"),'r')
      @netweight = {}
      begin
        header = fsource.readline
        while  (line = fsource.readline)
          row = line.split('|')
          if row[3] and row[3].any?
          case row[3].strip
          when 'KGM'
            netweight[row[0]] = row[2].to_f*1000 if line.length > 2
          when 'GRM'
            netweight[row[0]] = row[2].to_f if line.length > 2
          end
        end
        end
      rescue EOFError
        fsource.close
      end
############################################
#read images
############################################
      @imgs = []
      images = []
      ['*.jpg','*.JPG','*.gif','*.GIF','*.png','*.PNG'].each do |ext|
        images << Dir.glob(File.join(Rails.root,'data', 'images', ext))
      end
      images = images.flatten
      images.each{|x|
        id= x.split('/')[-1].split(/[^\d]{1}/)[0];
        @imgs << id if id and id.any?
      }
############################################
#read description data
############################################
      fsource =File.open(File.join(Rails.root,'data', "price.csv"),'r')
      items = []
      begin
        header = fsource.readline
        while  (line = fsource.readline)
          row = line.split('|')
          items << row if line.length > 2 and @imgs.include? row[0]
        end
      rescue EOFError
        fsource.close
      end
############################################
#make changes here
############################################

      def print_map(k,c, path)
        path << "\r\n"
        if @bis_map[k]['parent']
          @bis_map[k]['parent'].each do |p|
            path << "#{' '*c}-pi"
            print_map(p,c+1, path)
          end
        end
        path
      end

      @counter = 0
      @q_items = [800,300,100,80,86]
      @q_count = 0
      def create_hierarchy(k,  data, parent = nil)
        unless parent
          puts "======"
          @counter += 1
          if @counter > @q_items[@q_count]
            @counter = 0
            @q_count += 1
          end
          user = User.where(:role => 'supplier')[@q_count]


          i = Item.new(:user_id => user.id)
          i.save
          item = BaseItem.new()
          item.item_id = i.id
          item.status = 'published'
          item.internal_item_id = i.id
          item.user_id = user.id
          item.minimum_durability_from_arrival = 10
          ##################
          #from price.csv
          ##################
          item.item_description = data[1]
          item.functional = data[2].mb_chars.length > 35 ? data[2].mb_chars[0..34] : data[2]
          item.brand = data[4]
          item.subbrand = data[5]
          image_id = data[0]
          item.variant = data[6]
          item.content = data[7].gsub(',','.').to_f
          item.content_uom =  UOMS[data[8].strip]
          #################
          data = @rows[k]
          item.gtin = k
          item.despatch_unit = data[9] == 'Y'
          item.order_unit = data[10] == 'Y'
          item.consumer_unit = data[11] == 'Y'

          item.manufacturer_gln = data[12]
          item.manufacturer_name = data[13].any? ? @mnfc[data[13]] : "Unknown"

          item.vat = '59'
          item.gpc_code = data[26]
          item.country_of_origin_code = "RU"
          item.packaging_type = data[28][0..2]
          item.gross_weight = data[16] if data[16]
          item.net_weight = @netweight[k] if @netweight[k]
          item.height = data[29]
          item.width = data[33]
          item.depth = data[31]
          unless item.save
            puts parent.inspect
            puts item.inspect
            puts item.errors.full_messages
          end
          ################################
          # add images
          ###############################
          images = []
          ['*.jpg','*.JPG','*.gif','*.GIF','*.png','*.PNG'].each do |ext|
            images << Dir.glob(File.join(Rails.root,'data', 'images', ext))
          end
          images = images.flatten


          index = images.index{|x| x.split('/')[-1].split(/[^\d]{1}/)[0] == image_id}
          if index
          path = images[index]

          image = File.open(path,'r')
          @original = OriginalImage.new(image)

          if @original.test_and_prepare?
            @image = Image.new()
            @image.item_id = item.item_id
            @image.base_item_id = item.id
            @image.save
            for image_parameter in Webforms::IMAGE_PARAMETERS do
            	if @image.resize(@original.raw, image_parameter['width'], image_parameter['height'], image_parameter['scale'], image_parameter['fill'], image_parameter['name'])
            	else
            	  # sth wrong
            	end
            end
          else
            # wrong picture
          end
  #        puts image_id
          end
        else
          item = if parent.kind_of? BaseItem
                   parent.packaging_items.new(:user_id => parent.user_id)
                 else
                   bi = BaseItem.find(parent.base_item_id)
                   bi.packaging_items.new(:parent_id => parent.id, :user_id => parent.user_id)
                 end
          item.gtin = k
          data = @rows[k]

          item.number_of_next_lower_item = data[36]
          item.packaging_type = data[28][0..2]
          item.height = data[29].any? ? data[29] : data[41]
          item.width = data[33]
          item.depth = data[31]
          items_number = item.number_of_next_lower_item
          items_number ||= item.number_of_bi_items
          #puts (0.96 * parent.gross_weight.to_i * items_number.to_i)
          gw = if parent.gross_weight.to_i * items_number.to_i > data[16].to_i
                  parent.gross_weight.to_i * items_number.to_i
                else
                  data[16].to_i
                end
          item.gross_weight = gw
          item.quantity_of_layers_per_pallet = data[40]
          item.quantity_of_trade_items_per_pallet_layer = data[59]
          item.stacking_factor = data[42]
        unless item.save
            puts parent.inspect
            puts item.inspect
            puts item.errors.full_messages
        end
        end


        if @bis_map[k]['parent']
          @bis_map[k]['parent'].each do |p|
            create_hierarchy(p, data, item)
          end
        end

      end

      @bis_map.each do |k,v|
        if v['parent'] and v['parent'].any?
          v['parent'].each do |p|
            @bis_map[p]['child'] = k
          end
        end
      end
      parents= []

      puts items.length
      sleep 5
      begin
       @bis_map.each{|k,v| parents << k unless v['child']}
       items.each_with_index do |item,counter|
         if counter < parents.count
           k = parents[counter]
           v = @bis_map[k]
           unless v['child']
             create_hierarchy(k, item)
           end
         else
           break
         end
       end
      rescue
      end

      tag = Tag.new(:name => 'complex', :kind => 1)
      tag.save
      Item.all.each{|item|
        bi = item.base_items.last
        if bi.packaging_items.count > 4
          cl = Cloud.new
          cl.user_id = bi.user_id
          cl.item_id = item.id
          cl.tag_id = tag.id
          cl.save
        end
      }.count
      BaseItem.all.each{|bi|bi.update_mix_field;bi.save}
    end
  end
end

