require 'bundler/setup'
Bundler.require

Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'],
                                    ENV['AWS_SECRET_ACCESS_KEY'])
})

def save_bills(s3, regexp)
  s3.list_objects(bucket: ENV['BUCKET']).contents.each do |object|
    next unless object.key.index(regexp)
    o = s3.get_object(bucket: ENV['BUCKET'], key: object.key)
    File.open(object.key, "wb+"){|f| f.write o.body.read }
  end
end

s3 = Aws::S3::Client.new
save_bills(s3, /aws-billing-csv/)

filename = Dir.glob('*aws-billing-csv-*.csv').first

unless filename
  puts "no billing csv"
  exit 1
end

csv = SmarterCSV.process(filename)
total = csv.find{|row| row[:recordtype] == 'StatementTotal' }

costs = csv.select{|row| row[:totalcost] && row[:totalcost] > 0 }
def msg_line(f)
  "$#{'%.2f' % f[:totalcost]} [#{f[:productcode]}] #{f[:usagetype]}: #{f[:usagequantity]} (#{f[:itemdescription]})"
end

billing_url = "https://console.aws.amazon.com/billing/home?region=ap-northeast-1/"

msg = "[#{total[:billingperiodenddate].to_s.scan(/\d\d\d\d\/\d\d\/\d\d/).first} 〆の月額利用料](#{billing_url}) = "
msg << "$#{total[:totalcost]} (cost: $#{total[:costbeforetax]}, credits: #{total[:credits].to_s.gsub(/^-/, '-$')})\n"
msg << costs.map{|field| msg_line(field) }.join("\n")

notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
notifier.ping msg
