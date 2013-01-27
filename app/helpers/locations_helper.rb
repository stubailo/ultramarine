module LocationsHelper
  def sortable(parameter, param_value = nil)
    param_value ||= parameter
    direction = (param_value == sort_column && sort_direction == "desc") ? "asc" : "desc"
    css_class = (param_value == sort_column) ? "current #{sort_direction}" : nil
    link_to parameter.titleize, {:sort => param_value, :direction => direction}, {:class => css_class}
  end
end
