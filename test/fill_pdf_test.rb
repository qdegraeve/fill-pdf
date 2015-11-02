require 'test_helper'

class FillPdfTest < ActiveSupport::TestCase
  def setup
    @template_path = Rails.application.root.join('public', 'pdf_templates', 'pdf_file.pdf')
    @document = FillPdf::Fill.new(@template_path, {})
  end

  test "returns the template field names" do
    assert_equal @document.template_field_names.length, 65
  end

  test "populates pdf fields with values" do
    # TODO
  end

  test "create new document and return path of this document" do
    # TODO
  end
end
