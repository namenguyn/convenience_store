# Trang web quản lí một cửa hàng tiện lợi đơn giản, tập trung vào database

# Cách chạy
## Clone git repo về máy
- Mở terminal, chạy lệnh `https://github.com/namenguyn/HTTT_He_thong_cham_cong.git`
## Chạy Backend
- Cd vào folder database/database, chạy lệnh `npm install` để cài các node_modules
- Tạo một môi trường python và kích hoạt môi trường
- Chạy file sql `CuaHang_Final` để khởi tạo dữ liệu trên MySQL
- Chạy `python manage.py migrate` sau đó đến `python manage.py runserver` ở terminal để khởi động server backend.
## Chạy Frontend
- Lưu ý cần chạy server backend trước khi chạy client frontend.
- Cd vào folder `src`, chạy `npm install` để cài các node_modules
- Sau khi cài xong, chạy lệnh `npm start` ở terminal để khởi động client frontend.
