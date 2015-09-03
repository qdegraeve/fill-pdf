module FillPdf
  class Fill
    attr_accessor :pdftk, :template, :attributes, :dictionary, :logger

    # Template is path of a pdf file
    #
    def initialize(template, dictionary={})
      @dirname = Rails.application.config.fill_pdf.output_path if defined? Rails

      @attributes = {}
      @template = template
      @dictionary = dictionary
      @pdftk = PdfForms.new(Utilities.which('pdftk'))
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

    # This method populate attributes with data based on template fields.
    #
    # Generate document path.
    #
    # Create new document and return path of this document.
    #
    def export(output_directory = nil)
      dirname = output_directory || @dirname

      # Create directory used for store documents
      Dir.mkdir(dirname) unless File.directory?(dirname)

      #call method populate to set field with value.
      populate

      # Generate Path of document
      document = if defined? Rails
        Rails.root.join(dirname, "#{SecureRandom.uuid}.pdf")
      else
        File.join(dirname, "#{SecureRandom.uuid}.pdf")
      end

      # Generate document
      pdftk.fill_form template, document, attributes, :flatten => true

      # Return path of document
      document
    end

    def to_blob
      blober(export)
    end

    def blober(file)
      blob = file.read
      File.unlink file rescue nil
      blob
    end

    def blob_join_with(blob)
      blober(join_with(blob))
    end

    def join_with(blob, output_directory = nil)
      dirname = output_directory || @dirname

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
