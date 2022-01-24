include: "ndt_product_sales.view.lkml"

explore: ndt_aggregate_aware {
  from: ndt_product_sales
  group_label: "Exploration"
  label: "NDT Aggregate Aware"
  view_label: "Product Sales"


  # imagine a join be placed here

}
