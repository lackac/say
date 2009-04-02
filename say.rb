require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'extensions'

configure do
  set :espeak, "/usr/bin/espeak"
  set :say_tmp_path, Pathname.new(__FILE__).dirname.join("tmp", "cache")
end
configure :development do
  set :espeak, "/Users/LacKac/bin/espeak"
end

get %r{^/((?:mb/)?[^/]+)/(.*)$} do |voice, text|
  begin
    file = options.say_tmp_path.join(voice, "#{text.slugify}.wav")
    unless file.cleanpath.to_s.start_with?(options.say_tmp_path.cleanpath.to_s)
      raise RuntimeError, "Unreachable path"
    end
    unless File.exists?(file.to_s)
      FileUtils.mkdir_p(file.dirname.to_s)
      unless system %{#{options.espeak} -v #{voice} -w #{file} "#{text}"}
        raise RuntimeError, "Missing voice or other problem"
      end
    end
    headers(
      'Content-type' => 'audio/x-wav',
      'X-Sendfile' => file.realpath.to_s
    )
    ""
  rescue RuntimeError => e
    not_found(e.message)
  end
end
