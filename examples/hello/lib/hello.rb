# frozen_string_literal: true

require_relative "hello/version"
require_relative "hello/hello"

class Hello
  class Error < StandardError; end
  # Your code goes here...

  def self.reload!
    Object.send(:remove_const, :Hello)
    GC.start(full_mark: true, immediate_sweep: true)
    if $LOADED_FEATURES.grep /hello.so/
      $LOADED_FEATURES.delete_if { |x| x =~ /hello.so/ }
      $LOADED_FEATURES.delete_if { |x| x =~ /hello.rb/ }
      require 'hello/hello'
      require 'hello'
    end
  end
end
