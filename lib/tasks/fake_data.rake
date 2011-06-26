namespace :db do
  namespace :seed do
    task :fake_data => :environment do
      i = 0

UOMS = { 'кг'=>'KGM',
          'л' => 'LTR',
          'шт' => 'PCE',
          'г' => 'GRM',
          'мл' => 'MLT'  }
############################################
#read structure data
############################################

      fsource =File.open(File.join(Rails.root,'data', "data3.csv"),'r')

      @rows = {}
      @bis_map = {}
      begin
        header = fsource.readline
        while (line = fsource.readline)
          row = line.split('|')
          @rows[row[0]] = row
          if row[35].any? and row[35]!='4300'
            @bis_map[row[35]] ||= {'child'=> nil, 'parent' => nil}
            @bis_map[row[35]]['parent'] ||=[]
            @bis_map[row[35]]['parent'] << row[0]
          end
          @bis_map[row[0]] ||= {'child'=> nil, 'parent' => nil}
        end
      rescue EOFError
        fsource.close
      end
############################################
#read description data
############################################
      fsource =File.open(File.join(Rails.root,'data', "price.csv"),'r')
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
#read description data
############################################
      fsource =File.open(File.join(Rails.root,'data', "price.csv"),'r')
      items = []
      begin
        header = fsource.readline
        while  (line = fsource.readline)
          row = line.split('|')
          items << row if line.length > 2
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

      def create_hierarchy(k,  data, parent = nil)
        unless parent
          puts "======"
          puts k
          user = User.where(:role => 'supplier').first
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
          item.functional = data[2]
          item.brand = data[4]
          item.subbrand = data[5]
          #item.variant = data[6]
          item.content = data[7].gsub(',','.').to_f
          item.content_uom =  UOMS[data[8].strip]
          #################
          data = @rows[k]
          item.gtin = k
          item.despatch_unit = data[9] == 'Y'
          item.order_unit = data[10] == 'Y'
          item.consumer_unit = data[11] == 'Y'

          item.manufacturer_gln = data[12]
          item.manufacturer_name = data[13].any? ? data[13] : "test "

          item.vat = '59'
          item.gpc_code = data[26]
          item.country_of_origin_code = "RU"
          item.packaging_type = data[28][0..2]
          item.gross_weight = data[16]
          item.net_weight = @netweight[k] ? @netweight[k] : data[16]
          item.height = data[29]
          item.width = data[33]
          item.depth = data[31]
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
          item.height = data[29].any? ? data[29] : parent.height * item.number_of_next_lower_item
          item.width = data[33].any? ? data[33] : parent.width * item.number_of_next_lower_item
          item.depth = data[31].any? ? data[31] : parent.depth * item.number_of_next_lower_item
          item.gross_weight = data[16].any? ? data[16] : parent.gross_weight * item.number_of_next_lower_item
          item.quantity_of_layers_per_pallet = data[40]
          item.quantity_of_trade_items_per_pallet_layer = data[59]
          item.stacking_factor = data[42]
        end
        unless item.save
            puts item.inspect
            puts item.errors.full_messages
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

      counter = 0
      items.each do |item|
        #puts item
        k = @bis_map.keys[counter % @bis_map.keys.count]
        counter +=1
        v = @bis_map[k]
        unless v['child']
          create_hierarchy(k, item)
        end
      end

    end
  end
end

