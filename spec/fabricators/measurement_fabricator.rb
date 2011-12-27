Fabricator(:measurement) do
  product!
  name "depth"
  value 1.0001
  unit "MM"
end

Fabricator(:net_content_measurement, from: :measurement) do
  name "net_content"
  value 300
  unit "ML"
end