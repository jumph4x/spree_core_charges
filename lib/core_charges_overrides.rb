Deface::Override.new(:virtual_path => "admin/products/_form",
                     :name => "converted_admin_product_form_right",
                     :insert_bottom => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                     :text => "<%= f.label :core_amount, t(\"core_amount\") %> <br />
                               <%= f.select :core_amount, [nil, 25.0, 50.0, 75.0, 100.0, 150.0, 200.0, 300.0], :class => \"text \"  %>
                               <%= f.error_message_on :core_amount %>",
                     :disabled => false)
