module FillPdf
  class Railtie < Rails::Railtie

    # This defines configuration items meant to be overriden
    # in the client application.rb file.
    config.fill_pdf = ActiveSupport::OrderedOptions.new

  end
end
