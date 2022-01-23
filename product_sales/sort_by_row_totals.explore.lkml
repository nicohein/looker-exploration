include: "product_sales_raw.view.lkml"
include: "sqldt_dynamic_sum.view.lkml"

explore: sort_by_row_totals {
  from: product_sales
  group_label: "Exploration"
  label: "Product Sales with dynamic Sum"
  view_label: "Product Sales"

  # due to the dynamic nature of the where clause in the join its obvious that it should take place only afer the aggregate aware
  join: sqldt_dynamic_sum {
    view_label: "Dynamic Sum"
    type: left_outer
    relationship: many_to_one
    sql_on: 1=1
      {% if sort_by_row_totals.product._is_selected and sqldt_dynamic_sum.is_product_pivot._parameter_value == "false" %} AND ${sort_by_row_totals.product} = ${sqldt_dynamic_sum.product} {% endif %}
      {% if sort_by_row_totals.category._is_selected and sqldt_dynamic_sum.is_category_pivot._parameter_value == "false" %} AND ${sort_by_row_totals.category} = ${sqldt_dynamic_sum.category} {% endif %}
      {% if sort_by_row_totals.sales_date._is_selected and sqldt_dynamic_sum.is_sales_date_pivot._parameter_value == "false" %} AND ${sort_by_row_totals.sales_date} = ${sqldt_dynamic_sum.sales_date} {% endif %}
      {% if sort_by_row_totals.territory._is_selected and sqldt_dynamic_sum.is_territory_pivot._parameter_value == "false" %} AND ${sort_by_row_totals.territory} = ${sqldt_dynamic_sum.territory} {% endif %}
    ;;
  }
}
