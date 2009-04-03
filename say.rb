require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'extensions'
require 'iconv'

configure do
  set :espeak, "/usr/bin/espeak"
  set :say_tmp_path, Pathname.new(__FILE__).dirname.join("tmp", "cache")
  set :allowed_chars, ['a'..'z', 'A'..'Z', '0'..'9', ',', '.', '?', '!', String::ACCENTS].map {|r| Array(r)}.flatten
end
configure :development do
  set :espeak, "/Users/LacKac/bin/espeak"
end

get %r{^/([a-z-]+)/(.*)$} do |voice, text|
  begin
    text = text.scan(/./u).map do |c|
      options.allowed_chars.include?(c) ? c : ' '
    end.join("").strip.squeeze
    file = options.say_tmp_path.join(voice, "#{text.slugify}.wav")
    unless file.cleanpath.to_s.start_with?(options.say_tmp_path.cleanpath.to_s)
      raise RuntimeError, "Unreachable path"
    end
    unless File.exists?(file.to_s)
      FileUtils.mkdir_p(file.dirname.to_s)
      encoding = voice =~ /hu/ ? 'latin2' : 'latin1'
      latin_text = Iconv.iconv(encoding, 'utf8', text)
      unless system %{#{options.espeak} -v #{voice} -w #{file} "#{latin_text}"}
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
