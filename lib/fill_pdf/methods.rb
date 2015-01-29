module FillPdf
  class Fill
    attr_accessor :pdftk, :template, :attributes, :dictionary, :object
    
    def initialize(template, object=nil, dictionary={})
      @attributes = {}
      @object = object
      @template = template
      @dictionary = dictionary
      @pdftk = PdfForms.new(Rails.application.config.fill_pdf.pdftk_path)
    end

    def template_field_names #Return templates fiels list in array
      pdftk.get_field_names template
    end

    def populate #object must be binding
      template_field_names.each do |field|
        set(field, dictionary[field.to_s])
      end
    end

    def export
      dirname = Rails.application.config.fill_pdf.output_path
      Dir.mkdir(dirname) unless File.directory?(dirname)

      populate # This method populate attributes with data based on template fields

      document =  Rails.root.join(dirname, "#{SecureRandom.uuid}.pdf") #Generate document path

      pdftk.fill_form template, document, attributes, :flatten => true # Creation of document. Populate with data
      
      document
    rescue Exception => exception
      logger exception
    end
    protected
      def logger(exception)
        Rails.logger.warn "------------An error occurred: -------------"
        Rails.logger.warn exception
        Rails.logger.warn "--------------------------------------------"
        false
      end

      def set(attribute, value=nil)
        attributes[attribute.to_s] = value
      end
  end
end
