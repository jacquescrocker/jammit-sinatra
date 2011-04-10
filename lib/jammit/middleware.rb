module Jammit

  # Rack Middle that allows Jammit to integrate with any Rack compatible web
  # framework.  It takes responsibility for /assets, and dynamically packages
  # any missing or uncached asset packages.

  class Middleware

    VALID_FORMATS   = [:css, :js]

    SUFFIX_STRIPPER = /-(datauri|mhtml)\Z/

    NOT_FOUND_PATH  = "#{PUBLIC_ROOT}/404.html"

    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      if matches = %r(^/#{Jammit.package_path}/(.*)\.(.*)).match(env['PATH_INFO'])
        package(matches[1].to_s, matches[2] || "none")
      else
        @app.call(env)
      end
    end

    private

    # The "package" action receives all requests for asset packages that haven't
    # yet been cached. The package will be built, cached, and gzipped.
    def package(package, extension)
      parse_request(package, extension)
      template_ext = Jammit.template_extension.to_sym
      result = []

      headers = {
        'Cache-Control' => "public, max-age=#{(60*60*24*365.25*10).to_i}",
        'Expires' => (Time.now + 60*60*24*365.25*10).httpdate
      }

      case @extension
      when :js
        @contents = Jammit.packager.pack_javascripts(@package)
        @contents = @contents.to_js if @contents.respond_to?(:to_js)
        result = [
          200,
          headers.merge({
            'Content-Type' => Rack::Mime.mime_type(".js")
          }),
          [@contents]
        ]
      when template_ext
        @contents = Jammit.packager.pack_templates(@package)
        @contents = @contents.to_js if @contents.respond_to?(:to_js)
        [
          200,
          headers.merge({
            'Content-Type' => Rack::Mime.mime_type(".js")
          }),
          [@contents]
        ]
      when :css
        [
          200,
          headers.merge({
            'Content-Type' => Rack::Mime.mime_type(".css")
          }),
          [generate_stylesheets]
        ]
      end
    rescue Jammit::PackageNotFound
      [404, {'Content-Type' => 'text/plain'}, ['Not found']]
    end

    # Generate the complete, timestamped, MHTML url -- if we're rendering a
    # dynamic MHTML package, we'll need to put one URL in the response, and a
    # different one into the cached package.
    def prefix_url(path)
      host = request.port == 80 ? request.host : request.host_with_port
      "#{request.protocol}#{host}#{path}"
    end

    # If we're generating MHTML/CSS, return a stylesheet with the absolute
    # request URL to the client, and cache a version with the timestamped cache
    # URL swapped in.
    def generate_stylesheets
      return @contents = Jammit.packager.pack_stylesheets(@package, @variant) unless @variant == :mhtml
      @mtime      = Time.now
      request_url = prefix_url(request.fullpath)
      cached_url  = prefix_url(Jammit.asset_url(@package, @extension, @variant, @mtime))
      css         = Jammit.packager.pack_stylesheets(@package, @variant, request_url)
      # @contents   = css.gsub(request_url, cached_url) if perform_caching
      css
    end

    # Extracts the package name, extension (:css, :js), and variant (:datauri,
    # :mhtml) from the incoming URL.
    def parse_request(pack, extension)
      @extension = extension.to_sym
      raise PackageNotFound unless (VALID_FORMATS + [Jammit.template_extension.to_sym]).include?(@extension)
      if Jammit.embed_assets
        suffix_match = pack.match(SUFFIX_STRIPPER)
        @variant = Jammit.embed_assets && suffix_match && suffix_match[1].to_sym
        pack.sub!(SUFFIX_STRIPPER, '')
      end
      @package = pack.to_sym
    end

  end
end