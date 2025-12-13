# frozen_string_literal: true

# Just a simple way to inline SVG elements from files on the asset path.
#
# Caches loaded files in an instance variable, but this variable is only used
# within the module so even though not fully clean it shouldn't cause an issue.
module SVGHelper
  class SVGFileNotFoundError < StandardError; end

  def inline_svg_tag(path, options = {})
    path = Rails.root.join("app/assets/images/#{path}.svg")
    svg_file_content = svg_content(path)

    if options.any?
      doc = Nokogiri::XML::Document.parse(svg_file_content)
      svg = doc.at_css('svg')
      svg['height'] = options[:height] if options[:height]
      svg['width'] = options[:width] if options[:width]
      svg['class'] = options[:class] if options[:class]
      if options[:size]
        svg['width'] = options['size']
        svg['height'] = options['size']
      end
      svg_file_content = doc.to_html.strip
    end

    # We're loading this from a controlled file on disk, so we know what we're
    # doing here despite the disabled linting warning.
    raw svg_file_content # rubocop:disable Rails/OutputSafety
  end

  private

  def svg_content(path)
    content = (@svg_content ||= {})[path]
    return content if content.present?

    File.exist?(path) || raise(SVGFileNotFoundError, "SVG icon file does not exist: #{path}")
    @svg_content[path] = File.binread(path) # rubocop:disable Rails/HelperInstanceVariable
  end
end
