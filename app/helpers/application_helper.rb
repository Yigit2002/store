module ApplicationHelper
  def order_status_badge(status)
    case status
    when 0
      "bg-secondary" # Hazırlanıyor (gri)
    when 1
      "bg-success" # Tamamlandı (yeşil)
    when 2
      "bg-danger" # İptal Edildi (kırmızı)
    when 3
      "bg-warning text-dark" # Kargoda (sarı)
    else
      "bg-info" # Diğer durumlar (mavi)
    end
  end
end
