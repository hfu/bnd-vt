task :default do
  sh "ruby data.rb"
  sh "../tippecanoe/tippecanoe --drop-fraction-as-needed --drop-smallest-as-needed --drop-densest-as-needed --minimum-zoom=0 --maximum-zoom=12 -P -B12 -f --layer=bnd -o data.mbtiles data.ndjson"
  #sh "ruby fan-out.rb"
  #sh "git add -v ."
  #sh "git commit -m 'update'"
  #sh "git push -v origin master"
end
