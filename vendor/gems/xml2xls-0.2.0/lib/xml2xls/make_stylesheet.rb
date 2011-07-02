# require 'xml2xls/core_ext/string'
# require 'spreadsheet'
module Xml2xls
  def self.make_stylesheet doc, filename
    tf = Tempfile.new(filename)
    tf.puts '<?xml version="1.0" encoding="utf-8"?><?mso-application progid="Excel.Sheet"?>' + doc
    tf.close
    return tf
    #end
    # book = Spreadsheet::Workbook.new
    #     xml = (Nokogiri::XML doc).child
    #     styles = {}
    #     xml.children.each do |main|
    #       if main.name == "Styles"
    #         styles = process_styles(styles, main.children)
    #       elsif main.name == "Worksheet"
    #         #process Worksheet
    #         sheet = book.create_worksheet(:name => main["Name"])
    #         main.children.each do |worksheet|
    #           if worksheet.name == "Table"
    #             #Process Table
    #             col_index = -1
    #             row_index = -1
    #             worksheet.children.each do |col_row|
    #               if col_row.name == "Column"
    #                 #Process Column
    #                 if col_row["Index"]
    #                   col_index = col_row["Index"].strip.to_i 
    #                 else
    #                   col_index += 1
    #                 end
    #                 hidden = col_row["Hidden"].strip.to_bool if col_row["Hidden"]
    #                 width = col_row["Width"].strip.to_f if col_row["Width"]
    #                 if col_row["Span"] # repeat styles span times
    #                   (col_row["Span"].strip.to_i).times do |i|
    #                     col = Spreadsheet::Column.new(col_index + i, nil)
    #                     col.hidden = hidden
    #                     col.width = width
    #                     sheet.columns << col
    #                   end
    #                 else
    #                   column = Spreadsheet::Column.new(col_index, nil)
    #                   column.hidden = hidden
    #                   column.width = width
    #                   sheet.columns << column
    #                 end
    #                 #/Process Column
    #               elsif col_row.name == "Row"
    #                 #Process Row
    #                 if col_row["Index"]
    #                   row_index = col_row["Index"].strip.to_i 
    #                 else
    #                   row_index += 1
    #                 end
    #                 sheet.row(row_index).height = col_row["Height"].strip.to_i if col_row["Height"]
    #                 cell_index = -1
    #                 sheet.row(row_index).set_format(0, styles["Default"])
    #                 col_row.children.each do |cell|
    #                   #Process Cell
    #                   next unless cell.name == "Cell"
    #                   prev_cell_index = cell_index
    #                   if cell["Index"]
    #                     cell_index = cell["Index"].strip.to_i 
    #                   else
    #                     cell_index += 1
    #                   end
    #                   if cell_index > prev_cell_index + 1
    #                     #set default style to empty cells
    #                     i = prev_cell_index + 1
    #                     while i < cell_index
    #                       sheet.row(row_index).set_format(i, styles["Default"]) 
    #                       i += 1
    #                     end
    #                   end
    #                   if cell["StyleID"] and styles[cell["StyleID"]]
    #                     sheet.row(row_index).set_format(cell_index, styles[cell["StyleID"]]) 
    #                   else
    #                     sheet.row(row_index).set_format(cell_index, styles["Default"]) 
    #                   end
    #                   cell.children.each do |data|
    #                     if data["Type"] == "String"
    #                       sheet.row(row_index).push data.text
    #                     elsif data["Type"] == "Number"
    #                       sheet.row(row_index).push data.text.strip.to_i
    #                     end
    #                   end
    #                   #/Process Cell
    #                 end
    #                 #/Process Row
    #               end
    #             end
    #             #/Process Table
    #           end
    #         end
    #         #/process Worksheet
    #       end
    #     end
    #     tf = Tempfile.new(filename)
    #     book.write tf.path
    #     return tf
  end
=begin
  COLORS = {
    "#00FFFF" => "aqua",
    "#000000" => "black",
    "#0000FF" => "blue",
    "#00FFFF" => "cyan",
    "#A52A2A" => "brown",
    "#FF00FF" => "fuchsia",
    "#808080" => "gray",
    "#808080" => "grey",
    "#008000" => "green",
    "#00FF00" => "lime",
    "#FF00FF" => "magenta",
    "#000080" => "navy",
    "#FFA500" => "orange",
    "#800080" => "purple",
    "#FF0000" => "red",
    "#C0C0C0" => "silver",
    "#FFFFFF" => "white",
    "#FFFF00" => "yellow"
  }

  def self.closest_color str
    #because gem spreadsheet doesn't recognize hex color.
    return @closest_colors[str] if @closest_colors[str]
    r1 = str[1..2].to_i(16)
    g1 = str[3..4].to_i(16)
    b1 = str[5..6].to_i(16)
    min = nil
    min_hex = nil
    COLORS.each_key do |hex|
      r = hex[1..2].to_i(16)
      g = hex[3..4].to_i(16)
      b = hex[5..6].to_i(16)
      distance = Math.sqrt((r-r1)**2 + (g-g1)**2 + (b-b1)**2)
      min ||= distance
      min_hex ||= hex
      if distance < min
        min = distance
        min_hex = hex
      end
    end
    @closest_colors[str] = COLORS[min_hex]
  end

  def self.make_color str 
    #because gem spreadsheet doesn't recognize hex color.
    return COLORS[str] if COLORS[str]
    return closest_color(str)
  end

  def self.process_styles(styles, xml_styles)
    #process styles for Spreadsheet.
    xml_styles.each do |xml_style|
      id = xml_style["ID"]
      next unless id
      styles[id] = styles[xml_style["Parent"]].dup if xml_style["Parent"] and styles[xml_style["Parent"]]
      styles[id] ||= Spreadsheet::Format.new
      xml_style.children.each do |param|
        case param.name
        when "Alignment"
          param.each do |key, value|
            case key
            when "Vertical"
              styles[id].vertical_align = value
            when "Horizontal"
              styles[id].horizontal_align = value
            end
          end
        when "Borders"
          param.each do |border|
            next unless border.name == "Border"
            border.each do |key, value|
              case key
              when "Bottom"
                styles[id].bottom = value.to_bool
              when "Left"
                styles[id].left = value.to_bool
              when "Right"
                styles[id].right = value.to_bool
              when "Top"
                styles[id].top = value.to_bool
              end
            end
          end
        when "Font"
          name = param["FontName"] ? param["FontName"] : "unnamed"
          font = Spreadsheet::Font.new name
          param.each do |key, value|
            case key
            when "Family"
              font.family = value 
            when "Color"
              font.color = make_color(value)
            when "Bold"
              font.bold = true
            when "CharSet"
            when "FontName"
            when "Size"
              font.size = value.to_i
            when "Italic"
              font.italic = value.to_bool
            when "Underline"
              font.underline = value.to_bool
            end
          end
          styles[id].font = font
        when "Interior"
          param.each do |key, value|
            case key
            when "Color"
              styles[id].pattern_fg_color = make_color(value)
              styles[id].pattern = 1
            when "Pattern"
            when "PatternColor"
            end
          end
        when "NumberFormat"
          param.each do |key, value|
            case key
            when "Format"
              styles[id].number_format = value
            end
          end  
        end
      end
    end
    return styles
  end
=end
end