/* BẢNG TRIGGER 
   Trigger 1 : không cho xóa danh mục có chứa sản phẩm  
   Trigger 2 : xong 
   Trigger 3 : update trang thai
   Trigger 4 : update membership 
   BẢNG FUNCTION
   FUNC1: tính lãi trong tháng nào ,năm nào
   FUNC2: tính tổng số tiền đã chi của khách hàng 
   FUNC3: tính tổng số sách đã bán được trong quý và lợi nhuận kiếm được từ quý đó 
*/
--====================== TR1
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
--====================== TR2			
ALTER TRIGGER TrgaddOrder
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

--======
	update DONHANG set trangthai = 1 where MADH in (select MADH from inserted)
	end
	else 
	begin 
	print N'Số lượng sản phẩm trong kho không đủ '
	ROLLBACK TRAN
	end
END
go
--===================================================
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
--============================================= Tr3
create TRIGGER TrgUpdateStatus
ON [dbo].[DONHANG_CHITIET] 
AFTER INSERT
AS 
BEGIN
   update SACH 
	set  SLTONKHO = SLTONKHO - (select sum(soluong)
									from inserted b
									where SACH.MASACH = b.MASACH)
	where SACH.MASACH in (select MASACH from inserted)
	
    UPDATE DONHANG
    SET tongtien_donhang = (
	SELECT SUM(s.GIATIEN * a.soluong) - (SUM(s.GIATIEN * a.soluong) * t.ptgiam)						 
							  FROM inserted a
							 join SACH s on a.MASACH = s.MASACH
                             JOIN DONHANG b ON a.MADH = b.MADH
							 join KHACHHANG k on k.MAKH = b.MAKH
							 join tichluy t on k.matichluy = t.MATL
                             WHERE b.MADH IN (SELECT MADH FROM inserted) 
							 group by t.ptgiam
							)			
							 WHERE MADH IN (SELECT MADH FROM inserted)
						--	 declare @date date
						-- select @date = NGAYDUDINHSHIP from DONHANG 
	--declare @e int
	--set @e = DATEDIFF(day,GETDATE(), @date)
	--if @e > 7
	--begin 
	update DONHANG set trangthai = 1 where MADH in (select MADH from inserted)
	--end
END
go
select * from TRANGTHAI_DONHANG
--============================================= Tr4
						--	 declare @date date
						-- select @date = NGAYDUDINHSHIP from DONHANG 
	--declare @e int
	--set @e = DATEDIFF(day,GETDATE(), @date)
	--if @e > 7
   select * from DONHANG
   select * from DONHANG_CHITIET
   select * from KHACHHANG
   select * from tichluy
   select * from TRANGTHAI_DONHANG


