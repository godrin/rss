require 'rss'
require 'open-uri'
require 'pp'

content=nil
if false
  url="http://www.spiegel.de/schlagzeilen/index.rss"
  open(url) do |s| content = s.read end
else
  File.open("/tmp/rss1.xml"){|f|content=f.read}
end
rss_source=content
#pp rss_source
rss = RSS::Parser.parse(rss_source,false)

pp rss
