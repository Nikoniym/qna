module ApplicationHelper
  def flash_message(key)
    {notice:  'alert-success', alert: 'alert-danger'}[key.to_sym]
  end
end
