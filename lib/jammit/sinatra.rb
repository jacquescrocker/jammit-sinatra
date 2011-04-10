require 'jammit'
require 'jammit/middleware'
require 'jammit/sinatra/helpers'

# provides hook so you can run
# register Jammit in your
module Jammit
  def self.registered(app)
    app.helpers Jammit::Sinatra::Helpers
    app.use Jammit::Middleware

    # reload assets after every request (on development only)
    if app.development?
      app.before { Jammit.reload! }
    end
  end
end

if defined?(Padrino)
  Padrino.after_load do
    # currently need to set RAILS_ENV for jammit (pretty dumb)
    ::RAILS_ENV = PADRINO_ENV
    Jammit.load_configuration("#{Padrino.root}/config/assets.yml")
  end
end