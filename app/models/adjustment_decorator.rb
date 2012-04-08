Spree::Adjustment.class_eval do 
  scope :core, lambda { where('label like ?',"#{I18n.t(:core_charge)}%") }
end
