Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "core_charges_admin_product_form_right",
                     :insert_bottom => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                     :partial => "admin/products/core_amount_fields",
                     :disabled => false)
