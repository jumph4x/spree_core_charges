class CoreChargesHooks < Spree::ThemeSupport::HookListener

  insert_bottom :admin_product_form_right do
    '<%= f.label :core_amount, t("core_amount") %> <br />
      <%= f.select :core_amount, [nil, 25.0, 50.0, 75.0, 100.0, 150.0, 200.0], :class => "text "  %>
      <%= f.error_message_on :core_amount %>'
  end
  
#  insert_after :cart_items do
#    '<%- if @order.core_charges.any? -%><div class="right charge"><h3><%= t("core_charge_total") -%>: <span class="price"><%= number_to_currency(@order.core_charges.map(&:amount).sum) -%></span></h3></div><%- end -%>'
#  end
end
