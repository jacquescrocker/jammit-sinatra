require 'jammit'
require 'jammit/middleware'

# allows use to include jammit/helper without exploding
module ActionView
  class Base
  end
end
require 'jammit/helper'

module Jammit::HelperOverrides
  def javascript_include_tag(*sources)
    super(*sources.flatten)
  end

  def stylesheet_link_tag(*sources)
    super(*sources.flatten)
  end
end

# provides hook so you can run
# register Jammit in your
module Jammit
  def self.registered(app)
    app.helpers Jammit::Helper
    app.helpers Jammit::HelperOverrides

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