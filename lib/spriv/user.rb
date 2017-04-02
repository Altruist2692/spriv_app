module Spriv
  class User
    BASE_URI = 'https://m.spriv.com/wsM5.asmx/'

    def method_missing(m, *args, &block)
      begin
        sub_path = m.to_s.humanize.titleize.strip.gsub(/\s+/, '')
        uri = URI(BASE_URI + sub_path)
        res = Net::HTTP.post_form(uri, args[0])
        JSON.parse(res.body)
      rescue Exception => e
        { message: e.message }
      end
    end
  end
end
