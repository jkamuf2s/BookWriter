module ApplicationHelper
  include ConversationsHelper

  def user_books
    current_user.books
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class, :remote => true}
  end

  def checkbox_value_to_boolean(value)
    value == '1'
  end

end
