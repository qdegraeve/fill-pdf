module FillPdf

  class Railtie < Rails::Railtie

    # This defines configuration items meant to be overriden
    # in the client application.rb file.
    config.fill_pdf = ActiveSupport::OrderedOptions.new

    # This is required for output path
    config.fill_pdf.output_path = ''
    config.fill_pdf.pdftk_path = '/usr/bin/pdftk'
  end
end
