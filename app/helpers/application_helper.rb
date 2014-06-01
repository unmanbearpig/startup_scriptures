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

  def render_link link, options = {}
    default_options = {
      link: link,
      buttons: true,
      type: :small,
      category: false,
      author: true
    }

    opts = default_options.merge(options)

    case opts[:type]
    when :small
      render partial: 'links/link', locals: {truncate_title: 60}.merge(opts)
    when :medium
      render partial: 'links/medium_link', locals: {truncate_title: 140}.merge(opts)
    else
      fail InvalidArgument, "Invalid link type #{opts[:type]}"
    end
  end

  def glyphicon icon
    content_tag(:span, class: "glyphicon glyphicon-#{icon}") {}
  end
end
