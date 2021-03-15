require 'benchmark/ips'

require 'uuid'
require 'securerandom'

$: << '../lib'
require 'hello'

Benchmark.ips do |x|
  x.report("zig-uuid:")   { Hello.new.uuid }
  x.report("SecureRandom:") { SecureRandom.uuid }
  x.report("uuid:") { uuid = UUID.new; uuid.generate }

  x.compare!
end
