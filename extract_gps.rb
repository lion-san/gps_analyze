
# getPosition
# 緯度経度を返す関数
def getPosition(str)
  positions = str.split(".")

  #DDDMM.MMMM to DDD.DDDDD
  m = (( positions[0][positions[0].length-2..positions[0].length] + "." + positions[1]).to_f / 60)

  d = positions[0][0..positions[0].length-3].to_f + m


  return d.round(9)

end

begin
  # File.openはファイルをオープンし、Fileオブジェクトを返す
  # 第1引数: ファイルパス
  # 第2引数: ファイルモード (デフォルト => 'r')
  # 第3引数: ファイルを生成する場合のパーミッション(デフォルト => 0666)
  # 失敗した場合にErrno::EXXX例外が発生
  #
  # File.openにブロックを渡すと、
  # ブロックが終了した時点でファイルを自動でクローズする


  filename = ARGV[0]

  flg = true


  gpx = nil


  count = 0
    File.open(filename) do |file|
      # IO#each_lineは1行ずつ文字列として読み込み、それを引数にブロックを実行する
      # 第1引数: 行の区切り文字列
      # 第2引数: 最大の読み込みバイト数
      # 読み込み用にオープンされていない場合にIOError
      file.each_line do |labmen|
        # labmenには読み込んだ行が含まれる
        #count += 1
        #puts count

        #先頭文字が$GPRMC
        if (labmen[0, 6] == "$GPRMC") then
          strAry = labmen.split(",")

          if ( strAry.length == 13) then

            index = 0
            lat =   0
            lon =   0
            ele = 0
            speed = 0
            ymd =   "" 
            time =  "" 


            strAry.each do |val|
             
              #Extract Data
              if index == 1  then
                time = val[0, 2] + ":" + val[2, 2] + ":" + val[4, 2]
              elsif index == 3 then
                lat = getPosition( val )
              elsif index == 5 then
                lon = getPosition( val )
              elsif index == 7 then
                speed = val
              elsif index == 9 then
                ymd = "20" + val[4, 2] + "-" + val[2, 2] + "-"  + val[0, 2]
              end
              index = index + 1
            end

            #FirstData ==============================================
            if flg then

              outFilename = ymd + "_" + time[0, 2] + "-" + time[3, 2]
              gpx =  File.open( outFilename + ".gpx", "w")
              #お決まり
              gpx.puts( "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>" )
              gpx.puts( "<gpx version=\"1.0\" creator=\"WindfurfingLab- http://www.windsurfinglab.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.topografix.com/GPX/1/0\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd\">" )
              gpx.print( "<time>" )
              gpx.print( ymd )
              gpx.print( "T" )
              gpx.print( time )
              gpx.print( "Z" )
              gpx.puts( "</time>" )

              gpx.puts( "<trk>" )
              gpx.print( "<name>" )
              #gpx.print( ymd )
              #gpx.print( " " )
              #gpx.print( time[0, 2] + "-" + time[3, 2] )
              gpx.print( outFilename )
              gpx.puts( "</name>" )
              gpx.puts( "<trkseg>" )
              flg = false
            end
            #FirstData ==============================================
              
            #Puts Data
            gpx.print( "<trkpt " )
            gpx.print( "lat=\"" )
            gpx.print( lat )
            gpx.print( "\" " )
            gpx.print( "lon=\"" )
            gpx.print( lon )
            gpx.puts( "\">" )

            #標高
            gpx.print( "<ele>" )
            gpx.print( ele )
            gpx.puts( "</ele>" )

            #時間
            gpx.print( "<time>" )
            gpx.print( ymd )
            gpx.print( "T" )
            gpx.print( time )
            gpx.print( "Z" )
            gpx.puts( "</time>" )

            #速度
            gpx.print( "<speed>" )
            gpx.print( speed )
            gpx.puts( "</speed>" )

            gpx.puts( "</trkpt>" )

          end#13

        #============================================
        ##先頭文字が$MOTION
=begin
        elsif (labmen[0, 7] == "$MOTION") then
          if flg then
            next 
          end

          strAry = labmen.split(",")

          if ( strAry.length == 11) then

            gpx.puts("<motion>")

            index = 0
            strAry = labmen.chomp.split(",")
            strAry.each do |val|

              if index == 1 then
                gpx.print("<delta_t>")
                gpx.print(val)
                gpx.print("</delta_t>")
              elsif index == 2 then
                gpx.print("<ax>")
                gpx.print(val)
                gpx.print("</ax>")
              elsif index == 3 then
                gpx.print("<ay>")
                gpx.print(val)
                gpx.print("</ay>")
              elsif index == 4 then
                gpx.print("<az>")
                gpx.print(val)
                gpx.print("</az>")
              elsif index == 5 then
                gpx.print("<gx>")
                gpx.print(val)
                gpx.print("</gx>")
              elsif index == 6 then
                gpx.print("<gy>")
                gpx.print(val)
                gpx.print("</gy>")
              elsif index == 7 then
                gpx.print("<gz>")
                gpx.print(val)
                gpx.print("</gz>")
              elsif index == 8 then
                gpx.print("<mx>")
                gpx.print(val)
                gpx.print("</mx>")
              elsif index == 9 then
                gpx.print("<my>")
                gpx.print(val)
                gpx.print("</my>")
              elsif index == 10 then
                gpx.print("<mz>")
                gpx.print(val)
                gpx.puts("</mz>")
              end
              index = index + 1
            end

            gpx.puts("</motion>")
          end#11
=end
        end#GPRMC MOTION

      end#labman
    end#file

    gpx.puts( "</trkseg>" )
    gpx.puts( "</trk>" )
    gpx.puts( "</gpx>" )
  #end #End of GPX


  gpx.close




# 例外は小さい単位で捕捉する
rescue SystemCallError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
end


