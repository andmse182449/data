/*
 BẢNG FUNCTION
   FUNC1: Function tính lợi nhuận trong tháng và năm đã cho
   FUNC2: Function tính tổng số tiền đã chi của khách hàng (phục vụ cho việc cập nhật tích lũy)
   FUNC3: Function in ra lịch sử đặt hàng của khách hàng trong tháng và năm đã cho
*/

--================================================ FUNC1 ================================================
alter function func_1(@thang int, @nam int)
returns float
as 
	begin
		declare @loinhuan float
		declare @doanhthu float 
		set @doanhthu = (
		select sum(tongtien_donhang)
		from DONHANG
		where year(NGAYDATHANG) = @nam and month(NGAYDATHANG) = @thang
		)
		--===================
		set @loinhuan = @doanhthu - (
		select SUM(S.GIANHAP * a.soluong)						 
		FROM DONHANG_CHITIET a
		JOIN HOADON_CHITIET s ON a.MASACH = s.MASACH
		join DONHANG h on h.MADH = a.MADH
		where year(h.NGAYDATHANG) = 2023 and month(h.NGAYDATHANG) = 6
		)
		return @doanhthu
	end
go
-- thuc thi 
declare @t float
set @t = dbo.func_1(6, 2023)
print N'Tổng lợi nhuận: '+ convert(char(100),@t)
go
--==================================================
select * from HOADON_CHITIET
select * from DONHANG_CHITIET where MADH in (31,37,61)
select * from SACH where MASACH = '55CC8AD5-33BF-4B57-9B6E-0A9FCAF4AC3A' 
OR MASACH = '4FAB3799-A800-408B-8182-0BCC164E29F2' 
OR MASACH = '4503BBFA-CF53-4EDB-B718-1F4B4806858C' 
insert into HOADON_CHITIET values 
(1, '55CC8AD5-33BF-4B57-9B6E-0A9FCAF4AC3A', N'Mind Map 24H English - Giao Tiếp - Học Tiếng Anh Giao Tiếp Thực Chiến Cực Kỳ Hiệu Quả Thông Qua Sơ Đồ Tư Duy', 200,200000) ,
(2, '4FAB3799-A800-408B-8182-0BCC164E29F2', N'Tự Học Viết Tiếng Nhật (Tập 1) - 200 Chữ Kanji Căn Bản', 200 ,50000) ,
(3, '4503BBFA-CF53-4EDB-B718-1F4B4806858C', N'Khúc Ngẫu Hứng Trước Ga Mahoro', 200, 65000) 
select * from DONHANG where year(NGAYDATHANG) = 2023 and month(NGAYDATHANG) = 6
-- doanh thu 1571400
-- loi nhuan = 1571400 - 715000 = 856400

--================================================ FUNC2 ================================================
alter function func_2(@makh varchar(max))
returns @tk table
(
MAKH INT primary key,
TENKH nvarchar(100),
TONGTIEN FLOAT,
DIEUKIENTHE NVARCHAR(50)
)
as 
	begin
	declare @a float 
	declare @b nvarchar(max) 
	set @a = (
	select SUM(S.GIATIEN * DHCT.soluong)
	FROM DONHANG d
    JOIN DONHANG_CHITIET dhct ON d.MADH = dhct.MADH
    JOIN SACH S ON s.MASACH = dhct.MASACH
    JOIN KHACHHANG kh ON kh.MAKH = d.MAKH
	WHERE D.MAKH = @makh
	GROUP BY KH.MAKH, KH.TENKH
	)
	if @a >= 100000 and @a < 300000
	begin set @b = N'Đạt thẻ đồng' end 
	ELSE if @a >= 300000 and @a < 100000000
	begin set @b = N'Đạt Thẻ Bạc' end 
	ELSE if @a >= 100000000
	begin set @b = N'Đạt Thẻ Vàng' end 
	else begin set @b = N'Thẻ Cơ Bản' end
	insert @tk
	select KH.MAKH, KH.TENKH, @a, @b
	FROM DONHANG d
    JOIN DONHANG_CHITIET dhct ON d.MADH = dhct.MADH
    JOIN SACH S ON s.MASACH = dhct.MASACH
    JOIN KHACHHANG kh ON kh.MAKH = d.MAKH
	WHERE D.MAKH = @makh
	GROUP BY KH.MAKH, KH.TENKH
	return
	end
go
-- thực thi
SELECT * from dbo.func_2(23)
--================================================ FUNC3 ================================================
ALTER FUNCTION func_3(@makh INT)
RETURNS @c TABLE
(
    MADH INT,
    MAKH INT,
    TENKH NVARCHAR(MAX),
    MASACH UNIQUEIDENTIFIER,
    TENSACH NVARCHAR(MAX),
    SOLUONG INT,
	TONGTIEN FLOAT,
    NGAYDATHANG DATE,
    TRANGTHAIGIAODICH NVARCHAR(MAX)
)
AS 
BEGIN
    INSERT @c
    SELECT
        D.MADH,
        kh.MAKH,
        kh.TENKH,
        s.MASACH,
        s.TENSACH,
        dhct.soluong,
		S.GIATIEN * DHCT.soluong,
        d.NGAYDATHANG,
        TENTRANGTHAI
    FROM DONHANG d
    JOIN DONHANG_CHITIET dhct ON d.MADH = dhct.MADH
    JOIN SACH S ON s.MASACH = dhct.MASACH
    JOIN KHACHHANG kh ON kh.MAKH = d.MAKH
    JOIN TRANGTHAI_DONHANG TD ON TD.MATRANGTHAI = D.TRANGTHAI
    WHERE kh.MAKH = @makh;
    RETURN
END
-- thực thi
SELECT * from dbo.func_3(22)
