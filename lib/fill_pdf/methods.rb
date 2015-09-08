module FillPdf
  class Fill
    attr_accessor :pdftk, :template, :attributes, :dictionary, :logger

    # Template is path of a pdf file
    #
    def initialize(template, dictionary={})
      @attributes = {}
      @template = template
      @dictionary = dictionary

      # adjust the pdftk path to suit your pdftk installation
      # add :data_format => 'XFdf' option to generate XFDF instead of FDF when
      # filling a form (XFDF is supposed to have better support for non-western
      # encodings)
      # add :utf8_fields => true in order to get UTF8 encoded field metadata (this
      # will use dump_data_fields_utf8 instead of dump_data_fields in the call to
      # pdftk)
      @pdftk = PdfForms.new(utf8_fields: true)
    end

    # Return list of template fields in array
    #
    def template_field_names
      pdftk.get_field_names template
    end

    # Populate all pdf fields with values.
    #
    def populate
      @attributes = {}
      template_field_names.each do |field|
        set(field, value(field).to_s)
      end
      @attributes
    end

    def generate
      populate
      tmp = Tempfile.new('pdf_generated-fillpdf')
      pdftk.fill_form template, tmp.path, attributes, :flatten => true
      tmp
    end

    # This method populate attributes with data based on template fields.
    #
    # Generate document path.
    #
    # Create new document and return path of this document.
    #
    def export(path = nil)
      pathname = output_path(path)
      populate
      pdftk.fill_form template, pathname, attributes, :flatten => true
      pathname
    end

    def to_blob
      generate.read
    end

    def blob_join_with(blob)
      blober(join_with(blob))
    end

    def join_with(blob, path = nil)
      pathname = output_path(path)

      document = if defined? Rails
        Rails.root.join(dirname, "#{SecureRandom.uuid}.pdf")
      else
        File.join(dirname, "#{SecureRandom.uuid}.pdf")
      end

      pdf = CombinePDF.new
      pdf << CombinePDF.parse(to_blob)
      pdf << CombinePDF.parse(blob)
      pdf.save document
      document
    end

    protected
      # This method defines the output_path
      #
      def output_path(path = nil)
        unless path.nil?
          pathname = path
        else
          if defined?(Rails)
            output_path = Rails.application.config.fill_pdf.output_path || "tmp"
            pathname = Rails.root.join(output_path, "#{SecureRandom.uuid}.pdf")
          end
        end
        raise 'No path given for export.' if pathname.nil?
        pathname
      end

      # Based on dictionary this methods return value of fields
      #
      def value(field)
        dictionary[field.to_sym] || dictionary[field.to_s] rescue nil
      end

      # This methods is setter for used to set field value
      #
      def set(attribute, value = nil)
        attributes[attribute.to_s] = value
      end
  end
end
