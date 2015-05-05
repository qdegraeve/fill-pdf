module FillPdf
  class Fill
    attr_accessor :pdftk, :template, :attributes, :dictionary, :dirname

    # Template is path of a pdf file
    #
    def initialize(template, dictionary={})
      @attributes = {}
      @template = template
      @dictionary = dictionary
      @dirname = Rails.application.config.fill_pdf.output_path
      @pdftk = PdfForms.new(Rails.application.config.fill_pdf.pdftk_path)
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
    def export
      # Create directory used for store documents
      Dir.mkdir(@dirname) unless File.directory?(@dirname)

      #call method populate to set field with value.
      populate

      # Generate Path of document
      document = Rails.root.join(dirname, "#{SecureRandom.uuid}.pdf")

      # Generate document
      pdftk.fill_form template, document, attributes, :flatten => true

      # Return path of document
      document
    rescue Exception => exception
      logger exception
    end

    def to_blob
      document = export
      blob = document.read
      File.unlink document rescue nil
      blob
    end

    protected
      # Based on dictionary this methods return value of fields
      #
      def value(field)
        dictionary[field.to_sym] || dictionary[field.to_s] rescue nil
      end

      # Logger is a method used for log exceptions
      #
      def logger(exception)
        Rails.logger.warn "------------An error occurred: -------------"
        Rails.logger.warn exception
        Rails.logger.warn "--------------------------------------------"
        false
      end

      # This methods is setter for used to set field value
      #
      def set(attribute, value=nil)
        attributes[attribute.to_s] = value
      end
  end
end
