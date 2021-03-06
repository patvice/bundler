module Spec
  module Platforms
    include Bundler::GemHelpers

    def rb
      Gem::Platform::RUBY
    end

    def mac
      Gem::Platform.new("x86-darwin-10")
    end

    def java
      Gem::Platform.new([nil, "java", nil])
    end

    def linux
      Gem::Platform.new(["x86", "linux", nil])
    end

    def mswin
      Gem::Platform.new(["x86", "mswin32", nil])
    end

    def mingw
      Gem::Platform.new(["x86", "mingw32", nil])
    end

    def x64_mingw
      Gem::Platform.new(["x64", "mingw32", nil])
    end

    def all_platforms
      [rb, java, linux, mswin, mingw, x64_mingw]
    end

    def local
      generic(Gem::Platform.local)
    end

    def not_local
      all_platforms.find { |p| p != generic(Gem::Platform.local) }
    end

    def local_tag
      if RUBY_PLATFORM == "java"
        :jruby
      else
        :ruby
      end
    end

    def not_local_tag
      [:ruby, :jruby].find { |tag| tag != local_tag }
    end

    def local_ruby_engine
      ENV["BUNDLER_SPEC_RUBY_ENGINE"] || (defined?(RUBY_ENGINE) ? RUBY_ENGINE : "ruby")
    end

    def local_engine_version
      return ENV["BUNDLER_SPEC_RUBY_ENGINE_VERSION"] if ENV["BUNDLER_SPEC_RUBY_ENGINE_VERSION"]

      case local_ruby_engine
      when "ruby"
        RUBY_VERSION
      when "rbx"
        Rubinius::VERSION
      when "jruby"
        JRUBY_VERSION
      else
        raise BundlerError, "That RUBY_ENGINE is not recognized"
        nil
      end
    end

    def not_local_engine_version
      case not_local_tag
      when :ruby
        not_local_ruby_version
      when :jruby
        "1.6.1"
      end
    end

    def not_local_ruby_version
      "1.12"
    end

    def not_local_patchlevel
      9999
    end
  end
end
