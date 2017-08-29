require 'find'
require 'json'

def report(count, dict)
  #print "[#{name}]"
  #return
  dict.keys.sort{|a, b| dict[b] <=> dict[a]}.each {|k|
    print "#{k}: #{dict[k]}\n"
  }
  print "\n"
end

w = File.open('data.ndjson', 'w')
error = File.open('error.list', 'w')
count = 0
dict = Hash.new{|h, k| h[k] = 0}
name = ''
Find.find('/Volumes/fgd/experimental_fgd/18') {|path|
  next unless path.end_with?('geojson')
  begin
    JSON::parse(File.read(path))['features'].each {|f|
      next unless %w{AdmBdry CommBdry AdmPt CommPt AdmArea SBBdry SBAPt SBArea Cstline}.include?(f["properties"]["class"])
      dict[f["properties"]["class"] + "::" + f["properties"]["type"]] += 1
      minzoom = case f["properties"]["type"]
      when "海岸線", "都道府県界"
        0
      when "郡市・東京都の区界", "郡市・東京都の区"
        9
      when "市区町村界"
        10
      when "町村・指定都市の区界", "町村・指定都市の区"
        11
      when "大字・町・丁目界", "大字・町・丁目"
        12
      else
        9
      end
      f["tippecanoe"] = {"minzoom" => minzoom}
      %w{fid lfSpanFr lfSpanTo devDate orgMDId}.each{|k|
        f["properties"].delete(k)
      }
      w.print JSON::dump(f), "\n"
      count += 1
      report(count, dict) if count % 100 == 0
    }
  rescue
    print "\nerror in #{path}: #{$!}\n"
    error.print "#{path}\n"
  end
}
w.close
error.close
