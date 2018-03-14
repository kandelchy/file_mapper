def test1_code
  reg_exp_arr = Array[]
  Field.all.each.with_index do |col_name, k|
    reg_exp_arr[k] = Regexp.new(col_name.reg_exp)
    k +=1
  end
  reg_exp_len = reg_exp_arr.length
  t_rows = reg_exp_len
  # Scan CSV file line by line
  CSV.foreach(file2.path, headers: true).with_index do |row, k|
    if k == 0
      $csv_headers= row.headers
      @t_cols = row.length
      @match_arr = Array.new(t_rows){Array.new(@t_cols, "undefined")}
      @match_arr.each {|a| p a}
    else
      for i in 0..t_rows-1
        for j in 0..@t_cols-1
          if @match_arr[i][j] != "cancel"
            if reg_exp_arr[i].match?(row[j])
              @match_arr[i][j]= $csv_headers[j]
            else
              @match_arr[i][j]="cancel"
            end
          end
        end
      end
    end
    k += 1
  end

  puts "****************************************"
  @match_arr.each {|a| p a}
  puts "****************************************"

  $final_arr = []

  for i in 0..t_rows-1
    f1 = []
    for j in 0..@t_cols-1
      if @match_arr[i][j] != "cancel"
        f1.push(@match_arr[i][j])
      end
    end
    $final_arr.push(f1)
  end

  puts "****************************************"
  $final_arr.each {|a| p a}
  puts "****************************************"


end


def test_code
  csv = CSV.read(file2.path, headers:true, return_headers:true)
  $file2_headers = csv.headers
  row_len = $file2_headers.length
  $included_headers = Array[row_len]
  for k in 0..row_len-1
    # puts "********************"
    # puts "k value = #{k}"
    # puts "********************"
    $included_headers[k] = true
  end
  Field.all.each do |col_name|
    tester= Regexp.new(col_name.reg_exp)
    col_no = 2
    for col_no in 2..row_len-1
      csv[$file2_headers[col_no]].each_with_index do |s, i|
        next if i ==0
        puts "********************"
        puts $file2_headers[col_no]
        puts s
        puts tester
        reg_exp_match = tester.match(s)
        puts reg_exp_match
        puts "********************"
        unless reg_exp_match
          # Skip column
          puts "NO MATCH FOUND"
          $included_headers[col_no] = false
          break
        end
        i += 1
        # col_no += 1
      end
      for k in 0..row_len-1
        # puts "********************"
        # puts "k value = #{k}"
        # puts "********************"
        puts $file2_headers[k]
        puts $included_headers[k]
      end
    end
  end
end

def check_headers(reg_exp_code)

end
