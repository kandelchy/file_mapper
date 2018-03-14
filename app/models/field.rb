class Field < ApplicationRecord

  require 'csv'

  def self.import_first_file(file)
    csv = CSV.read(file.path, headers:true, return_headers:true)
    csv_header1 = csv.headers
    Field.delete_all
    serial = 0
    reg_exp = csv[1].to_hash
    reg_exp.each do |k, v|
      bb= Field.create(head1: k, reg_exp: v, seq: serial)
      bb.save!
      serial += 1
    end
  end


  def self.import_second_file(file2)
    reg_exp_arr = Array[]
    # Reade regular exp from table into array
    Field.all.each.with_index do |col_name, k|
      reg_exp_arr[k] = Regexp.new(col_name.reg_exp)
      k +=1
    end
    t_rows = reg_exp_arr.length
    $final_arr = []
    # Scan CSV file line by line
    CSV.foreach(file2.path, headers: true).with_index do |row, k|
      if k == 0
        @csv_headers= row.headers
        @t_cols = row.length
        # Create the final array that will hold Reg Exp and Col Haders
        for i in 0..t_rows-1
          array_row = []
          array_row.push(reg_exp_arr[i])
          for j in 0..@t_cols-1
            array_row.push(j)
          end
          $final_arr.push(array_row)
        end
      end
      # Find the Headers that match the reg exp
      for i in 0..t_rows-1
        j=1
        header_counter=0
        while header_counter <= @t_cols-1
          if $final_arr[i][0].match?(row[$final_arr[i][j]])
            j=j+1
          else
            $final_arr[i].delete_at(j)
          end
          header_counter += 1
        end
      end
      break
      k += 1
    end
    # Rplace numbrs with corresponding headers
    for i in 0..t_rows-1
      for j in 1..$final_arr[i].length-1
        $final_arr[i][j] = @csv_headers[$final_arr[i][j]]
      end
      #Delete rgular exp from 1st column
      $final_arr[i].delete_at(0)
    end

    puts "****************************************"
    $final_arr.each {|a| p a}
    puts "****************************************"

  end
end



# def self.import_second_file(file2)
#   reg_exp_arr = Array[]
#   Field.all.each.with_index do |col_name, k|
#     reg_exp_arr[k] = Regexp.new(col_name.reg_exp)
#
#     k +=1
#   end
#   t_rows = reg_exp_arr.length
#   $final_arr = []
#   # Scan CSV file line by line
#   CSV.foreach(file2.path, headers: true).with_index do |row, k|
#     if k == 0
#       @csv_headers= row.headers
#       @t_cols = row.length
#       # Create the final array that will hold Reg Exp and Col Haders
#       for i in 0..t_rows-1
#         array_row = []
#         array_row.push(reg_exp_arr[i])
#         for j in 0..@t_cols-1
#           array_row.push(row.headers[j])
#         end
#         $final_arr.push(array_row)
#       end
#     else
#       # Find the Headers that match the reg exp
#       for i in 0..t_rows-1
#         j=1
#         header_counter=0
#         while header_counter <= @t_cols-1
#           if $final_arr[i][0].match?(row[header_counter])
#             $final_arr[i][j]= @csv_headers[header_counter]
#             j=j+1
#           else
#             puts "****************************************"
#             puts row[header_counter]
#             puts "****************************************"
#             $final_arr[i].delete_at(j)
#           end
#           header_counter += 1
#         end
#       end
#     end
#     k += 1
#   end
#   puts "****************************************"
#   $final_arr.each {|a| p a}
#   puts "****************************************"
#   for i in 0..t_rows-1
#     $final_arr[i].delete_at(0)
#   end
# end
# end
