/* BẢNG TRIGGER 
   Trigger 1 : Trigger ngăn câu lệnh xóa sách
   Trigger 2 : Trigger cập nhật giá tiền, số lượng tồn kho của sách sau khi xuất hóa đơn bán hàng 
   Trigger 3 : Trigger cập nhật trạng thái đơn hàng
   Trigger 4 : Trigger kiểm tra ngày tháng đặt hàng có hợp lệ hay không
*/
--TR1
create TRIGGER TrgDeleteBook
ON sach
instead of DELETE
AS 
BEGIN
    IF EXISTS (SELECT MASACH FROM sach WHERE MASACH = (SELECT MASACH FROM deleted))
    BEGIN
        PRINT N'Không thể thực thi lệnh này!'
        ROLLBACK TRAN
    END
END;
go
-- thực thi
delete from SACH WHERE MASACH = '3D69F211-918D-4C71-A873-DF4320A8F681'
insert into SACH(TENSACH, GIATIEN, SLTONKHO, NHAXUATBAN, MAPHATHANH) values(N'oke con de', 23000, 43, 'tgq', 11)
select * from SACH where TENSACH = N'oke con de'
	--===============================
	--TR2			
CREATE TRIGGER TrgaddOrder
ON [dbo].[DONHANG_CHITIET] 
for INSERT, update
AS 
BEGIN
declare @buy int 
set @buy = (select soluong from inserted)
if	(SELECT s.SLTONKHO FROM sach s where s.MASACH in (select MASACH from inserted)) >= @buy
begin
   update SACH 
	set  SLTONKHO = SLTONKHO - (select sum(soluong)
									from inserted b
									where SACH.MASACH = b.MASACH)
	where SACH.MASACH in (select MASACH from inserted)
	
   UPDATE DONHANG
	SET tongtien_donhang = tongtien_donhang + (
		SELECT SUM(s.GIATIEN * a.soluong) - (SUM(s.GIATIEN * a.soluong) * t.ptgiam)						 
	   FROM inserted a
		JOIN SACH s ON a.MASACH = s.MASACH
		JOIN DONHANG b ON a.MADH = b.MADH
		JOIN KHACHHANG k ON k.MAKH = b.MAKH
		JOIN tichluy t ON k.matichluy = t.MATL
		WHERE b.MADH IN (SELECT MADH FROM inserted)
    GROUP BY t.ptgiam
	)
WHERE MADH IN (SELECT MADH FROM inserted) 

--THUC THI
	update DONHANG set trangthai = 1 where MADH in (select MADH from inserted)
	end
	else 
	begin 
	print N'Số lượng sản phẩm trong kho không đủ '
	ROLLBACK TRAN
	end
END
go
select * from DONHANG
--===============================================
update DONHANG_CHITIET set soluong = 1 where MADH = 1078 and MASACH = '3CCCED2D-F67C-40E2-A52F-04BBC0798BFC'
select * from SACH where MASACH = '3CCCED2D-F67C-40E2-A52F-04BBC0798BFC' 

select * from DONHANG_CHITIET
select * from DONHANG
DELETE FROM DONHANG WHERE MADH = 1078
DELETE FROM DONHANG_CHITIET WHERE MADH = 1079
insert into donhang values (N'Nguyễn Tài',351-664-9650,'585 Surrey Avenue',18,5,1,N'trả khi nhận hàng','20230630','20230705',NULL,0,null)

insert into DONHANG_CHITIET values (1079,'3CCCED2D-F67C-40E2-A52F-04BBC0798BFC',1, NULL)
update DONHANG_CHITIET set soluong = 2 where MADH = 1079 and MASACH = '73241A6A-3836-40F8-AFBD-E2EDEEF54C15'
update DONHANG set tongtien_donhang = 0 where MADH = 1079 
insert into DONHANG_CHITIET values	(1079,'73241A6A-3836-40F8-AFBD-E2EDEEF54C15',1, NULL)
	--==================================== tr3
	
alter TRIGGER TrgUpdateStatus
ON DONHANG
after UPDATE
AS 
BEGIN
if update(TRANGTHAI)
BEGIN
	declare @date date
	select @date = NGAYDUDINHSHIP from DONHANG where MADH in (select MADH from inserted)
	declare @e int
	set @e = DATEDIFF(day,GETDATE(), @date)
	--=========================
	if @e <= -7 and (select TRANGTHAI from inserted) = 3 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1
	begin update DONHANG set trangthai = 3 where MADH = (select MADH from inserted) 
	end
	ELSE IF @e <= -7  and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1 and (select TRANGTHAI from inserted) = 1 
	or @e <= -7  and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1 and (select TRANGTHAI from inserted) = 2
	begin 
	print N'Đơn hàng đã được giao'
	rollback tran
	end
	--=========================
	else if @e < 0 and  @e > -7 and (select TRANGTHAI from inserted) = 2 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1
	begin
	update DONHANG set trangthai = 2 where MADH = (select MADH from inserted)
	end
	ELSE IF @e < 0 and  @e > -7 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1 and (select TRANGTHAI from inserted) = 1 
	or @e < 0 and  @e > -7 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1  and (select TRANGTHAI from inserted) = 3
	begin 
	print N'Đơn hàng đang được giao'
	rollback tran
	end
	--==========================
	else if @e > 0 and (select TRANGTHAI from inserted) = 1  and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1
	begin
	update DONHANG set trangthai = 1 where MADH = (select MADH from inserted)
	end
	ELSE IF @e > 0 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1 and (select TRANGTHAI from inserted) = 2 
	or @e > 0 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1  and (select TRANGTHAI from inserted) = 3
	begin
	print N'Đơn hàng chưa được giao'
	rollback tran
	end
	--==========================
	else if (select TRANGTHAI from inserted) = 4 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) >= 1 
	begin 
	print N'Đơn hàng không được phép hủy'
	rollback tran
	end
	else if (select TRANGTHAI from inserted) != 4 and (select count(MADH) from DONHANG_CHITIET dc where MADH = (select MADH from inserted)) = 0 
	begin 
	print N'Đơn hàng không được phép giao'
	rollback tran
	end
	--=========================
END
END
go
-- TR4 
CREATE TRIGGER TrgCheckOrderTime
ON [dbo].[DONHANG] 
for INSERT
AS 
BEGIN
	IF(SELECT NGAYDATHANG FROM inserted ) > (SELECT NGAYDUDINHSHIP FROM inserted )
	BEGIN 
	print 'Thời gian dự định vận chuyển không hợp lệ!'
	rollback tran
	END
	else IF(SELECT NGAYDATHANG FROM inserted ) > getdate()
	BEGIN 
	print 'Thời gian đặt hàng không hợp lệ!'
	rollback tran
	END
end
go
