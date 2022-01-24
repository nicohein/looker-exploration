include: "product_sales_raw.view.lkml"

explore: aggregate_aware_base {
  from: product_sales
  group_label: "Exploration"
  label: "Aggregate Aware Base Explore"
  view_label: "Product Sales"

  aggregate_table: rollup__quick_table_1 {
    query: {
      dimensions: [
        aggregate_aware_base.product,
        aggregate_aware_base.category,
        aggregate_aware_base.sales_date
      ]
      measures: [
        aggregate_aware_base.total_sales_value
      ]
      filters: [
        aggregate_aware_base.territory: "US"
      ]
    }
    materialization: {
      persist_for: "90 minutes"
    }
  }

  aggregate_table: rollup__quick_table_2 {
    query: {
      dimensions: [
        aggregate_aware_base.product,
        aggregate_aware_base.territory
      ]
      measures: [
        aggregate_aware_base.total_sales_value
      ]
      filters: []
    }

    materialization: {
      persist_for: "90 minutes"
    }

  }
}
