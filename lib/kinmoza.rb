require 'open-uri'
require 'nokogiri'
require 'fileutils'

root_url = 'http://matome.naver.jp/odai/2140565326846064501'

local_dir = "#{File.dirname(__FILE__)}/../tmp"

FileUtils.mkdir_p(local_dir) unless File.exist?(local_dir)
1.step(7).each do |p|
  url = root_url + "?page=#{p}"
  doc = Nokogiri::HTML(open(url))
  doc.xpath('//*[@class="LyMain"]//p[@class="mdMTMWidget01ItemImg01View"]//a/@href').each do |node|
    img_doc = Nokogiri::HTML(open(node.value))
    img_doc.xpath('//*[@class="LyMain"]//p[@class="mdMTMEnd01Img01"]//a/@href').each do |img_node|
      img_content = open(img_node).read
      file_name = File.join(local_dir, File.basename(img_node))
      puts "Fetching #{img_node}"
      if File.exist?(file_name)
        puts "file was exists. #{file_name}"
        next
      end
      File.open(file_name, 'w') do |file|
        file.write(img_content)
      end
      puts "Success... #{file_name}"
    end
  end
end
