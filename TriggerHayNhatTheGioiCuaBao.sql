CREATE TRIGGER UpdateTrangThai
ON [dbo].[DONHANG]
FOR UPDATE
AS
BEGIN
    -- Cập nhật TrangThaiID dựa trên ngày dự định ship và ngày hiện tại
    UPDATE [dbo].[DONHANG]
    SET MATRANGTHAI = 
        CASE
            WHEN DATEDIFF(DAY, i.[NGAYDUDINHSHIP], GETDATE()) >= 7 THEN 3
            WHEN DATEDIFF(DAY, i.[NGAYDUDINHSHIP], GETDATE()) > 0 THEN 2
            ELSE 1
        END
    FROM [dbo].[DONHANG] AS d
    INNER JOIN inserted AS i ON d.MADH = i.MADH;
END

go
create TRIGGER UpdateHuyHang
ON [dbo].[DONHANG]
FOR UPDATE 
AS
BEGIN 
    -- Kiểm tra và cập nhật TrangThaiID dựa trên sự tồn tại trong DONHANG_CHITIET
    UPDATE [dbo].[DONHANG]
    SET TrangThaiID = 
        CASE
            WHEN d.MADH != all (select MADH
								from DONHANG_CHITIET
								group by MADH)THEN 1
        END
		FROM [dbo].[DONHANG] AS d
		INNER JOIN inserted AS i ON d.MADH = i.MADH;
    
END

-- Đặt ưu tiên cho trigger "UpdateTrangThai" thành 1
EXEC sp_settriggerorder 
    @triggername = 'UpdateTrangThai', 
    @order = 'First', 
    @stmttype = 'UPDATE';

-- Đặt ưu tiên cho trigger "UpdateHuyHang" thành 2
EXEC sp_settriggerorder 
    @triggername = 'UpdateHuyHang', 
    @order = 'Last', 
    @stmttype = 'UPDATE';



update [dbo].[DONHANG]
set TrangThaiID = 3
where MADH = 13
go

alter procedure DoanhThu(@month int, @year int, @doanhthu float output, @loinhuan float output)
as 
begin 
    select @doanhthu =  sum([TONGGIASAUKHIDISCOUNT])
                    from [dbo].[DONHANG]
                    where month(NGAYDATHANG) = @month and year(NGAYDATHANG) = @year 

   SELECT @loinhuan = @doanhthu - (
        SELECT SUM(c.GIANHAP * a.SoLuong)
        FROM [dbo].[DONHANG] b
		join [dbo].[DONHANG_CHITIET] a on a.MADH = b.MADH
		join [dbo].[HOADON_CHITIET] c on c.MASACH = a.MASACH
        WHERE MONTH(b.NGAYDATHANG) = @month AND YEAR(b.NGAYDATHANG) = @year
    );
end
go


declare @x float
DECLARE @Y FLOAT
execute DoanhThu 10, 2023, @x output, @Y OUTPUT
select @x as DoanhThu, @Y AS LoiNhuan


--------- update tong tien o đơn hàng chi tiết
 UPDATE [dbo].[DONHANG_CHITIET]
SET TongTien = a.GIATIEN * b.SoLuong
FROM [dbo].[DONHANG_CHITIET] AS b
JOIN [dbo].[SACH] AS a ON b.MASACH = a.MASACH
WHERE b.MADH BETWEEN 3 AND 13;
----------update tổng tiền ở đơn hàng
UPDATE DONHANG
SET TONGGIA = (
    SELECT SUM(DONHANG_CHITIET.TongTien)
    FROM DONHANG_CHITIET
    WHERE DONHANG_CHITIET.MADH = DONHANG.MADH
)
WHERE MADH BETWEEN 1 AND 60;
------------update tổng tiền sau khi discount
update DONHANG
set [TONGGIASAUKHIDISCOUNT] = a.TONGGIA - (a.TONGGIA * c.discount)
from DONHANG a, KHACHHANG b, TichLuy c
where a.MAKH = b.MAKH and b.MATICHLUY = c.MATICHLUY AND MADH BETWEEN 1 AND 60;
GO

ALTER function func_2(@makh varchar(max))
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
	ELSE if @a >= 300000 and @a < 1000000
	begin set @b = N'Đạt Thẻ Bạc' end 
	ELSE if @a >= 1000000
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




