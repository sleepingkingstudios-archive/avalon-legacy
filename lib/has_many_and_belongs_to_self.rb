module ActiveRecordExtension
  :private
  def has_many_and_belongs_to_self(singular_assoc, plural_assoc, options = {})
    class_name = self.class.to_s
    key = options[:foreign_key] || "#{class_name.downcase}_id"
    
    options[:class_name] => class_name
    has_many plural_assoc, options
    
    # define singlular association methods
    self.define_method singular_assoc do
      return self.class.find self.send(key)
    end # association
    
    self.define_method "#{singular_assoc}=" do |record|
      # remove any existing parent/child relationships
      self.
    end # association=
  end # method has_many_and_belongs_to_self
end # module ActiveRecordExtension