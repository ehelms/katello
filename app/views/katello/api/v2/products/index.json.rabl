node(:total) { @collection[:total] }
node(:subtotal) { @collection[:subtotal] }

node :records do
  partial("katello/api/v2/products/show", :object => @collection[:records])
end
