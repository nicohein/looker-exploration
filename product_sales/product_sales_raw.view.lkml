view: product_sales {
  derived_table: {
    sql: WITH product_sales AS (
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "US" as territory, 1000 as sales_value UNION ALL
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "UK" as territory, 500 as sales_value UNION ALL
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "DE" as territory, 100 as sales_value UNION ALL
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "US" as territory, 1500 as sales_value UNION ALL
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "UK" as territory, 400 as sales_value UNION ALL
        SELECT "wax knive" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "DE" as territory, 200 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-01-01") as sales_date, "US" as territory, 5000 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-01-01") as sales_date, "UK" as territory, 1000 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-01-01") as sales_date, "DE" as territory, 4000 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-02-01") as sales_date, "US" as territory, 1500 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-02-01") as sales_date, "UK" as territory, 4000 as sales_value UNION ALL
        SELECT "rubber bike" AS product, "vehicles" as category, DATE("2020-02-01") as sales_date, "DE" as territory, 2000 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-01-01") as sales_date, "US" as territory, 1000 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-01-01") as sales_date, "UK" as territory, 1500 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-01-01") as sales_date, "DE" as territory, 400 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-02-01") as sales_date, "US" as territory, 150 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-02-01") as sales_date, "UK" as territory, 400 as sales_value UNION ALL
        SELECT "foam chair" AS product, "furniture" as category, DATE("2020-02-01") as sales_date, "DE" as territory, 1500 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "US" as territory, 100 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "UK" as territory, 150 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-01-01") as sales_date, "DE" as territory, 800 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "US" as territory, 350 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "UK" as territory, 600 as sales_value UNION ALL
        SELECT "wire cup" AS product, "kitchen" as category, DATE("2020-02-01") as sales_date, "DE" as territory, 500 as sales_value
      )

      SELECT * FROM product_sales
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: sales_date {
    type: date
    datatype: date
    sql: ${TABLE}.sales_date ;;
  }

  dimension: territory {
    type: string
    sql: ${TABLE}.territory ;;
  }

  dimension: sales_value {
    hidden: yes
    type: number
    sql: ${TABLE}.sales_value ;;
  }

  measure: total_sales_value {
    type: sum
    label: "Sales Value"
    sql: ${sales_value} ;;
  }


  measure: dynamic_sales_value_for_territories {
    description: "A dimension containing the total sales value dynamically
    in pivot visualizations to allow sorting by a row total when the row limit of over 5000 rows is reached."
    type: number
    sql: SUM(SUM(${TABLE}.sales_value)) OVER (PARTITION BY
      {% if product._is_selected %} ${product}, {% endif %}
      {% if category._is_selected %} ${category}, {% endif %}
      {% if sales_date._is_selected %} ${sales_date}, {% endif %}
      -- {% if territory._is_selected %} ${territory}, {% endif %}  # manually excluding the dimension that will be pivoted by
      1 -- helper
    )
    ;;
  }

  set: detail {
    fields: [product, category, sales_date, territory, sales_value]
  }
}
