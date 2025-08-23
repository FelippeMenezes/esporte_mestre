module MarketsHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"

    # Add an arrow icon to the currently sorted column header
    icon = ""
    if column == sort_column
      icon = sort_direction == "asc" ? " <i class='fas fa-sort-up'></i>" : " <i class='fas fa-sort-down'></i>"
    end

    link_to((title + icon).html_safe, { sort: column, direction: direction }, { class: "text-decoration-none" })
  end
end