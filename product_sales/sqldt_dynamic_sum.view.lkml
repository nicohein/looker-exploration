view: sqldt_dynamic_sum {
  derived_table: {
    sql:
      SELECT
        {% if sort_by_row_totals.product._is_selected and is_product_pivot._parameter_value == "false" %} dynamic_sales.product, {% endif %}
        {% if sort_by_row_totals.category._is_selected and is_category_pivot._parameter_value == "false" %} dynamic_sales.category, {% endif %}
        {% if sort_by_row_totals.sales_date._is_selected and is_sales_date_pivot._parameter_value == "false" %} dynamic_sales.sales_date, {% endif %}
        {% if sort_by_row_totals.territory._is_selected and is_territory_pivot._parameter_value == "false" %} dynamic_sales.territory, {% endif %}
        1 as helper,
        SUM(dynamic_sales.sales_value) as sales_value,
      FROM
        product_sales as dynamic_sales
      WHERE
        {% if sort_by_row_totals.product._is_filtered %} AND {% condition sort_by_row_totals.product %} dynamic_sales.product, {% endcondition %} {% endif %}
        {% if sort_by_row_totals.category._is_filtered %} AND {% condition sort_by_row_totals.category %} dynamic_sales.category, {% endcondition %} {% endif %}
        {% if sort_by_row_totals.sales_date._is_filtered %} AND {% condition sort_by_row_totals.sales_date %} dynamic_sales.sales_date, {% endcondition %} {% endif %}
        {% if sort_by_row_totals.territory._is_filtered %}  AND {% condition sort_by_row_totals.territory %} dynamic_sales.territory, {% endcondition %} {% endif %}
        1=1
        -- adding filters for all dimensions we want to filter by
      GROUP BY
        {% if sort_by_row_totals.product._is_selected and is_product_pivot._parameter_value == "false"  %} dynamic_sales.product, {% endif %}
        {% if sort_by_row_totals.category._is_selected and is_category_pivot._parameter_value == "false" %} dynamic_sales.category, {% endif %}
        {% if sort_by_row_totals.sales_date._is_selected and is_sales_date_pivot._parameter_value == "false" %} dynamic_sales.sales_date, {% endif %}
        {% if sort_by_row_totals.territory._is_selected and is_territory_pivot._parameter_value == "false" %} dynamic_sales.territory, {% endif %}
        helper
      -- the following lines speed up the query but they also result in limited outcome
      ORDER BY sales_value DESC
      LIMIT {% parameter top_x %}
       ;;
  }

  parameter: top_x {
    default_value: "2"
    type: number
  }

  # in an ideal world a liquid reference .is_pivoted makes this obsolete
  parameter: is_product_pivot{
    default_value: "no"
    type: yesno
  }

  parameter: is_category_pivot{
    default_value: "no"
    type: yesno
  }

  parameter: is_sales_date_pivot{
    default_value: "no"
    type: yesno
  }

  parameter: is_territory_pivot{
    default_value: "no"
    type: yesno
  }

  dimension: product {
    hidden: yes
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: category {
    hidden: yes
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: sales_date {
    hidden: yes
    type: date
    datatype: date
    sql: ${TABLE}.sales_date ;;
  }

  dimension: territory {
    hidden: yes
    type: string
    sql: ${TABLE}.territory ;;
  }

  dimension: sales_value {
    label: "Sort Dimension"
    type: number
    sql: ${TABLE}.sales_value ;;
  }


}
