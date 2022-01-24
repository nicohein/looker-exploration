

view: ndt_product_sales {
  derived_table: {

    explore_source: aggregate_aware_base {

      column: category {}
      column: product {}
      column: sales_date {}
      column: territory {}
      column: total_sales_value {}
      # here it would be nice to also have bind_selection: yes
      # in addition controll over if the SND is a flat preselection or a group by wouble be helpful

    }
  }
  dimension: category {
    label: "Product Sales Category"
  }
  dimension: product {
    label: "Product Sales Product"
  }
  dimension: sales_date {
    label: "Product Sales Sales Date"
    type: date
  }
  dimension: territory {
    label: "Product Sales Territory"
  }
  dimension: total_sales_value {
    label: "Product Sales Sales Value"
    hidden: yes
    type: number
  }

  # one must be careful with averages in this scenatio or make sure all columns are included and every row is unique before the group by
  measure: total_total_sales_value {
    label: "total_sales_value"
    type: sum
    sql: ${total_sales_value} ;;
  }

}
