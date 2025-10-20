module MarketsHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"

    link_to((title).html_safe, { sort: column, direction: direction }, { class: "text-decoration-none" })
  end
end