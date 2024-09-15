module UsersHelper
  def format_date_in_thai(date, format = :default)
    # ตรวจสอบว่า date เป็น Date, DateTime หรือ Time หรือไม่
    return '' if date.nil? || !date.respond_to?(:strftime)

    # ใช้ I18n.l เพื่อแสดงวันที่ในรูปแบบที่กำหนดไว้
    formatted_date = I18n.l(date, format: format)

    # แปลงปีจาก ค.ศ. เป็น พ.ศ. โดยการบวก 543 ปี
    formatted_date.gsub(/(\d{4})/) { |year| (year.to_i + 543).to_s }
  end
end
