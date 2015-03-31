module FactoryGirl::Syntax::Methods
  def find_or_create(name, attributes = {}, &block)
    klass   = FactoryGirl.factory_by_name(name).build_class
    attributes = FactoryGirl.attributes_for(name).merge(attributes)
    find_attributes = attributes.select { |attribute| klass.attribute_names.include? attribute }

    klass.where(find_attributes, &block).first || FactoryGirl.create(name, attributes, &block)
  end
end
