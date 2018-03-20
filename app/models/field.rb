class Field < ApplicationRecord

  require 'csv'
  require 'yaml'


  def self.import_fourth_file(file4)
    CSV.open("CSV_final.csv", "wb") do |csv|
      csv << @new_fields
    end
    CSV.open("CSV_final.csv", "a+") do |csv|
      CSV.foreach(file4.path, headers: true) do |row|
        temp_arr=[]
        for i in 0..@old_fields.length-1
          temp_arr.push row[@old_fields[i]]
        end
        csv << temp_arr
      end
    end
  end


  def self.import_map_file(file3)
    @new_fields=[]
    @old_fields=[]
    data = YAML.load_file(file3.path)
    data.each do |k, v|
      @new_fields.push k
      @old_fields.push v
    end
  end


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
    # $final_arr.each {|a| p a}
  end
end
