STT	Dạng sử dụng	                                Loại Provider	        Khi nào nên dùng?

1	Cung cấp giá trị tĩnh, hằng số	                Provider	            Không cần thay đổi, chỉ cần cung cấp 1 lần

2	Biến đơn giản, cần thay đổi và UI cập nhật	    StateProvider	        Dạng boolean, int, enum, text input…

3	Danh sách, đối tượng, logic phức tạp	        NotifierProvider	    Có hành vi như thêm/sửa/xoá/lọc

4	Gọi Future đơn giản	                            FutureProvider	        Gọi API, lấy data async không phức tạp

5	Gọi async phức tạp + quản lý state	            AsyncNotifierProvider	Kết hợp async + logic + loading/error

!!! .family<T, Param>() giúp tạo một provider có thể nhận tham số đầu vào.