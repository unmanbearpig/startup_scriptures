module ApplicationHelper
  def set_title title
    content_for(:title) do
      title
    end
    content_tag(:h1, title)
  end
end
