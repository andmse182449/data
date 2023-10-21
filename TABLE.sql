CREATE DATABASE VINABOOK
go
USE VINABOOK
go

CREATE TABLE DANHMUC(
	MaDM INT identity(01,1) NOT NULL PRIMARY KEY,
	TenDM NVARCHAR(200)
)

CREATE TABLE PHATHANHSACH(
	MAPHATHANH INT identity NOT NULL PRIMARY KEY,
	TENNPT NVARCHAR(200),
)
CREATE TABLE SACH(
	MASACH UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	TENSACH NVARCHAR(200),
	GIATIEN FLOAT,
	SLTONKHO INT,
	NGAYNHAPHANG DATE,
	NHAXUATBAN NVARCHAR(200),
	MAPHATHANH INT NOT NULL, 
	MADM int,
	CONSTRAINT FK_MAPHATHANH1 FOREIGN KEY(MAPHATHANH) REFERENCES PHATHANHSACH(MAPHATHANH),
	CONSTRAINT FK_MADANHMUC1 foreign key(MADM) references DANHMUC(MADM)
)


create table KHACHHANG(
	MAKH INT identity(01,1) NOT NULL PRIMARY KEY,
	TENKH NVARCHAR(200),
	SDT varchar(220),
	DIACHI NVARCHAR(MAX),
	Email NVARCHAR(MAX),
	Account NVARCHAR(MAX),
	Pass NVARCHAR(MAX),
)

create table TACGIA(
	MATG INT identity NOT NULL PRIMARY KEY,
	TENTG NVARCHAR(MAX),
	NGAYSINHTG date
)


CREATE TABLE NHANVIEN(
	MANV INT identity NOT NULL PRIMARY KEY,
	TENNV NVARCHAR(MAX),
	GIOITINH NVARCHAR(MAX),
	VITRI NVARCHAR(MAX),
	NGAYSINH NVARCHAR(MAX),
	NGAYTHUE NVARCHAR(MAX),
	DIACHINV NVARCHAR(MAX),
	SDT varchar(MAX),
	LUONG int
)


create table shipper(
	MASHIPPER INT identity NOT NULL PRIMARY KEY,
	TENCTY NVARCHAR(MAX),
	SDTCTY BIGINT
)
CREATE TABLE BINHLUAN(
	MABL INT identity NOT NULL PRIMARY KEY,
	MAKH INT NOT NULL,
	MASACH UNIQUEIDENTIFIER DEFAULT NEWID(),
	DANHGIA int,
	CONSTRAINT FK_MAKH1 FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH),
	CONSTRAINT FK_MASACH1 FOREIGN KEY(MASACH) REFERENCES SACH(MASACH),
)

CREATE TABLE DONHANG(
	MADH INT identity NOT NULL PRIMARY KEY,
	TENSHIPPER NVARCHAR(MAX),
	SDTSHIPPER varchar(20),
	DIACHIGH NVARCHAR(MAX),
	MAKH INT NOT NULL,
	MANV INT NOT NULL,
	MASHIPPER INT NOT NULL,
	CONSTRAINT FK_MAKH2 FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH),
	CONSTRAINT FK_MANV1 FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT FK_MASHIPPER1 FOREIGN KEY(MASHIPPER) REFERENCES SHIPPER(MASHIPPER),
	PTDATHANG NVARCHAR(MAX),
	NGAYDATHANG DATE,
	NGAYDUDINHSHIP DATE
)

CREATE TABLE DONHANG_CHITIET(
	MADH INT NOT NULL,
	MASACH UNIQUEIDENTIFIER DEFAULT NEWID(),
	CONSTRAINT PR_MADH_MASACH PRIMARY KEY(MADH, MASACH),
	CONSTRAINT FK_MADH FOREIGN KEY(MADH) REFERENCES DONHANG(MADH),
	CONSTRAINT FK_MASACH FOREIGN KEY(MASACH) REFERENCES SACH(MASACH)
)

CREATE TABLE SANGTAC(
	MATG INT NOT NULL,
	MASACH UNIQUEIDENTIFIER DEFAULT NEWID(),
	NAMST DATE,
	CONSTRAINT PR_MATG_MASACH PRIMARY KEY(MATG, MASACH),
	CONSTRAINT FK_MATG FOREIGN KEY(MATG) REFERENCES TACGIA(MATG),
	CONSTRAINT FK_MASACH2 FOREIGN KEY(MASACH) REFERENCES SACH(MASACH)
)

CREATE TABLE HOPTAC(
	MATG INT NOT NULL,
	MAPHATHANH INT NOT NULL,
	NGAYKIHOPDONG DATE,
	NGAYHETHAN DATE,
	CONSTRAINT PR_MATG_MAPHATHANH PRIMARY KEY(MATG, MAPHATHANH),
	CONSTRAINT FK_MATG3 FOREIGN KEY(MATG) REFERENCES TACGIA(MATG),
	CONSTRAINT FK_MAPHATHANH FOREIGN KEY(MAPHATHANH) REFERENCES PHATHANHSACH(MAPHATHANH)
)
				
			
