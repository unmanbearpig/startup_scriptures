module FlashHelper

  def flash_messages
    flash.map do |name, msg|
      if msg.kind_of?(Array)
        msg.map { |m| flash_message(name, m)}
      else
        flash_message name, msg
      end
    end.flatten.join(' ').html_safe
  end

  def flash_messages_from_errors errors
    return if !errors && errors.empty?

    flash[:alert] = errors.full_messages
  end

  private

  def flash_message name, msg
    flash_classes = {
      'notice' => 'alert-success',
      'alert' => 'alert-warning',
      'flash' => 'alert-info'
    }

    flash_class = flash_classes[name.to_s]
    render partial: 'layouts/flash_message', locals: {name: name, flash_class: flash_class, msg: msg}
  end
end
