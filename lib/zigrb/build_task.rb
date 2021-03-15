require 'rake/tasklib'

module Zigrb
  class BuildTask < Rake::TaskLib
    attr_accessor :project

    def initialize(project)
      @project = project
      yield self if block_given?
      define
    end

    def define
      desc 'build'
      task 'build' do
        `zig build` && copy_native
      end

      desc 'copy_native'
      task 'copy_native' do
        copy_native
      end

      def build_path
        'zig-cache/lib/'
      end

      def native_lib
        "lib#{project}.so"
      end

      def native_path
        "lib/#{project}/#{project}.so"
      end

      def copy_native
        source = "#{build_path}/#{native_lib}"
        raise "native source doesn't exist, run `cargo_build` first; source=#{source}" unless File.exist?(source)
        FileUtils.mkdir_p(File.dirname(native_path))
        FileUtils.cp source, native_path
        true
      end
    end
  end
end
