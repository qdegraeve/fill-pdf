require 'fill_pdf/railtie' if defined? Rails
include ActionView::Helpers::NumberHelper if defined? Rails

require 'pdf_forms'
require 'combine_pdf'

require 'fill_pdf/methods'

module FillPdf
end
