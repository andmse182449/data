/* BẢNG TRIGGER 
   Trigger 1 : Trigger ngăn câu lệnh xóa sách
   Trigger 2 : Trigger cập nhật giá tiền, số lượng tồn kho của sách sau khi xuất hóa đơn bán hàng 
   Trigger 3 : Trigger cập nhật trạng thái đơn hàng
   Trigger 4 : Trigger kiểm tra ngày tháng đặt hàng có hợp lệ hay không
*/
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
