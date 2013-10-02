アイマス公式ブログ（2013.9.21以降版）向け「非公式」RSS取得プログラム
書いた人: 導線 http://dousen.org/
サイト: http://dousen.org/imasrss/
初版公開日：2013年10月2日

MIT License http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license の範囲内で自由に利用を認めます。
（作者表記を消すことがなければ、改変・組み込み等含め自由に利用いただけます。）

動かし方
・Ruby（http://www.ruby-lang.org/）が動く環境を用意します。
・Nokogiri（http://nokogiri.org/）をインストールします。
　Rubygemsを用いて gem install nokogiri とするのが楽です。
・imasrss.rb をダウンロードし、必要に応じて内容を書き換えます。OUTPUT_URIなど
・ruby imasrss.rb としてスクリプトを動かすと、RSS（RDF）が出力されます。
