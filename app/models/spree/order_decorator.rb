Spree::Order.class_eval do

  # Called each time an orderis updated
  def create_core_charges
    to_keep, to_destroy = adjustments.core.partition{|x| x.originator and x.originator.eligible?}
    to_destroy.each(&:delete)
    core_variant_ids = to_keep.map{|x| x.originator.variant_id }

    Spree::Adjustment.skip_callback :save, :after, :update_adjustable

    line_items.each do |li|
      next unless li.product.core_amount # The product has no core charge associated with it
      next if core_variant_ids.include? li.variant_id # The charge for this line item already exists

      new_core_charge = Spree::Adjustment.new
      new_core_charge.label = "#{Spree.t(:core_charge)} [#{li.variant.sku}]"
      new_core_charge.source = li
      new_core_charge.adjustable = self
      new_core_charge.originator = li
      new_core_charge.amount = li.calculate_core_charge
      new_core_charge.eligible = true

      new_core_charge.save
    end

    Spree::Adjustment.set_callback :save, :after, :update_adjustable

    update_totals

    update_attributes_without_callbacks({
      :adjustment_total => adjustment_total,
      :total => total
    })
  end

end
