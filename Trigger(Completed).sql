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
