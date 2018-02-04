class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def settings
    Setting.first
  end
end
