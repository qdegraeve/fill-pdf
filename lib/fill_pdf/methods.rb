module FillPdf
  class Fill
    # Fill class attributes
    attr_accessor :pdftk, :template, :attributes, :dictionary, :object
    
    # Template is path of a pdf file
    #
    # Object is object used to populate pdf field. This must be binding
    #
    # dictionary is used for correspondence in pdf fields with binding elements
    #
    def initialize(template, object=nil, dictionary={})
      @attributes = {}
      @object = object
      @template = template
      @dictionary = dictionary
      @pdftk = PdfForms.new(Rails.application.config.fill_pdf.pdftk_path)
    end

    # Return list of template fields in array
    #
    def template_field_names
      pdftk.get_field_names template
    end

    # Populate attributes with values
    #
    def populate
      @attributes = {}
      template_field_names.each do |field|
        set(field, return_value(field).to_s)
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
      dirname = Rails.application.config.fill_pdf.output_path
      Dir.mkdir(dirname) unless File.directory?(dirname)

      populate

      document = Rails.root.join(dirname, "#{SecureRandom.uuid}.pdf")

      pdftk.fill_form template, document, attributes, :flatten => true
      
      document
    rescue Exception => exception
      logger exception
    end

    protected
      # Based on dictionary this methods use object to return value
      #
      def return_value(field)
        hash = dictionary[field.to_sym] || dictionary[field.to_s]
        value = hash[:value] || hash["value"] rescue nil
        format = hash[:format] || hash["format"] rescue nil
        case format
        when 'currency'
          number_to_currency(object.eval(value).to_i, precision: 0, unit: "Euro") rescue nil
        when 'date'
          I18n.l(object.eval(value).to_date) rescue nil
        else
          object.eval(value) rescue nil
        end
      end

      # Logger is a method used for log exceptions
      #
      def logger(exception)
        Rails.logger.warn "------------An error occurred: -------------"
        Rails.logger.warn exception
        Rails.logger.warn "--------------------------------------------"
        false
      end

      # This methods is setter for plugin attrinute named attributes
      # 
      def set(attribute, value=nil)
        attributes[attribute.to_s] = value
      end
  end
end
