module ApplicationHelper
  def set_title title
    content_for(:title) do
      title
    end

    if block_given?
      yield(title)
    else
      content_tag(:h1, title)
    end
  end
end
