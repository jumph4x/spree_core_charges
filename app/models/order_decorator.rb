Spree::Order.class_eval do

  has_many :core_charges,
           :dependent => :destroy,
           #:class_name => 'Spree::Adjustment',
           :conditions => "source_type='Spree::LineItem'"
  
end
