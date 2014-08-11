require 'bundler/setup'
require 'benchmark'
require 'open-uri'
require 'aws'

file = nil

download = Benchmark.measure {
  file = Kernel.open('http://assis.ru/photo/1670322/BIG.jpg')
}

puts "download timing: #{download}"

s3 = AWS::S3.new(
  access_key_id: ENV['AWS_KEY'],
  secret_access_key: ENV['AWS_SECRET'])

bucket = s3.buckets['idinaiditesting']

bucket.objects['test/bench.jpg'].delete

upload = Benchmark.measure {
  bucket.objects['test/bench.jpg'].write(file.read, acl: :public_read)
}

puts "upload timing: #{upload}"
