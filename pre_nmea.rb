begin

  filename = ARGV[0]
  out =  File.open( "out_" + filename + ".nmea", "w")

  count = 0
    File.open(filename) do |file|
      file.each_line do |labmen|
        #先頭文字が$GPRMC
        if (labmen[0, 6] == "$GPRMC") then
          strAry = labmen.split(",")
          if ( strAry.length == 13) then
            #strAry.each do |val|
            #  out.print(val)
            #end
            out.print(labmen)

          end#13
        end#GPRMC
      end#labman
    end#file

  #end #End of GPX


  out.close




# 例外は小さい単位で捕捉する
rescue SystemCallError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
end


