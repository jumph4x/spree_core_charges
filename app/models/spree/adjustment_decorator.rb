Spree::Adjustment.class_eval do 
  scope :core, lambda { where('label like ?',"#{Spree.t(:core_charge)}%") }
  scope :not_core, lambda { where('label not like ?',"#{Spree.t(:core_charge)}%") }
end
