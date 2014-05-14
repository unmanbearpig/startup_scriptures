module ApplicationHelper
  def flash_messages
    flash_classes = {
      'notice' => 'alert-success',
      'alert' => 'alert-warning',
      'flash' => 'alert-info'
    }

    flash.map do |name, msg|
      flash_class = flash_classes[name.to_s]

      render partial: 'layouts/flash_message', locals: {name: name, flash_class: flash_class, msg: msg}
    end.join(' ').html_safe
  end
end
