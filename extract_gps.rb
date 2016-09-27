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

  ok = 0
  gprmc = 0


  #File.open("gps.csv", "w") do |w|

    File.open(filename) do |file|
      # IO#each_lineは1行ずつ文字列として読み込み、それを引数にブロックを実行する
      # 第1引数: 行の区切り文字列
      # 第2引数: 最大の読み込みバイト数
      # 読み込み用にオープンされていない場合にIOError
      file.each_line do |labmen|
        # labmenには読み込んだ行が含まれる


        #先頭文字が$GPRMC
        if (labmen[0, 6] == "$GPRMC") then
          gprmc = gprmc + 1
          strAry = labmen.split(",")

          if ( strAry.length == 12) ||  ( strAry.length == 14) then
            #puts strAry.length
            ok = ok + 1
            puts labmen

            #w.puts( labmen )
          
            #strAry.each do |val|
              #print("[", val, "]¥n")
            #/mnd

          end

        end

      end
    end
  #end

  puts "total:  "
  puts  gprmc
  puts "ok:     "
  puts ok
  puts "per:    "
  puts (ok/gprmc)


# 例外は小さい単位で捕捉する
rescue SystemCallError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
  puts %Q(class=[#{e.class}] message=[#{e.message}])
end
