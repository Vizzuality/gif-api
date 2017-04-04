module Downcaseable
  extend ActiveSupport::Concern
  included do
    before_save :downcase_name
  end
  def downcase_name
    self.name = name.downcase
  end
end