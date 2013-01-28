module LocationsHelper
  def sortable(parameter, param_value = nil)
    param_value ||= parameter
    direction = (param_value == sort_column && sort_direction == "desc") ? "asc" : "desc"
    css_class = (param_value == sort_column) ? "current #{sort_direction}" : nil
    content = parameter.titleize + "<i class='icon-caret-down'></i>" + "<i class='icon-caret-up'></i>"
    link_to content.html_safe, {:sort => param_value, :direction => direction, :hide => params[:hide]}, {:class => css_class}
  end
end
