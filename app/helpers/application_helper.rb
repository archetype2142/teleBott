module ApplicationHelper
  def derive_notification_type type
    case type
    when "error"
      "is-danger"
    when "info"
      "is-info"
    when "success"
      "is-success"
    else
      "is-success"
    end
  end
end
