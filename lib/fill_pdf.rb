require 'fill_pdf/railtie' if defined? Rails
include ActionView::Helpers::NumberHelper if defined? Rails
require 'fill_pdf/methods'

module FillPdf
  require 'pdf_forms'
  require 'combine_pdf'
end
