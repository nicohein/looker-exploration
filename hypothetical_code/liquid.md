# Liquid

This document contains a collection of hypothetical liquid that would increase or simplify the use of liquid syntax in Looker.

## Variables

While working on [sorting by row totals when hitting the row limit with pivot](/product_sales/sort_by_row_totals.md) I was looking for 

    `view_name.field_name._is_pivoted`


## Whitespace Control

I would also love whitespace control to be enabled https://jinja.palletsprojects.com/en/3.0.x/templates/#whitespace-control.
 

## Sets

While LookML already supports sets it wold be amazing if liquid syntax would allow to reference sets and allow a few operations on the same.


### Set Definition

If the set was not already defined in LookML:

    {% set field_list = [view_name.field_name_1, view_name.field_name_2] %}

The following predefined sets would be useful:

- `fields`
- `dimensions`
- `measures`
- `filters`
- `parameters`


### Set Operations

Given sets `a` and `b` the most needed and basic operations I can think of would be:

- `a|union(b)`
- `a|intersect(b)`
- `a|minus(b)` or `a|difference(b)`
- `a|intersection(b)`
- `a|contains(view_name.field_name)`
- `a|size`


### Loops 

Looping through sets of dimensions would allow to be much more flexible. 

For example to dynamically bind filters in SQL derived tables:

```lkml
WHERE 1=1
{% set exclude_dimensions = ['view_name.territory'] %}
{% for dimension in view_name.dimensions|minus(exclude_dimensions) %}
    {% if dimension._is_filtered %} AND {% condition dimension %} table_name.{% dimensions._field_name %} {% endcondition %} {% endif %}   
{% endfor %}
```
 
As the pseudocode in line 4 indicates, another set of field reference operations would become necessary.


## Custom Aggregate Awareness

The above function would also allow simple custom aggregate awareness (demonstrated only for one path) like the follwoing:

```lookml
view: view_a {

  # sql_table_name {

  sql_table_name:
    {% set rollup_1_fields = [view_a.a, view_a.b, view_a.c, view_a.d] %}
    {% set rollup_2_fields = [view_a.a, view_a.b, view_a.c, view_a.d, view_a.e, view_a.f] %}
    {% if rollup_1_fields|minus(fields)|size == 0 %}
      `rollup_1`
    {% elsif rollup_2_fields|minus(fields)|size == 0 %}
      `rollup_2`
    {% else %}
      `base_table`
    {% endif %} ;;
    
  # sql_table_name }
...
}    
```


### Field Reference Operations

Given that sets of field references contain full references to the fields, receiving the field name and view name from a field reference would be handy:

    field_reference._field_name
    field_reference._view_name

or if its not an attribute but an operator

    field_reference|field_name
    field_reference|view_name
