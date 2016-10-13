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


    File.open(filename) do |file|
      # IO#each_lineは1行ずつ文字列として読み込み、それを引数にブロックを実行する
      # 第1引数: 行の区切り文字列
      # 第2引数: 最大の読み込みバイト数
      # 読み込み用にオープンされていない場合にIOError
      file.each_line do |labmen|
        # labmenには読み込んだ行が含まれる

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
                lat = val
              elsif index == 5 then
                lon = val
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
              gpx.puts( "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>\"" )
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

        end#GPRMC
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
