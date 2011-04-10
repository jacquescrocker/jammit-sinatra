Gem::Specification.new do |s|
  s.name      = 'jammit-sinatra'
  s.version   = '0.6.0.1'

  s.homepage    = "http://documentcloud.github.com/jammit/"
  s.summary     = "Industrial Strength Asset Packaging for Sinatra/Padrino"
  s.description = <<-EOS
    Jammit is an industrial strength asset packaging library for Sinatra/Padrino,
    providing both the CSS and JavaScript concatenation and compression that
    you'd expect, as well as YUI Compressor and Closure Compiler compatibility,
    ahead-of-time gzipping, built-in JavaScript template support, and optional
    Data-URI / MHTML image embedding.
  EOS

  s.authors           = ['Jacques Crocker']
  s.email             = 'railsjedi@gmail.com'

  s.require_paths     = ['lib']

  s.add_dependency 'jammit',    '>= 0.6.0'

  s.files = Dir['lib/**/*', 'jammit-sinatra.gemspec', 'LICENSE', 'README.md']
end
