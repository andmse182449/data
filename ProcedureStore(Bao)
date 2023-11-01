/*
   PROC1: Procedure với giá trị đầu vào lần lượt là tên sách và kiểu đánh giá, giá trị đầu ra là số lượt đánh giá của kiểu đánh giá đã cho
   PROC2: Procedure với giá trị đầu vào là tên tác giả, lấy ra tên, giá bán và nhà xuất bản của những quyển sách thuộc về tác giả đã cho
   PROC3: Procedure với giá trị đầu vào là tên danh mục, lấy ra tên và giá bán của những quyển sách trong danh mục đã cho
   PROC4: Procedure với giá trị đầu vào lần lượt là tháng và năm bất kì, lấy ra thông tin về những quyển sách bán chạy nhất trong tháng và năm tương ứng 
   (tiêu chí bán chạy được tính bằng số sách được bán lớn hơn 2)
   PROC5: Procedure với giá trị đầu vào là một chuỗi kí tự, lấy ra thông tin gồm tên đầy đủ của sách,
   tên tác giả, giá tiền và nhà xuất bản có chứa chuỗi kí tự tương tự
*/
-- PROC1
create procedure proc_1(@tensach nvarchar(max), @kieudanhgia int,@soluongdanhgia int output)
as
	begin
	set @soluongdanhgia = (
	select COUNT(DANHGIA) 
	from sach s join BINHLUAN b on s.MASACH = b.MASACH and s.TENSACH = @tensach
	where DANHGIA = @kieudanhgia
	)
		select b.DANHGIA, @soluongdanhgia  N'Số lượt đánh giá'
		from sach s join BINHLUAN b on s.MASACH = b.MASACH and s.TENSACH = @tensach and b.DANHGIA = @kieudanhgia
		group by b.DANHGIA
	end
go
declare @t int 
execute proc_1 'IELTS Analyst Second Edition', 4, @soluongdanhgia = @t output
print @t
go
-- PROC2
create procedure proc_2 (@tentg nvarchar(max))
as
	begin
		select c.TENSACH, c.GIATIEN, c.NHAXUATBAN
		from SANGTAC a, TACGIA b, SACH c
		where b.MATG = a.MATG and a.MASACH = c.MASACH and b.TENTG = @tentg
	end
go
execute proc_2 @tentg = 'NXB Sheth'
go
-- PROC3
create procedure proc_3(@tendm nvarchar(200))
as
	begin
		select b.TENSACH, b.GIATIEN
		from [dbo].[DANHMUC] a, SACH b
		where a.MaDM = b.MADM and a.TenDM = @tendm
	end
go
execute proc_3 @tendm = N'Sách Chuyên Ngành'
go
-- PROC4
create procedure proc_4(@month int, @year int)
as
	begin
		select b.TENSACH, b.GIATIEN, b.NHAXUATBAN
		from [dbo].[DONHANG] a, SACH b, DONHANG_CHITIET c
		where a.MADH = c.MADH and b.MASACH = c.MASACH and month(a.NGAYDATHANG) = @month and year(a.NGAYDATHANG) = @year
		group by b.TENSACH, b.GIATIEN, b.NHAXUATBAN
		having count(c.MASACH) >= 2
	end
go  
execute proc_4 @month = 9, @year = 2023
go
-- PROC5
create procedure proc_5(@ten nvarchar(max))
as
	begin
		select  s.TENSACH, tg.TENTG ,s.GIATIEN, s.NHAXUATBAN
		from sach s join SANGTAC st on s.MASACH = st.MASACH join TACGIA tg on tg.MATG = st.MATG
		where TENSACH like '%' + @ten + '%'
	end
go
execute proc_5 @ten = 'Second'












