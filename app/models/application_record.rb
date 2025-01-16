class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  class << self
    def allowed_attributes(extras = [])
      self.new.attributes.keys.map(&:to_sym) + extras
    end
  end
end
