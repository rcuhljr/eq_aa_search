require 'net/http'

class AALoader
  URI_FORMAT = 'http://eqaasearch.org/aainfo.asp?search_fd4=%3C=100&search_fd12='
  FILE_FORMAT = "%s.aas"
  attr_accessor :eqclass, :aa_list

  def initialize(eqclass)
    self.eqclass = eqclass
    @file_name = FILE_FORMAT % [eqclass]
    @uri = URI(URI_FORMAT + eqclass)
    @aa_list = {}
    load
  end  
  
  def load
    if File.exists?(@file_name)
      load_file
    else
      load_uri 
      save_file
    end
  end

  def load_file
    File.open(@file_name) do |file|
      @aa_list = Marshal.load(file)
    end
  end

  def save_file
    File.open(@file_name, 'w') do |file|
      Marshal.dump(@aa_list, file)
    end
  end

  def load_uri
    data = raw_data page_body
    data.split(eqclass).each {|aa_data| add aa_data}
  end

  def add(data)
    items = data.scan(/>([^<]+)</).flatten
    (@aa_list[items[3]] ||= []) << {:level => items[3], :name => items[0], :rank => items[1], :cost => items[2], :prereqs => items[8], :text => items[9]}    
  end

  def page_body
    Net::HTTP.post_form(@uri, 'Page_Size' => '3000').body
  end

  def raw_data(body)
    body = body[(body =~ /tr class="TrOdd AAInfo_1_OddDataText"/)..-1]
    body[0..(body =~ /\r\n/)]
  end
end