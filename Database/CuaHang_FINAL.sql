CREATE DATABASE CuaHang;
GO
-- Tạo bảng Nhân viên
CREATE TABLE NhanVien (
    MaNhanVien			CHAR(7)			PRIMARY KEY,
    SoDienThoai			CHAR(10)		NOT NULL UNIQUE,
    NgayThangNamSinh	DATE			NOT NULL,
    NgayBatDauLam		DATE			NOT NULL,
    HoTen				VARCHAR(100)	NOT NULL,
    GioiTinh			VARCHAR(3) CHECK (GioiTinh IN ('Nam', 'Nu')),
    DiaChi				VARCHAR(255)	NOT NULL,
    Email				VARCHAR(100)	NOT NULL UNIQUE,
    MaQuanLy			CHAR(7),
	CanCuocCongDan		CHAR(12)		NOT NULL UNIQUE
    CONSTRAINT FK_QuanLy FOREIGN KEY (MaQuanLy) REFERENCES NhanVien(MaNhanVien) ON DELETE NO ACTION
);

--Tạo bảng Nhân viên full-time
CREATE TABLE NhanVienFullTime (
    MaNhanVien			CHAR(7)			PRIMARY KEY,
    PhuCap				DECIMAL(10, 2)	NOT NULL,
    LuongCoBan			DECIMAL(10, 2)	NOT NULL,
    BaoHiem				CHAR(10)		NOT NULL UNIQUE,
    NgayNghiPhepNam		INT				NOT NULL,
	CONSTRAINT FK_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
	CONSTRAINT CHK_PhuCap_LuongCoBan CHECK (PhuCap > 0 AND LuongCoBan > 0 AND PhuCap < LuongCoBan)  --Mới thêm ràng buộc phucap < luongcoban;
);
--Tạo bảng Nhân viên part-time
CREATE TABLE NhanVienPartTime (
    MaNhanVien			CHAR(7)			PRIMARY KEY,
    SoGioMoiTuan		INT				NOT NULL,
	LuongMoiGio			DECIMAL(10, 2)	NOT NULL,
	HopDongThoiVu		CHAR(8)			NOT NULL UNIQUE,
	CONSTRAINT FK_NhanVienPartTime FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
	CONSTRAINT CHK_PhuCap_SoGio_Luong CHECK (LuongMoiGio > 0 AND SoGioMoiTuan > 0 )
);

-- Tạo bảng KhoHang
CREATE TABLE KhoHang (
    MaKhoHang			CHAR(2)			PRIMARY KEY,
    SucChua				INT
);

-- Tạo bảng Loai
CREATE TABLE Loai(
	MaLoai				CHAR(3)			PRIMARY KEY,
	TenLoai				VARCHAR(50)
);

-- Tạo bảng HangHoa
CREATE TABLE HangHoa (
    MaHangHoa			CHAR(7)			PRIMARY KEY,
    Ten					VARCHAR(100),
    Gia					DECIMAL(10, 2),
    DonViTinh			VARCHAR(50),
	MaLoai				CHAR(3),
	SoLuongConLai		INT,
	CONSTRAINT FK_HangHoa_Loai FOREIGN KEY (MaLoai) REFERENCES Loai(MaLoai)
);


-- Tạo bảng NhaCungCap
CREATE TABLE NhaCungCap (
    MaNhaCungCap		CHAR(6)			PRIMARY KEY,
    SoDienThoai			CHAR(10)		NOT NULL UNIQUE,
    DiaChi				VARCHAR(100)	NOT NULL,
    Email				VARCHAR(100)	NOT NULL,
    Ten					VARCHAR(50)		NOT NULL
);

-- Tạo bảng LoHang
CREATE TABLE LoHang (
    MaLoHang			CHAR(6),
    MaNhaCungCap		CHAR(6),
    NguonGoc			VARCHAR(100),
    NgaySanXuat			DATE,
    HanSuDung			DATE,
    NgayCungCap			DATE,
	ChiPhiLoHang		DECIMAL(10, 2),
    PRIMARY KEY (MaLoHang, MaNhaCungCap),
    CONSTRAINT FK_NhaCungCap FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);


-- Tạo bảng HoaDon
CREATE TABLE HoaDon (
    MaHoaDon			CHAR(8)			PRIMARY KEY,
    TienKhachHangDua	DECIMAL(10, 2),
    ThoiGianXuatHoaDon	DATETIME		NOT NULL
);

-- Tạo bảng KhachHang
CREATE TABLE KhachHang (
    MaKhachHang			CHAR(6)			PRIMARY KEY,
    HoTen				VARCHAR(100)	NOT NULL,
);

--Tao bang SoDienThoai
CREATE  TABLE SoDienThoai (
	MaKhachHang			CHAR(6),
    SoDienThoai			CHAR(10)		NOT NULL,
    PRIMARY KEY (MaKhachHang, SoDienThoai),
    CONSTRAINT FK_SoDienThoai FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Tạo bảng LuuTru
CREATE TABLE LuuTru (
    MaLoHang			CHAR(6)		NOT NULL,
	MaNhaCungCap		CHAR(6)		NOT NULL,
    MaKhoHang			CHAR(2)		NOT NULL,
    SoLuongLoHang		INT,
    NgayLuuTru			DATE,
    PRIMARY KEY (MaNhaCungCap, MaLoHang),
    CONSTRAINT FK_LoHang FOREIGN KEY (MaLoHang, MaNhaCungCap) REFERENCES LoHang(MaLoHang, MaNhaCungCap),
    CONSTRAINT FK_KhoHang FOREIGN KEY (MaKhoHang) REFERENCES KhoHang(MaKhoHang)
);

-- Tạo bảng MuaHang
CREATE TABLE MuaHang (
    MaHoaDon		CHAR(8)		NOT NULL,
    MaKhachHang		CHAR(6)		NOT NULL,		
    MaNhanVien		CHAR(7)		NOT NULL,
    PRIMARY KEY (MaHoaDon, MaKhachHang),
    CONSTRAINT FK_MaHoaDon FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    CONSTRAINT FK_MaKhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    CONSTRAINT FK_MaNhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVienFullTime(MaNhanVien)
);


--Tao bang quan ly kho
CREATE TABLE QuanLy (
	MaNhanVien		CHAR(7)		PRIMARY KEY,
	MaKhoHang		CHAR(2)		NOT NULL,
	CONSTRAINT FK_QuanLyNhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVienPartTime(MaNhanVien),
    CONSTRAINT FK_QuanLyKhoHang FOREIGN KEY (MaKhoHang) REFERENCES KhoHang(MaKhoHang)
);

--Tao bang Tang
CREATE TABLE Tang (
	MaKhoHang		CHAR(2)		NOT NULL,
	SoTang			INT			NOT NULL,
	PRIMARY KEY (MaKhoHang, SoTang),
	CONSTRAINT FK_TangKhoHang FOREIGN KEY (MaKhoHang) REFERENCES KhoHang(MaKhoHang)
);


--Tao bang Chua
CREATE TABLE Chua (
	MaHangHoa			CHAR(7)			NOT NULL,
	MaNhaCungCap		CHAR(6)			NOT NULL,
	MaLoHang			CHAR(6)			NOT NULL,
	SoluongHangHoa		INT				NOT NULL,
	PRIMARY KEY (MaHangHoa, MaNhaCungCap, MaLoHang),
	CONSTRAINT FK_Chua_HangHoa FOREIGN KEY (MaHangHoa) REFERENCES HangHoa(MaHangHoa),
	CONSTRAINT FK_Chua_LoHang FOREIGN KEY (MaLoHang, MaNhaCungCap) REFERENCES LoHang(MaLoHang, MaNhaCungCap)
);
--Tao bang Chua thong tin

CREATE TABLE ChuaThongTin (
	MaHoaDon		CHAR(8)		NOT NULL,
	MaHangHoa		CHAR(7)		NOT NULL,
	Soluong         INT         NOT NULL,
	PRIMARY KEY (MaHoaDon, MaHangHoa),
	CONSTRAINT FK_ChuaThongTin_HoaDon FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    CONSTRAINT FK_ChuaThongTin_HangHoa FOREIGN KEY (MaHangHoa) REFERENCES HangHoa(MaHangHoa)
);
--Tạo bang dia chi
CREATE TABLE DiaChi (
	MaKhachHang		CHAR(6)		NOT NULL,	
	SoNha			INT			NOT NULL,
	TenDuong		VARCHAR(50)	NOT NULL,
	Phuong			VARCHAR(50)	NOT NULL,
	Quan			VARCHAR(30)	NOT NULL,
	PRIMARY KEY (MaKhachHang, SoNha, TenDuong, Phuong, Quan),
	CONSTRAINT FK_DiaChi_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

--Tao bang Kiem tra
CREATE TABLE KiemTra (
	MaHangHoa		CHAR(7)		NOT NULL,
	MaNhanVien		CHAR(7)		NOT NULL,
	TinhTrang		VARCHAR(50)	NOT NULL,
	SoLuong			INT			NOT NULL,
	PRIMARY KEY (MaHangHoa),
	CONSTRAINT FK_KiemTra_HangHoa FOREIGN KEY (MaHangHoa) REFERENCES HangHoa(MaHangHoa),
    CONSTRAINT FK_KiemTra_NhanVien FOREIGN KEY (MaNhanVien) REFERENCES NhanVienPartTime(MaNhanVien)
);

--CAC CHECK VA TRIGGER DE KIEM SOAT RANG BUOC NGU NGHIA
--Kiem tra rang buoc ngu nghia ve sdt
ALTER TABLE NhanVien
ADD CONSTRAINT CK_SoDienThoai CHECK (SoDienThoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--Kiem tra rang buoc ngu nghia voi mail tan cung bang @gmail.com
ALTER TABLE NhanVien
ADD CONSTRAINT CK_Email CHECK (Email LIKE '%@gmail.com');

--Kiem tra rang buoc ngu nghia nhan vien khong the quan li chinh minh
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NhanVien_QuanLy CHECK (MaNhanVien <> MaQuanLy);

--Kiem tra rang buoc ngu nghia quan li toi da 5 nhan vien
CREATE TRIGGER trg_LimitEmployeeUnderManagement
ON NhanVien
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaQuanLy CHAR(7);

    -- Lấy mã quản lý từ bản ghi mới được chèn hoặc cập nhật
    SELECT @MaQuanLy = MaQuanLy FROM inserted;

    -- Kiểm tra số lượng nhân viên dưới quyền của quản lý này
    IF (SELECT COUNT(*) FROM NhanVien WHERE MaQuanLy = @MaQuanLy) > 5
    BEGIN
        -- Hủy thao tác và trả về lỗi nếu số lượng nhân viên vượt quá 5
        RAISERROR ('Mỗi nhân viên quản lý chỉ được quản lý tối đa 5 nhân viên.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
--THÊM VAO ĐỂ KIỂM TRA TRIGGER QUẢN LÍ 5 NHÂN VIÊN
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moisua@gmail.com',
    @MaQuanLy = 'F000001',
    @CanCuocCongDan = '890123456089'

--Kiem tra rang buoc ngu nghia cua hang nghi tet voi quoc khanh
CREATE TRIGGER trg_CheckHoliday
ON HoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ThoiGianXuatHoaDon DATETIME;

    -- Lấy thời gian xuất hóa đơn từ bản ghi mới được chèn hoặc cập nhật
    SELECT @ThoiGianXuatHoaDon = ThoiGianXuatHoaDon FROM inserted;

    -- Kiểm tra nếu thời gian xuất hóa đơn là ngày lễ lớn
    IF CONVERT(DATE, @ThoiGianXuatHoaDon) IN ('2023-01-01', -- Tết Dương lịch
                                               '2023-04-30', -- Ngày Giải phóng miền Nam
                                               '2023-05-01', -- Quốc tế Lao động
                                               '2023-09-02', -- Quốc Khánh
                                               -- Thêm các ngày lễ lớn khác tùy theo năm
											   '2026-01-01', -- Tết Dương lịch
											   '2026-02-17', -- Tết Nguyên Đán năm 2026
											   '2026-04-30', -- Ngày Giải phóng miền Nam
                                               '2026-05-01', -- Quốc tế Lao động
                                               '2026-09-02', -- Quốc Khánh
											   '2025-01-01', -- Tết Dương lịch
											   '2025-01-29', -- Tết Nguyên Đán năm 2025
											   '2025-04-30', -- Ngày Giải phóng miền Nam
                                               '2025-05-01', -- Quốc tế Lao động
                                               '2025-09-02', -- Quốc Khánh
                                               '2024-02-10', -- Tết Nguyên Đán năm 2024
                                               '2024-09-02') -- Quốc Khánh năm 2024
    BEGIN
        -- Hủy thao tác và trả về lỗi nếu thời gian xuất hóa đơn rơi vào ngày lễ lớn
        RAISERROR ('Cửa hàng không mở cửa vào các ngày lễ lớn như Tết, Quốc Khánh,..', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
-- Chèn thử dữ liệu vào ngày Quốc Khánh để kiểm tra trigger
INSERT INTO HoaDon (MaHoaDon, TienKhachHangDua, ThoiGianXuatHoaDon) 
VALUES ('00987659', 100000, '2023-09-02 10:00:00');

-- Cập nhật thử dữ liệu vào ngày Tết Dương lịch để kiểm tra trigger
UPDATE HoaDon 
SET ThoiGianXuatHoaDon = '2026-01-01 15:00:00' 
WHERE MaHoaDon = '01234568';

--Kiem tra rang buoc ngu nghia ngay luu tru khong trung voi ngay nghi
CREATE TRIGGER trg_CheckLuuTruHoliday
ON LuuTru
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgayLuuTru DATE;

    -- Lấy ngày lưu trữ từ bản ghi mới được chèn hoặc cập nhật
    SELECT @NgayLuuTru = NgayLuuTru FROM inserted;

    -- Kiểm tra nếu ngày lưu trữ là ngày lễ lớn
    IF @NgayLuuTru IN ('2023-01-01', -- Tết Dương lịch
                       '2023-04-30', -- Ngày Giải phóng miền Nam
                       '2023-05-01', -- Quốc tế Lao động
                       '2023-09-02', -- Quốc Khánh
                       -- Thêm các ngày lễ lớn khác tùy theo năm
                       '2026-01-01', -- Tết Dương lịch
                       '2026-02-17', -- Tết Nguyên Đán năm 2026
                       '2026-04-30', -- Ngày Giải phóng miền Nam
                       '2026-05-01', -- Quốc tế Lao động
                       '2026-09-02', -- Quốc Khánh
                       '2025-01-01', -- Tết Dương lịch
                       '2025-01-29', -- Tết Nguyên Đán năm 2025
                       '2025-04-30', -- Ngày Giải phóng miền Nam
                       '2025-05-01', -- Quốc tế Lao động
                       '2025-09-02', -- Quốc Khánh
                       '2024-02-10', -- Tết Nguyên Đán năm 2024
                       '2024-09-02') -- Quốc Khánh năm 2024
    BEGIN
        -- Hủy thao tác và trả về lỗi nếu ngày lưu trữ rơi vào ngày lễ lớn
        RAISERROR ('Ngày lưu trữ lô hàng không được trùng với ngày mà cửa hàng không hoạt động (Tết, Quốc Khánh,...).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
-- Thử cập nhật một bản ghi với ngày lưu trữ là ngày Tết Dương lịch
UPDATE LuuTru
SET NgayLuuTru = '2023-01-01' -- Ngày Tết Dương lịch
WHERE MaLoHang = 'B12345' AND MaNhaCungCap = 'DEF456'; 

SELECT * FROM Loai;
ALTER TABLE LOAI
ADD CONSTRAINT CK_LOAI CHECK (TenLoai IN ('Do an nhanh', 'Do uong', 'Nong san', 'Thuc pham', 'Van phong pham', 'Trai cay'))
Alter table loai
drop constraint CK_LOAI
insert into loai(MaLoai,TenLoai) values ('ab', 'cd');
--KIEM TRA DINH DANG CAC LOAI MA 
--Mã khách hàng:
ALTER TABLE KhachHang
ADD CONSTRAINT CK_MaKhachHang CHECK (LEN(MaKhachHang) = 6 AND MaKhachHang LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9]');

--Mã bảo hiểm
ALTER TABLE NhanVienFullTime
ADD CONSTRAINT CK_MaBaoHiem CHECK (LEN(BaoHiem) = 10 AND BaoHiem LIKE '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]');

--Mã nhà cung cấp:
ALTER TABLE NhaCungCap
ADD CONSTRAINT CK_MaNhaCungCap CHECK (LEN(MaNhaCungCap) = 6 AND MaNhaCungCap LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]');

--Mã lô hàng:
ALTER TABLE LoHang
ADD CONSTRAINT CK_MaLoHang CHECK (LEN(MaLoHang) = 6 AND MaLoHang LIKE '[A-Z][0-9][0-9][0-9][0-9][0-9]');

--Mã hàng hóa:
ALTER TABLE HangHoa
ADD CONSTRAINT CK_MaHangHoa CHECK (LEN(MaHangHoa) = 7 AND MaHangHoa LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9]');

-- Mã loại
ALTER TABLE Loai
ADD CONSTRAINT CK_MaLoai CHECK (LEN(MaLoai) = 3 AND MaLoai LIKE '[A-Z][A-Z][0-9]');

--Mã kho hàng:
ALTER TABLE KhoHang
ADD CONSTRAINT CK_MaKhoHang CHECK (LEN(MaKhoHang) = 2 AND MaKhoHang LIKE '[A-Z][0-9]');

--Mã hóa đơn:
ALTER TABLE HoaDon
ADD CONSTRAINT CK_MaHoaDon CHECK (LEN(MaHoaDon) = 8 AND MaHoaDon LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--Mã nhân viên:
ALTER TABLE NhanVien
ADD CONSTRAINT CK_MaNhanVien CHECK (LEN(MaNhanVien) = 7 AND MaNhanVien LIKE '[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]')

--Mã hợp đồng thời vụ:
ALTER TABLE NhanVienPartTime
ADD CONSTRAINT CK_MaHopDongThoiVu CHECK (LEN(HopDongThoiVu) = 8 AND HopDongThoiVu LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9]');

--Số căn cước công dân:
ALTER TABLE NhanVien
ADD CONSTRAINT CK_CanCuocCongDan CHECK (LEN(CanCuocCongDan) = 12 AND CanCuocCongDan LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

--INSERT DU LIEU VAO BANG
-- Chèn dữ liệu nhân viên full-time cho bảng nhân viên
INSERT INTO NhanVien (MaNhanVien, SoDienThoai, NgayThangNamSinh, NgayBatDauLam, HoTen, GioiTinh, DiaChi, Email, MaQuanLy, CanCuocCongDan)
VALUES 
('F000001', '0123456789', '1990-01-01', '2018-01-01', 'Nguyen Van An', 'Nam', '16 Duong Ly Thuong Kiet Quan 10', 'a1@gmail.com', NULL, '123456789012'),
('F000002', '0987654123', '1985-05-05', '2019-05-05', 'Tran Thi Binh', 'Nu', '48 Duong Nguyen Thi Minh Khai Quan 8', 'b1@gmail.com', 'F000001', '234567890123'),
('F000003', '0987654321', '1985-05-05', '2019-05-05', 'Tran Thi Be', 'Nu', '267 Duong Cach Mang Thang Tam Quan 10', 'b2@gmail.com', 'F000001', '345678901234'),
('F000004', '0912345876', '1986-06-06', '2018-06-06', 'Le Van Cuong', 'Nam', '39 Duong Dien Bien Phu Quan 7', 'c1@gmail.com', 'F000001', '456789012345'),
('F000006', '0923456789', '1987-07-07', '2019-07-07', 'Nguyen Thi Duong', 'Nu', '102 Duong Nguyen Van Cu Quan Tan Binh', 'd1@gmail.com', 'F000001', '567890123456'),
('F000007', '0934567890', '1988-08-08', '2022-08-08', 'Pham Van Nghia', 'Nam', '6 Duong Le Van Sy Quan 6', 'e1@gmail.com', 'F000001', '678901234567'),
('F000008', '0945678901', '1989-09-09', '2023-09-09', 'Hoang Thi Pha', 'Nu', '90 Duong Truong Chinh Quan 7', 'f1@gmail.com', 'F000002', '789012345678'),
('F000009', '0956789012', '1990-10-10', '2020-10-10', 'Tran Van Giao', 'Nam', '44 Duong Nguyen Tri Phuong Quan 3', 'g1@gmail.com', 'F000002', '890123456789'),
('F000010', '0967890123', '1991-11-11', '2019-11-11', 'Le Thi Hien', 'Nu', '408 Duong Bui Vien Quan 1', 'h1@gmail.com', 'F000002', '901234567890'),
('F000011', '0978901234', '1992-12-12', '2012-12-12', 'Nguyen Van Y', 'Nam', '172 Duong Hai Ba Trung Quan 2', 'i1@gmail.com', 'F000002', '012345678901'),
('F000012', '0989012345', '1993-01-01', '2021-01-01', 'Pham Thi Nga', 'Nu', '703 Duong Nguyen Trai Quan 8', 'j1@gmail.com', 'F000002', '123456789013'),
('F000013', '0990123456', '1994-02-02', '2019-02-02', 'Hoang Van Kien', 'Nam', '605 Duong Le Loi Quan 3', 'k1@gmail.com', 'F000003', '234567890124'),
('F000014', '0901234567', '1995-03-03', '2020-03-03', 'Tran Thi Linh', 'Nu', '31 Duong Ton Duc Thang Quan 9', 'l1@gmail.com', 'F000003', '345678901235'),
('F000015', '0912345678', '1996-04-04', '2018-04-04', 'Le Van Manh', 'Nam', '86 Duong Pham Ngu Lao Quan 5', 'm1@gmail.com', 'F000003', '456789012346'),
('F000016', '0909090909', '1992-06-10', '2021-01-10', 'Le Minh Cuong', 'Nam', '221 Duong Nguyen Hue Quan 1', 'c2@gmail.com', 'F000003', '678901234765');

-- Chèn dữ liệu nhân viên part-time cho bảng nhân viên
INSERT INTO NhanVien (MaNhanVien, SoDienThoai, NgayThangNamSinh, NgayBatDauLam, HoTen, GioiTinh, DiaChi, Email, MaQuanLy, CanCuocCongDan)
VALUES 
('P000001', '0161818181', '1991-07-07', '2020-07-07', 'Hoang Thi Dung', 'Nu', '135 Duong Hoang Van Thu Quan 10', 'd2@gmail.com', 'F000004', '789012345876'),
('P000002', '0161919191', '1993-08-08', '2021-08-08', 'Pham Van Phu', 'Nam', '247 Duong Nguyen Oanh Quan Nha Be', 'e2@gmail.com', 'F000004', '890123456987'),
('P000003', '0161826262', '1992-01-07', '2020-01-07', 'Nguyen Thi Suong', 'Nu', '359 Duong Phan Dang Luu Quan 9', 'f2@gmail.com', 'F000004', '901234567098'),
('P000004', '0161836363', '1993-02-08', '2020-02-08', 'Le Van Phap', 'Nam', '481 Duong Le Hong Phong Quan 4', 'g2@gmail.com', 'F000004', '012345678109'),
('P000005', '0161846464', '1994-03-09', '2020-03-09', 'Phan Thi Han', 'Nu', '592 Duong Truong Sa Quan 6', 'h2@gmail.com', 'F000004', '123456789014'),
('P000006', '0161856565', '1995-04-10', '2020-04-10', 'Tran Van Binh', 'Nam', '613 Duong Hoang Dieu Quan 9', 'i2@gmail.com', 'F000008', '234567890125'),
('P000007', '0161866666', '1996-05-11', '2020-05-11', 'Hoang Thi Dang', 'Nu', '724 Duong Dinh Tien Hoang Quan 1', 'j2@gmail.com', 'F000008', '345678901236'),
('P000008', '0161876767', '1997-06-12', '2020-06-12', 'Pham Van Phi', 'Nam', '836 Duong Cong Hoa', 'k2@gmail.com', 'F000008', '456789012347'),
('P000009', '0161886868', '1998-07-13', '2020-07-13', 'Nguyen Thi Lenh', 'Nu', '947 Duong Nguyen Van Linh Quan Binh Chanh', 'l2@gmail.com', 'F000008', '567890123458'),
('P000010', '0161896969', '1999-08-14', '2020-08-14', 'Le Van Man', 'Nam', '159 Duong Xo Viet Nghe Tinh Quan 8', 'm2@gmail.com', 'F000008', '678901234569'),
('P000011', '0161707071', '1990-09-15', '2020-09-15', 'Phan Thi Nga', 'Nu', '268 Duong Pasteur Quan 1', 'n2@gmail.com', 'F000006', '789012345670'),
('P000012', '0161717172', '1991-10-16', '2020-10-16', 'Tran Van On', 'Nam', '379 Duong Bach Dang Quan 1', 'o2@gmail.com', 'F000006', '890123456781'),
('P000013', '0161727273', '1992-11-17', '2020-11-17', 'Hoang Thi Phuong', 'Nu', '481 Duong Vo Van Tan Quan 3', 'p2@gmail.com', 'F000006', '901234567892'),
('P000014', '0161737374', '1993-12-18', '2020-12-18', 'Pham Van Quynh', 'Nam', '593 Duong Le Thanh Ton Quan 7', 'q2@gmail.com', 'F000006', '012345678903'),
('P000015', '0161747475', '1994-01-19', '2021-01-19', 'Nguyen Thi Re', 'Nu', '604 Duong Ly Tu Trong Quan 2', 'r2@gmail.com', 'F000006', '123456789015'),
('P000016', '0161757576', '1995-02-20', '2021-02-20', 'Le Van Sang', 'Nam', '187 Duong Pham Van Dong Quan Tan binh', 's2@gmail.com', 'F000007', '234567890126'),
('P000017', '0161767677', '1996-03-21', '2021-03-21', 'Phan Thi Truc', 'Nu', '482 Duong Hoang Hoa Tham Quan Tan Binh', 't2@gmail.com', 'F000007', '345678901237'),
('P000025', '0222222223', '1994-09-09', '2022-09-09', 'Do Thi Thanh', 'Nu', '175 Duong Vo Van Ngan Quan 9', 'z2@gmail.com', 'F000007', '456789012348');

-- Chèn dữ liệu cho bảng NhanVienFullTime
INSERT INTO NhanVienFullTime (MaNhanVien, PhuCap, LuongCoBan, BaoHiem, NgayNghiPhepNam)
VALUES 
('F000001', 1500.00, 5000.00, 'ABCD123456', 13),
('F000002', 1600.00, 5500.00, 'EFGH234567', 14),
('F000003', 1700.00, 5200.00, 'IJKL345678', 15),
('F000004', 1800.00, 5700.00, 'MNOP456789', 16),
('F000006', 1900.00, 5300.00, 'QRST567890', 18),
('F000007', 2000.00, 5400.00, 'UVWX678901', 11),
('F000008', 2100.00, 5100.00, 'YZAB789012', 13),
('F000009', 2200.00, 5600.00, 'CDEF890123', 17),
('F000010', 2300.00, 5800.00, 'GHIJ901234', 15),
('F000011', 2400.00, 5900.00, 'KLMN012345', 10),
('F000012', 2500.00, 6000.00, 'OPQR123456', 12),
('F000013', 2600.00, 6200.00, 'STUV234567', 14),
('F000014', 2700.00, 6400.00, 'WXYZ345678', 15),
('F000015', 2800.00, 6300.00, 'ABCD456789', 16),
('F000016', 2900.00, 6500.00, 'EFGH567890', 13);

-- Chèn dữ liệu cho bảng NhanVienPartTime
INSERT INTO NhanVienPartTime (MaNhanVien, SoGioMoiTuan, LuongMoiGio, HopDongThoiVu)
VALUES 
('P000001', 20, 120.00, 'AB123456'),
('P000002', 18, 110.00, 'CD234567'),
('P000003', 25, 115.00, 'EF345678'),
('P000004', 22, 105.00, 'GH456789'),
('P000005', 30, 130.00, 'IJ567890'),
('P000006', 24, 125.00, 'KL678901'),
('P000007', 28, 140.00, 'MN789012'),
('P000008', 20, 135.00, 'OP890123'),
('P000009', 26, 150.00, 'QR901234'),
('P000010', 23, 145.00, 'ST012345'),
('P000011', 21, 100.00, 'UV123456'),
('P000012', 19, 110.00, 'WX234567'),
('P000013', 27, 115.00, 'YZ345678'),
('P000014', 29, 120.00, 'AB456789'),
('P000015', 22, 130.00, 'CD567890'),
('P000016', 25, 125.00, 'EF678901'),
('P000017', 26, 140.00, 'GH789012'),
('P000025', 24, 135.00, 'IJ890123');

-- Chèn dữ liệu cho bảng KhoHang
INSERT INTO KhoHang (MaKhoHang, SucChua)
VALUES 
('A1',  5000),
('B2',  6000),
('C3',  7000),
('D4',  800),
('E5',  900),
('F6',  4500),
('G7',  1900),
('H8',  1200),
('I9',  1300),
('J0',  1400);


-- Chèn dữ liệu cho bảng Loai
INSERT INTO Loai (MaLoai, TenLoai)
VALUES 
('TP1', 'Thuc pham'),     -- Thực phẩm
('DU1', 'Do uong'),       -- Đồ uống
('NS1', 'Nong san'),      -- Nông sản
('VP1', 'Van phong pham'),-- Văn phòng phẩm
('DA1', 'Do an nhanh');   -- Đồ ăn nhanh

-- Chèn dữ liệu cho bảng Hoanghoa
INSERT INTO HangHoa (MaHangHoa, Ten, Gia, DonViTinh, MaLoai,SoLuongConLai)
VALUES
-- Thực phẩm

('DE54321', 'Sua Milo', 8000.00, 'hop', 'TP1','100'),
('AB34567', 'My 3 mien', 200000.00, 'thung', 'TP1','20'),
('CD67890', 'Keo bac ha', 25000.00, 'goi', 'TP1','50'),
('GH43210', 'Sua ong tho', 22000.00, 'lon', 'TP1','15'),
('IJ65432', 'Sua TH true milk', 7000.00, 'hop', 'TP1','30'),
('QR54321', 'Mi SiuKay', 15000.00, 'goi', 'TP1','18'),
('WX87654', 'Nam kim cham', 12000.00, 'goi', 'TP1','24'),
('EF21098', 'Nuoc tuong Magi', 27000.00, 'chai', 'TP1','47'),
('AB09876', 'Kim chi Han Quoc', 31000.00, 'hop', 'TP1','25'),
('CD10987', 'Bento', 27000.00, 'bao', 'TP1','27'),

-- Đồ uống
('XY98765', 'Sting', 15000.00, 'chai', 'DU1','36'),
('EF56789', 'Soju', 35000.00, 'chai', 'DU1','19'),
('KL87654', 'Nuoc suoi', 5000.00, 'chai', 'DU1','47'),
('MN76543', 'Monster', 30000.00, 'lon', 'DU1','52'),
('OP43210', 'Nuoc dao', 25000.00, 'hop', 'DU1','35'),
('ST65432', 'Yakult', 5000.00, 'chai', 'DU1','99'),
('YZ98765', 'Strongbow', 22000.00, 'lon', 'DU1','14'),
('HH00131', 'Sua Oatside', 25000.00, 'Loc', 'DU1','56'),
('HH00132', 'Tra', 20000.00, 'Tui', 'DU1','44'),

-- Nông sản
('UN12345', 'Ca rot', 18000.00, 'kg', 'NS1','18'),
('UV76543', 'Tao Fuji', 49000.00, 'kg', 'NS1','107'),
('GH32109', 'Dua leo', 10000.00, 'kg', 'NS1','57'),
('HH00128', 'Ca tim', 10000.00, 'Kg', 'NS1','78'),

-- Văn phòng phẩm
('HH00123', 'But bi', 5000.00, 'Cai', 'VP1','89'),
('HH00124', 'Tap hoc sinh', 12000.00, 'Quyen', 'VP1','74'),
('HH00125', 'Gom', 3000.00, 'Cai', 'VP1','36'),
('HH00126', 'Giay A4', 300.00, 'To', 'VP1','47'),
('HH00127', 'Keo', 15000.00, 'Cai', 'VP1','42'),

-- Đồ ăn nhanh
('HH00129', 'Snack', 15000.00, 'Goi', 'DA1','35'),
('HH00130', 'Banh mi', 20000.00, 'Tui', 'DA1','41');

-- Chèn dữ liệu cho bảng NhaCungCap
INSERT INTO NhaCungCap (MaNhaCungCap, SoDienThoai, DiaChi, Email, Ten)
VALUES 
('ABC123', '0123456789', '608 Duong Ly Thuong Kiet Quan 10 ', 'abc123@gmail.com', 'Cong ty Yonex'),
('DEF456', '0987654321', '161 Duong Nguyen Thai Hoc Quan 1', 'def456@gmail.com', 'Cong ty Aqua'),
('GHI789', '0912345678', '194 Duong Hoang Van Thu Quan Phu Nhuan', 'ghi789@gmail.com', 'Cong ty Que Anh'),
('JKL012', '0923456789', '235 Duong Nguyen Van Cu Quan 5', 'jkl012@gmail.com', 'Cong ty Thuan Phat'),
('MNO345', '0934567890', '276 Duong Nam Ky Khoi Nghia Quan 1', 'mno345@gmail.com', 'Cong ty Gia Tri'),
('PQR678', '0945678901', '47 Duong Pham Ngoc Thach Quan Tan Binh', 'pqr678@gmail.com', 'Cong ty Cokacola'),
('STU901', '0956789012', '164 Duong Dong Khoi Quan 4', 'stu901@gmail.com', 'Cong ty Phuoc Hien'),
('VWX234', '0967890123', '75 Duong Nguyen Thi Minh Khai Quan 3', 'vwx234@gmail.com', 'Cong ty Nestle'),
('YZA567', '0978901234', '129 Duong Pasteur Quan 1', 'yza567@gmail.com', 'Cong ty Nam Nguyen'),
('BCD890', '0989012345', '187 Duong Vo Van Ngan Quan 9', 'bcd890@gmail.com', 'Cong ty Kawasaki ');
-- Thêm nhà cung cấp
INSERT INTO NhaCungCap (MaNhaCungCap, SoDienThoai, DiaChi, Email, Ten)
VALUES
('NCC001', '0123456780', '333 Ly Thuong Kiet, Quan 10', 'ncc1@gmail.com', 'Cong ty Uniqlo'),
('NCC002', '0987654320', '444 Hoang Hoa Tham, Quan 5', 'ncc2@gmail.com', 'Cong ty Phat Oi');
-- Chèn dữ liệu cho bảng LoHang
INSERT INTO LoHang (MaLoHang, MaNhaCungCap, NguonGoc, NgaySanXuat, HanSuDung, NgayCungCap, ChiPhiLoHang)
VALUES
('A01234', 'ABC123', 'Vietnam', '2023-11-01', '2024-05-01', '2023-12-01', 500000.00), -- Sua Milo
('B12345', 'DEF456', 'Vietnam', '2023-10-01', '2024-04-01', '2023-11-15', 200000.00), -- My 3 mien
('C23456', 'GHI789', 'Thailand', '2023-09-01', '2024-03-01', '2023-10-20', 350000.00), -- Keo bac ha
('D34567', 'JKL012', 'Vietnam', '2023-08-01', '2024-02-01', '2023-09-10', 150000.00), -- Sua ong tho
('E45678', 'MNO345', 'USA', '2023-07-01', '2024-01-01', '2023-08-25', 300000.00), -- Sua TH true milk
('F56789', 'PQR678', 'Vietnam', '2023-06-01', '2023-12-01', '2023-07-15', 180000.00), -- Mi SiuKay
('G67890', 'STU901', 'Japan', '2023-05-01', '2023-11-01', '2023-06-10', 240000.00), -- Nam kim cham
('H78901', 'VWX234', 'Vietnam', '2023-04-01', '2023-10-01', '2023-05-15', 470000.00), -- Nuoc tuong Magi
('I89012', 'YZA567', 'Korea', '2023-03-01', '2023-09-01', '2023-04-25', 250000.00), -- Kim chi Han Quoc
('J90123', 'BCD890', 'Thailand', '2023-02-01', '2023-08-01', '2023-03-20', 270000.00), -- Bento
('K01234', 'ABC123', 'Vietnam', '2023-01-01', '2023-07-01', '2023-02-10', 500000.00), -- Sting
('L12345', 'DEF456', 'Korea', '2023-02-01', '2023-08-01', '2023-03-10', 600000.00), -- Soju
('M23456', 'GHI789', 'Vietnam', '2023-03-01', '2023-09-01', '2023-04-15', 700000.00), -- Nuoc suoi
('N34567', 'JKL012', 'USA', '2023-04-01', '2023-10-01', '2023-05-20', 800000.00), -- Monster
('O45678', 'MNO345', 'Thailand', '2023-05-01', '2023-11-01', '2023-06-25', 900000.00), -- Nuoc dao
('P56789', 'PQR678', 'Vietnam', '2023-06-01', '2023-12-01', '2023-07-30', 1000000.00), -- Yakult
('Q67890', 'STU901', 'Korea', '2023-07-01', '2024-01-01', '2023-08-15', 1100000.00), -- Strongbow
('R78901', 'VWX234', 'Vietnam', '2023-08-01', '2024-02-01', '2023-09-10', 1200000.00), -- Sua Oatside
('S89012', 'YZA567', 'USA', '2023-09-01', '2024-03-01', '2023-10-05', 1300000.00), -- Tra
('T90123', 'BCD890', 'Vietnam', '2023-10-01', '2024-04-01', '2023-11-20', 1400000.00), -- Ca rot
('U01234', 'ABC123', 'Japan', '2023-11-01', '2024-05-01', '2023-12-01', 1500000.00), -- Tao Fuji
('V12345', 'DEF456', 'Vietnam', '2023-12-01', '2024-06-01', '2024-01-15', 1600000.00), -- Dua leo
('W23456', 'GHI789', 'Thailand', '2024-01-01', '2024-07-01', '2024-02-10', 1700000.00), -- Ca tim
('X34567', 'JKL012', 'Vietnam', '2024-02-01', '2024-08-01', '2024-03-20', 1800000.00), -- But bi
('Y45678', 'MNO345', 'Japan', '2024-03-01', '2024-09-01', '2024-04-25', 1900000.00), -- Tap hoc sinh
('Z56789', 'PQR678', 'Korea', '2024-04-01', '2024-10-01', '2024-05-30', 2000000.00), -- Gom
('A67891', 'STU901', 'Vietnam', '2024-05-01', '2024-11-01', '2024-06-10', 2100000.00), -- Giay A4
('B78902', 'VWX234', 'Thailand', '2024-06-01', '2024-12-01', '2024-07-15', 2200000.00), -- Keo
('C89013', 'YZA567', 'USA', '2024-07-01', '2025-01-01', '2024-08-20', 2300000.00), -- Snack
('D90124', 'BCD890', 'Japan', '2024-08-01', '2025-02-01', '2024-09-25', 2400000.00); -- Banh mi


-- Chèn dữ liệu cho bảng HoaDon
INSERT INTO HoaDon (MaHoaDon, TienKhachHangDua, ThoiGianXuatHoaDon)
VALUES 
('12345678', 150000.00, '2024-10-01 10:00:00'),
('23456789', 200000.00, '2024-10-02 11:00:00'),
('34567890', 175000.00, '2024-10-03 12:00:00'),
('45678901', 220000.00, '2024-10-04 13:00:00'),
('56789012', 180000.00, '2024-10-05 14:00:00'),
('67890123', 160000.00, '2024-10-06 15:00:00'),
('78901234', 210000.00, '2024-10-07 16:00:00'),
('89012345', 190000.00, '2024-10-08 17:00:00'),
('90123456', 225000.00, '2024-10-09 18:00:00'),
('01234567', 155000.00, '2024-10-10 19:00:00'),
('09876543', 160000.00, '2024-10-11 10:00:00'),
('98765432', 170000.00, '2024-10-12 11:00:00'),
('87654321', 180000.00, '2024-10-13 12:00:00'),
('76543210', 190000.00, '2024-10-14 13:00:00'),
('65432109', 200000.00, '2024-10-15 14:00:00'),
('54321098', 210000.00, '2024-10-16 15:00:00'),
('43210987', 220000.00, '2024-10-17 16:00:00'),
('32109876', 230000.00, '2024-10-18 17:00:00'),
('21098765', 240000.00, '2024-10-19 18:00:00'),
('10987654', 250000.00, '2024-10-20 19:00:00'),
('90876543', 260000.00, '2024-10-21 10:00:00'),
('80765432', 270000.00, '2024-10-22 11:00:00'),
('70654321', 280000.00, '2024-10-23 12:00:00'),
('60543210', 290000.00, '2024-10-24 13:00:00'),
('50432109', 300000.00, '2024-10-25 14:00:00'),
('40321098', 310000.00, '2024-10-26 15:00:00'),
('30210987', 320000.00, '2024-10-27 16:00:00'),
('20109876', 330000.00, '2024-10-28 17:00:00'),
('10098765', 340000.00, '2024-10-29 18:00:00'),
('00987654', 350000.00, '2024-10-30 19:00:00');

-- Chèn dữ liệu cho bảng KhachHang
INSERT INTO KhachHang (MaKhachHang, HoTen)
VALUES 
('AB1234', 'Nguyen Van Phi'),
('CD5678', 'Tran Thi Ngoc'),
('EF9012', 'Le Van My'),
('GH3456', 'Pham Thi Lan'),
('IJ7890', 'Hoang Van Thuan'),
('KL1234', 'Vu Thi Suong'),
('MN5678', 'Do Van Ky'),
('OP9012', 'Phan Thi Hoan'),
('QR3456', 'Nguyen Thi Nguyet'),
('ST7890', 'Le Van Nang'),
('UV1234', 'Tran Thi Ngoan'),
('WX5678', 'Nguyen Van Luc'),
('YZ9012', 'Pham Thi My'),
('AB3456', 'Hoang Van Nam'),
('CD7890', 'Do Thi On'),
('EF1234', 'Nguyen Van Phuc'),
('GH5678', 'Le Thi Quyen'),
('IJ9012', 'Pham Van Khoa'),
('KL3456', 'Hoang Thi Hanh'),
('MN7890', 'Tran Van Tien'),
('OP1234', 'Nguyen Thi Uyen'),
('QR5678', 'Le Van Vy'),
('ST9012', 'Pham Thi Tam'),
('UV3456', 'Hoang Van Xuan'),
('WX7890', 'Do Van Y'),
('YZ1234', 'Nguyen Thi Kim'),
('AB5678', 'Tran Van Son'),
('CD9012', 'Le Van Chien'),
('EF3456', 'Pham Thi Kim Cuong'),
('GH7890', 'Hoang Van Viet');

-- Chèn dữ liệu cho bảng SoDienThoai
INSERT INTO SoDienThoai (MaKhachHang, SoDienThoai)
VALUES 
('AB1234', '0123456780'),
('CD5678', '0123456781'),
('EF9012', '0123456782'),
('GH3456', '0123456783'),
('IJ7890', '0123456784'),
('KL1234', '0123456785'),
('MN5678', '0123456786'),
('OP9012', '0123456787'),
('QR3456', '0123456788'),
('ST7890', '0123456789'),
('UV1234', '0123456790'),
('WX5678', '0123456791'),
('YZ9012', '0123456792'),
('AB3456', '0123456793'),
('CD7890', '0123456794'),
('EF1234', '0123456795'),
('GH5678', '0123456796'),
('IJ9012', '0123456797'),
('KL3456', '0123456798'),
('MN7890', '0123456799'),
('OP1234', '0123456700'),
('QR5678', '0123456701'),
('ST9012', '0123456702'),
('UV3456', '0123456703'),
('WX7890', '0123456704'),
('YZ1234', '0123456705'),
('AB5678', '0123456706'),
('CD9012', '0123456707'),
('EF3456', '0123456708'),
('GH7890', '0123456709');

-- Chèn dữ liệu cho bảng LuuTru
INSERT INTO LuuTru (MaLoHang, MaNhaCungCap, MaKhoHang, SoLuongLoHang, NgayLuuTru)
VALUES 
('A01234', 'ABC123', 'A1', 1, '2024-01-01'),
('B12345', 'DEF456', 'B2', 1, '2024-02-01'),
('C23456', 'GHI789', 'C3',1, '2024-03-01'),
('D34567', 'JKL012', 'D4', 1, '2024-04-01'),
('E45678', 'MNO345', 'E5', 1, '2024-05-01'),
('F56789', 'PQR678', 'F6', 1, '2024-06-01'),
('G67890', 'STU901', 'G7', 1, '2024-07-01'),
('H78901', 'VWX234', 'H8', 1, '2024-08-01'),
('I89012', 'YZA567', 'I9', 1, '2024-09-01'),
('J90123', 'BCD890', 'J0', 1, '2024-10-01'),

('K01234', 'ABC123', 'A1', 1, '2024-01-15'),
('L12345', 'DEF456', 'B2', 1, '2024-02-15'),
('M23456', 'GHI789', 'C3', 1, '2024-03-15'),
('N34567', 'JKL012', 'D4', 1, '2024-04-15'),
('O45678', 'MNO345', 'E5', 1, '2024-05-15'),
('P56789', 'PQR678', 'F6', 1, '2024-06-15'),
('Q67890', 'STU901', 'G7', 1, '2024-07-15'),
('R78901', 'VWX234', 'H8', 1, '2024-08-15'),
('S89012', 'YZA567', 'I9', 1, '2024-09-15'),
('T90123', 'BCD890', 'J0', 1, '2024-10-15'),

('U01234', 'ABC123', 'A1', 1, '2024-11-01'),
('V12345', 'DEF456', 'A1', 1, '2024-11-02'),
('W23456', 'GHI789', 'A1', 1, '2024-11-03'),
('X34567', 'JKL012', 'A1', 1, '2024-11-04'),
('Y45678', 'MNO345', 'A1', 1, '2024-11-05'),
('Z56789', 'PQR678', 'A1', 1, '2024-11-06'),
('A67891', 'STU901', 'A1', 1, '2024-11-07'),
('B78902', 'VWX234', 'A1', 1, '2024-11-08'),
('C89013', 'YZA567', 'A1', 1, '2024-11-09'),
('D90124', 'BCD890', 'A1', 1, '2024-11-10');


-- Chèn dữ liệu cho bảng MuaHang
INSERT INTO MuaHang (MaHoaDon, MaKhachHang, MaNhanVien)
VALUES 
('12345678', 'AB1234', 'F000001'),
('23456789', 'CD5678', 'F000002'),
('34567890', 'EF9012', 'F000003'),
('45678901', 'GH3456', 'F000004'),
('56789012', 'IJ7890', 'F000006'),
('67890123', 'KL1234', 'F000007'),
('78901234', 'MN5678', 'F000008'),
('89012345', 'OP9012', 'F000009'),
('90123456', 'QR3456', 'F000010'),
('01234567', 'ST7890', 'F000011'),
('09876543', 'UV1234', 'F000012'),
('98765432', 'WX5678', 'F000013'),
('87654321', 'YZ9012', 'F000014'),
('76543210', 'AB3456', 'F000015'),
('65432109', 'CD7890', 'F000016'),
('54321098', 'EF1234', 'F000001'),
('43210987', 'GH5678', 'F000002'),
('32109876', 'IJ9012', 'F000003'),
('21098765', 'KL3456', 'F000004'),
('10987654', 'MN7890', 'F000006'),
('90876543', 'OP1234', 'F000007'),
('80765432', 'QR5678', 'F000008'),
('70654321', 'ST9012', 'F000009'),
('60543210', 'UV3456', 'F000010'),
('50432109', 'WX7890', 'F000011'),
('40321098', 'YZ1234', 'F000012'),
('30210987', 'AB5678', 'F000013'),
('20109876', 'CD9012', 'F000014'),
('10098765', 'EF3456', 'F000015'),
('00987654', 'GH7890', 'F000016');

-- Chèn dữ liệu cho bảng QuanLy
INSERT INTO QuanLy (MaNhanVien, MaKhoHang)
VALUES 
('P000001', 'A1'),
('P000002', 'B2'),
('P000003', 'C3'),
('P000004', 'D4'),
('P000005', 'E5'),
('P000006', 'F6'),
('P000007', 'G7'),
('P000008', 'H8'),
('P000009', 'I9'),
('P000010', 'J0'),
('P000011', 'A1'), -- Các nhân viên khác quản lý kho hàng đã có
('P000012', 'B2'),
('P000013', 'C3'),
('P000014', 'D4'),
('P000015', 'E5'),
('P000016', 'F6'),
('P000017', 'G7'),
('P000025', 'H8');

-- Chèn dữ liệu cho bảng Tang
INSERT INTO Tang (MaKhoHang, SoTang)
VALUES 
('A1', 1),
('A1', 2),
('A1', 3),
('B2', 1),
('B2', 2),
('B2', 3),
('C3', 1),
('C3', 2),
('C3', 3),
('D4', 1),
('D4', 2),
('D4', 3),
('D4', 4),
('E5', 1),
('E5', 2),
('E5', 3),
('F6', 1),
('F6', 2),
('G7', 1),
('G7', 2),
('H8', 1),
('H8', 2),
('I9', 1),
('I9', 2),
('J0', 1),
('J0', 2),
('J0', 3);
--Insert bảng Chua 
INSERT INTO Chua (MaHangHoa, MaNhaCungCap, MaLoHang, SoluongHangHoa)
VALUES 
('DE54321', 'ABC123', 'A01234', 100), -- Sua Milo trong lô hàng A01234
('AB34567', 'DEF456', 'B12345', 20),  -- My 3 mien trong lô hàng B12345
('CD67890', 'GHI789', 'C23456', 50),  -- Keo bac ha trong lô hàng C23456
('GH43210', 'JKL012', 'D34567', 15),  -- Sua ong tho trong lô hàng D34567
('IJ65432', 'MNO345', 'E45678', 30),  -- Sua TH true milk trong lô hàng E45678
('QR54321', 'PQR678', 'F56789', 18),  -- Mi SiuKay trong lô hàng F56789
('WX87654', 'STU901', 'G67890', 24),  -- Nam kim cham trong lô hàng G67890
('EF21098', 'VWX234', 'H78901', 47),  -- Nuoc tuong Magi trong lô hàng H78901
('AB09876', 'YZA567', 'I89012', 25),  -- Kim chi Han Quoc trong lô hàng I89012
('CD10987', 'BCD890', 'J90123', 27),  -- Bento trong lô hàng J90123

('XY98765', 'ABC123', 'K01234', 36), -- Sting trong lô hàng K01234
('EF56789', 'DEF456', 'L12345', 19), -- Soju trong lô hàng L12345
('KL87654', 'GHI789', 'M23456', 47), -- Nuoc suoi trong lô hàng M23456
('MN76543', 'JKL012', 'N34567', 52), -- Monster trong lô hàng N34567
('OP43210', 'MNO345', 'O45678', 35), -- Nuoc dao trong lô hàng O45678
('ST65432', 'PQR678', 'P56789', 99), -- Yakult trong lô hàng P56789
('YZ98765', 'STU901', 'Q67890', 14), -- Strongbow trong lô hàng Q67890
('HH00131', 'VWX234', 'R78901', 56), -- Sua Oatside trong lô hàng R78901
('HH00132', 'YZA567', 'S89012', 44), -- Tra trong lô hàng S89012
('UN12345', 'BCD890', 'T90123', 180), -- Ca rot trong lô hàng T90123

('UV76543', 'ABC123', 'U01234', 107), -- Tao Fuji trong lô hàng U01234
('GH32109', 'DEF456', 'V12345', 57), -- Dua leo trong lô hàng V12345
('HH00128', 'GHI789', 'W23456', 78), -- Ca tim trong lô hàng W23456
('HH00123', 'JKL012', 'X34567', 89), -- But bi trong lô hàng X34567
('HH00124', 'MNO345', 'Y45678', 74), -- Tap hoc sinh trong lô hàng Y45678
('HH00125', 'PQR678', 'Z56789', 36), -- Gom trong lô hàng Z56789
('HH00126', 'STU901', 'A67891', 47), -- Giay A4 trong lô hàng A67891
('HH00127', 'VWX234', 'B78902', 42), -- Keo trong lô hàng B78902
('HH00129', 'YZA567', 'C89013',35), -- Snack trong lô hàng C89013
('HH00130', 'BCD890', 'D90124', 41); -- Banh mi trong lô hàng D90124

-- Chèn dữ liệu cho bảng ChuaThongTin
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa,Soluong)
VALUES 
('12345678', 'UN12345',5), --Mot khach
('12345678', 'DE54321',2),
('12345678', 'MN76543',3),
('23456789', 'DE54321',1), --Mot khach
('23456789', 'IJ65432',7),
('23456789', 'AB34567',4),
('34567890', 'AB34567',7), --Mot khach
('34567890', 'XY98765',6),
('34567890', 'DE54321',2),
('45678901', 'AB34567',10), --Mot khach
('45678901', 'EF56789',1),
('45678901', 'XY98765',6),
('56789012', 'CD67890',2), --Mot khach
('56789012', 'MN76543',4),
('56789012', 'DE54321',5),
('56789012', 'UN12345',7),
('67890123', 'EF56789',9), --Mot khach
('78901234', 'GH43210',11), --Mot khach
('89012345', 'IJ65432',17), --Mot khach
('90123456', 'KL87654',14), --Mot khach
('01234567', 'MN76543',35), --Mot khach
('09876543', 'OP43210',10), --Mot khach
('98765432', 'QR54321',4), --Mot khach
('87654321', 'ST65432',9), --Mot khach
('76543210', 'UV76543',4), --Mot khach
('65432109', 'WX87654',7), --Mot khach
('54321098', 'YZ98765',10), --Mot khach
('43210987', 'AB09876',17), --Mot khach
('43210987', 'GH43210',2),
('43210987', 'MN76543',3),
('43210987', 'CD67890',4),
('43210987', 'YZ98765',5),
('32109876', 'CD10987',4), --Mot khach
('21098765', 'EF21098',6), --Mot khach
('10987654', 'GH32109',10), --Mot khach
('90876543', 'UN12345',8), --Mot khach
('80765432', 'DE54321',7), --Mot khach
('70654321', 'XY98765',4), --Mot khach
('60543210', 'AB34567',4), --Mot khach
('50432109', 'CD67890',3), --Mot khach
('40321098', 'EF56789',7), --Mot khach
('30210987', 'GH43210',7), --Mot khach
('20109876', 'IJ65432',6), --Mot khach
('10098765', 'KL87654',6), --Mot khach
('00987654', 'MN76543',1); --Mot khach

-- Chèn dữ liệu cho bảng DiaChi
INSERT INTO DiaChi (MaKhachHang, SoNha, TenDuong, Phuong, Quan)
VALUES 
('AB1234', 123, 'Hai Ba Trung', 'Tan Dinh', '1'),
('CD5678', 456, 'Tran Phu', '2', 'Phu Nhuan'),
('EF9012', 789, 'Nam Ky Khoi Nghia', 'Vo Thi Sau', '3'),
('GH3456', 101, 'To Hien Thanh', '14', '10'),
('IJ7890', 202, 'Dien Bien Phu', '2', '3'),
('KL1234', 303, 'Phan Xich Long', '3', 'Tan Binh'),
('MN5678', 404, 'Nguyen Dinh Chieu', 'Da Kao', '1'),
('OP9012', 505, 'Tran Phu', '1', 'Phu Nhuan'),
('QR3456', 606, 'Ly Thuong Kiet', '2', 'Tan Binh'),
('ST7890', 707, 'To Hien Thanh', '3', '10'),
('UV1234', 808, 'Dien Bien Phu', 'Vo Thi Sau', 'Phu Nhuan'),
('WX5678', 909, 'Phan Xich Long', '1', 'Tan Binh'),
('YZ9012', 110, 'Hai Ba Trung', '2', 'Binh Thanh'),
('AB3456', 211, 'Tran Phu', '3', 'Phu Nhuan'),
('CD7890', 312, 'Ly Thuong Kiet', 'Vo Thi Sau', 'Tan Binh'),
('EF1234', 413, 'To Hien Thanh', '1', 'Binh Thanh'),
('GH5678', 514, 'Dien Bien Phu', '2', 'Phu Nhuan'),
('IJ9012', 615, 'Phan Xich Long', '3', 'Tan Binh'),
('KL3456', 716, 'Hai Ba Trung', 'Vo Thi Sau', 'Binh Thanh'),
('MN7890', 817, 'Tran Phu', '1', 'Phu Nhuan'),
('OP1234', 918, 'Ly Thuong Kiet', '2', 'Tan Binh'),
('QR5678', 1019, 'To Hien Thanh', '3', 'Binh Thanh'),
('ST9012', 1120, 'Dien Bien Phu', 'Vo Thi Sau', 'Phu Nhuan'),
('UV3456', 1221, 'Phan Xich Long', '1', 'Tan Binh'),
('WX7890', 1322, 'Hai Ba Trung', '2', 'Binh Thanh'),
('YZ1234', 1423, 'Tran Phu', '3', 'Phu Nhuan'),
('AB5678', 1524, 'Ly Thuong Kiet', 'Vo Thi Sau', 'Tan Binh'),
('CD9012', 1625, 'To Hien Thanh', '1', 'Binh Thanh'),
('EF3456', 1726, 'Dien Bien Phu', '2', 'Phu Nhuan'),
('GH7890', 1827, 'Phan Xich Long', '3', 'Tan Binh');

-- Chèn dữ liệu cho bảng KiemTra
INSERT INTO KiemTra (MaHangHoa, MaNhanVien, TinhTrang, SoLuong)
VALUES 
('UN12345', 'P000001', 'Tot', 50),
('DE54321', 'P000002', 'Binh thuong', 70),
('XY98765', 'P000003', 'Can kiem tra', 90),
('AB34567', 'P000004', 'Hong', 20),
('CD67890', 'P000005', 'Tot', 100),
('EF56789', 'P000006', 'Binh thuong', 40),
('GH43210', 'P000007', 'Can kiem tra', 60),
('IJ65432', 'P000008', 'Hong', 30),
('KL87654', 'P000009', 'Tot', 80),
('MN76543', 'P000010', 'Binh thuong', 90),
('OP43210', 'P000011', 'Can kiem tra', 70),
('QR54321', 'P000012', 'Hong', 50),
('ST65432', 'P000013', 'Tot', 30),
('UV76543', 'P000014', 'Binh thuong', 60),
('WX87654', 'P000015', 'Can kiem tra', 90),
('YZ98765', 'P000016', 'Hong', 40),
('AB09876', 'P000017', 'Tot', 100),
('CD10987', 'P000025', 'Binh thuong', 80),
('EF21098', 'P000001', 'Can kiem tra', 20),
('GH32109', 'P000002', 'Hong', 30);

-- Thêm dữ liệu kiểm tra đóng góp 

-- Chèn hóa đơn trong 3 tháng gần đây
INSERT INTO HoaDon (MaHoaDon, TienKhachHangDua, ThoiGianXuatHoaDon)
VALUES 
('12345679', 150000.00, '2024-11-01 10:00:00'),
('23456790', 250000.00, '2024-11-02 11:00:00'),
('34567891', 175000.00, '2024-11-03 12:00:00'),
('45678902', 300000.00, '2024-11-04 13:00:00'),
('56789013', 280000.00, '2024-11-05 14:00:00'),
('67890124', 260000.00, '2024-11-06 15:00:00'),
('78901235', 180000.00, '2024-11-07 16:00:00'),
('89012346', 310000.00, '2024-11-08 17:00:00'),
('90123457', 250000.00, '2024-11-09 18:00:00'),
('01234568', 290000.00, '2024-11-10 19:00:00'),
('09876544', 320000.00, '2024-11-11 10:00:00'),
('98765433', 170000.00, '2024-11-12 11:00:00'),
('87654322', 230000.00, '2024-11-13 12:00:00'),
('76543211', 400000.00, '2024-11-14 13:00:00'),
('65432110', 350000.00, '2024-11-15 14:00:00'),
('54321099', 300000.00, '2024-11-16 15:00:00'),
('43210988', 220000.00, '2024-11-17 16:00:00'),
('32109877', 260000.00, '2024-11-18 17:00:00'),
('21098766', 280000.00, '2024-11-19 18:00:00'),
('10987655', 200000.00, '2024-11-20 19:00:00'),
('12345680', 240000.00, '2024-12-01 09:00:00'),
('23456791', 310000.00, '2024-12-02 10:30:00'),
('34567892', 270000.00, '2024-12-03 11:45:00'),
('45678903', 290000.00, '2024-12-04 14:00:00'),
('56789014', 330000.00, '2024-12-05 16:15:00');
-- Chèn thông tin sản phẩm cho từng hóa đơn
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa, SoLuong)
VALUES
-- Hóa đơn 1 khách hàng, nhiều sản phẩm
('12345679', 'UN12345', 2),
('12345679', 'XY98765', 1),
('23456790', 'MN76543', 3),
('23456790', 'AB34567', 1),
('34567891', 'CD67890', 4),
('34567891', 'EF56789', 2),
('45678902', 'IJ65432', 6),
('45678902', 'KL87654', 2),
('56789013', 'MN76543', 5),
('56789013', 'OP43210', 4),
-- Hóa đơn 1 sản phẩm
('67890124', 'QR54321', 7),
('78901235', 'ST65432', 3),
('89012346', 'UV76543', 4),
('90123457', 'WX87654', 6),
('01234568', 'YZ98765', 2),
('09876544', 'AB09876', 3),
('98765433', 'CD10987', 8),
('87654322', 'EF21098', 5),
('76543211', 'GH32109', 6),
('65432110', 'MN76543', 4),
-- Hóa đơn ngày 1/12
('12345680', 'UN12345', 3),
('12345680', 'CD67890', 2),
-- Hóa đơn ngày 2/12
('23456791', 'XY98765', 4),
('23456791', 'EF56789', 1),
('23456791', 'GH43210', 2),
-- Hóa đơn ngày 3/12
('34567892', 'IJ65432', 6),
-- Hóa đơn ngày 4/12
('45678903', 'KL87654', 7),
('45678903', 'MN76543', 3),
-- Hóa đơn ngày 5/12
('56789014', 'OP43210', 5),
('56789014', 'HH00123', 2),
('56789014', 'QR54321', 4);


--Liệt kê tên các khách hàng được nhân viên nam xử lý hóa đơn:
SELECT DISTINCT kh.HoTen
FROM KhachHang kh
JOIN MuaHang mh ON kh.MaKhachHang = mh.MaKhachHang
JOIN NhanVien nv ON mh.MaNhanVien = nv.MaNhanVien
WHERE nv.GioiTinh = 'Nam';

--Liệt kê tên hàng hóa trong hóa đơn được xuất bởi nhân viên đã làm việc cho cửa hàng trên 1
--năm (giả sử hiện tại là ngày 28/10/2024)
SELECT DISTINCT hh.Ten
FROM HangHoa hh
JOIN ChuaThongTin ct ON hh.MaHangHoa = ct.MaHangHoa
JOIN HoaDon hd ON ct.MaHoaDon = hd.MaHoaDon
JOIN MuaHang mh ON hd.MaHoaDon = mh.MaHoaDon
JOIN NhanVien nv ON mh.MaNhanVien = nv.MaNhanVien
WHERE DATEDIFF(YEAR, nv.NgayBatDauLam, '2024-10-28') > 1;

--Liệt kê tên các nhà cung cấp có lô hàng được lưu trữ tại tầng 3:
SELECT DISTINCT NCC.Ten
FROM NhaCungCap NCC
JOIN LoHang LH ON NCC.MaNhaCungCap = LH.MaNhaCungCap
JOIN LuuTru LT ON LH.MaLoHang = LT.MaLoHang AND LH.MaNhaCungCap = LT.MaNhaCungCap
JOIN Tang T ON LT.MaKhoHang = T.MaKhoHang
WHERE T.SoTang = 3;
select * from nhacungcap
--THEM CAC THU TUC
--Them thu tuc INSERT
CREATE OR ALTER PROCEDURE ThemNhanVien
    @MaNhanVien CHAR(7),
    @SoDienThoai CHAR(10),
    @NgayThangNamSinh DATE,
    @NgayBatDauLam DATE,
    @HoTen VARCHAR(100),
    @GioiTinh VARCHAR(3),
    @DiaChi VARCHAR(255),
    @Email VARCHAR(100),
    @MaQuanLy CHAR(7) = NULL,
    @CanCuocCongDan CHAR(12)
AS
BEGIN
    -- Kiểm tra tuổi nhân viên
    IF DATEDIFF(YEAR, @NgayThangNamSinh, GETDATE()) < 18
    BEGIN
        RAISERROR('Tuổi nhân viên phải lớn hơn 18!', 16, 1);
        RETURN;
    END

    -- Kiểm tra định dạng số điện thoại
    IF @SoDienThoai NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        RAISERROR('Số điện thoại không hợp lệ!', 16, 1);
        RETURN;
    END

	-- Kiểm tra trùng số điện thoại 
	IF EXISTS (SELECT 1 FROM NhanVien WHERE SoDienThoai = @SoDienThoai) 
	BEGIN 
		RAISERROR('Số điện thoại đã bị trùng, vui lòng kiểm tra lại!', 16, 1); 
		RETURN; 
	END

    -- Kiểm tra định dạng email
    IF @Email NOT LIKE '%@gmail.com'
    BEGIN
        RAISERROR('Email phải có định dạng @gmail.com!', 16, 1);
        RETURN;
    END

	-- Kiểm tra trùng email 
	IF EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email) 
	BEGIN 
		RAISERROR('Email đã bị trùng, vui lòng kiểm tra lại!', 16, 1); 
		RETURN; 
	END

	-- Kiểm tra trùng số căn cước công dân 
	IF EXISTS (SELECT 1 FROM NhanVien WHERE CanCuocCongDan = @CanCuocCongDan) 
	BEGIN 
		RAISERROR('Số căn cước công dân đã bị trùng, vui lòng kiểm tra lại!', 16, 1); 
		RETURN; 
	END

	-- Kiểm tra giới tính 
	IF @GioiTinh NOT IN ('Nam', 'Nu') 
	BEGIN 
		RAISERROR('Giới tính không hợp lệ! Phải là Nam hoặc Nu.', 16, 1); 
		RETURN; 
	END

	-- Kiểm tra định dạng mã nhân viên 
	IF @MaNhanVien NOT LIKE '[A-Z][0-9][0-9][0-9][0-9][0-9][0-9]' 
	BEGIN 
		RAISERROR('Mã nhân viên không hợp lệ! Ký tự đầu tiên phải là chữ cái in hoa và 6 ký tự tiếp theo là chữ số.', 16, 1); 
		RETURN; 
	END

	-- Kiểm tra trùng mã nhân viên 
	IF EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien) 
	BEGIN 
		RAISERROR('Mã nhân viên đã bị trùng, vui lòng kiểm tra lại!', 16, 1); 
		RETURN; 
	END

	-- Kiểm tra mã nhân viên không trùng với mã quản lý 
	IF @MaNhanVien = @MaQuanLy 
	BEGIN 
		RAISERROR('Mã nhân viên không được trùng với mã quản lý!', 16, 1); 
		RETURN; 
	END

    -- Thêm nhân viên
    INSERT INTO NhanVien (MaNhanVien, SoDienThoai, NgayThangNamSinh, NgayBatDauLam, HoTen, GioiTinh, DiaChi, Email, MaQuanLy, CanCuocCongDan)
    VALUES (@MaNhanVien, @SoDienThoai, @NgayThangNamSinh, @NgayBatDauLam, @HoTen, @GioiTinh, @DiaChi, @Email, @MaQuanLy, @CanCuocCongDan);
END;



--Thu tuc UPDATE
CREATE OR ALTER PROCEDURE SuaNhanVien
    @MaNhanVien CHAR(7),
    @SoDienThoai CHAR(10) = NULL,
    @NgayThangNamSinh DATE = NULL,
    @NgayBatDauLam DATE = NULL,
    @HoTen VARCHAR(100) = NULL,
    @GioiTinh VARCHAR(3) = NULL,
    @DiaChi VARCHAR(255) = NULL,
    @Email VARCHAR(100) = NULL,
    @MaQuanLy CHAR(7) = NULL,
    @CanCuocCongDan CHAR(12) = NULL
AS
BEGIN
    -- Kiểm tra tồn tại nhân viên
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR('Nhân viên không tồn tại!', 16, 1);
        RETURN;
    END

    -- Kiểm tra định dạng số điện thoại
    IF @SoDienThoai IS NOT NULL AND @SoDienThoai NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        RAISERROR('Số điện thoại không hợp lệ!', 16, 1);
        RETURN;
    END

    -- Kiểm tra trùng số điện thoại
    IF @SoDienThoai IS NOT NULL AND EXISTS (SELECT 1 FROM NhanVien WHERE SoDienThoai = @SoDienThoai AND MaNhanVien <> @MaNhanVien)
    BEGIN
        RAISERROR('Số điện thoại đã bị trùng, vui lòng kiểm tra lại!', 16, 1);
        RETURN;
    END

    -- Kiểm tra định dạng email
    IF @Email IS NOT NULL AND @Email NOT LIKE '%@gmail.com'
    BEGIN
        RAISERROR('Email phải có định dạng @gmail.com!', 16, 1);
        RETURN;
    END

    -- Kiểm tra trùng email
    IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email AND MaNhanVien <> @MaNhanVien)
    BEGIN
        RAISERROR('Email đã bị trùng, vui lòng kiểm tra lại!', 16, 1);
        RETURN;
    END

    -- Kiểm tra trùng số căn cước công dân
    IF @CanCuocCongDan IS NOT NULL AND EXISTS (SELECT 1 FROM NhanVien WHERE CanCuocCongDan = @CanCuocCongDan AND MaNhanVien <> @MaNhanVien)
    BEGIN
        RAISERROR('Số căn cước công dân đã bị trùng, vui lòng kiểm tra lại!', 16, 1);
        RETURN;
    END

    -- Kiểm tra giới tính
    IF @GioiTinh IS NOT NULL AND @GioiTinh NOT IN ('Nam', 'Nu')
    BEGIN
        RAISERROR('Giới tính không hợp lệ! Phải là Nam hoặc Nu.', 16, 1);
        RETURN;
    END

	-- Kiểm tra mã nhân viên không trùng với mã quản lý 
	IF @MaNhanVien = @MaQuanLy 
	BEGIN 
		RAISERROR('Mã nhân viên không được trùng với mã quản lý!', 16, 1); 
		RETURN; 
	END

    -- Cập nhật thông tin nhân viên
    UPDATE NhanVien
    SET
        SoDienThoai = COALESCE(@SoDienThoai, SoDienThoai),
        NgayThangNamSinh = COALESCE(@NgayThangNamSinh, NgayThangNamSinh),
        NgayBatDauLam = COALESCE(@NgayBatDauLam, NgayBatDauLam),
        HoTen = COALESCE(@HoTen, HoTen),
        GioiTinh = COALESCE(@GioiTinh, GioiTinh),
        DiaChi = COALESCE(@DiaChi, DiaChi),
        Email = COALESCE(@Email, Email),
        MaQuanLy = COALESCE(@MaQuanLy, MaQuanLy),
        CanCuocCongDan = COALESCE(@CanCuocCongDan, CanCuocCongDan)
    WHERE MaNhanVien = @MaNhanVien;
END;



--Thu tuc DELETE
CREATE OR ALTER PROCEDURE XoaNhanVien
    @MaNhanVien CHAR(7)
AS
BEGIN
    -- Kiểm tra tồn tại nhân viên
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR('Nhân viên không tồn tại!', 16, 1);
        RETURN;
    END

    -- Xóa nhân viên
    DELETE FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
END;

--DROP PROCEDURE IF EXISTS ThemNhanVien;
--DROP PROCEDURE IF EXISTS SuaNhanVien;
--DROP PROCEDURE IF EXISTS XoaNhanVien;
--BỔ SUNG TEST CASE PROCEDURE THEMNHANVIEN
--kIỂM TRA TUỔI
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456700',
    @NgayThangNamSinh = '2010-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--KIỂM TRA SĐT NHAN VIEN
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '012345670b',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--KIỂM TRA SĐT NHAN VIEN
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '012345670b',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--kiểm tra trùng sđt 
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0987654123',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--KIỂM TRA ĐỊNH DẠNG MAIL
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@tphcm',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--KIỂM TRA TRÙNG MAIL
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'a1@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

--KIỂM TRA TRÙNG CCCD
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '234567890123'

--KIỂM TRA ĐỊNH DẠNG GIỚI TÍNH 
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Men',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '234967890123'

--KIỂM TRA ĐỊNH DẠNG MÃ NHÂN VIÊN 
EXEC ThemNhanVien 
    @MaNhanVien = 'FX00017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '234967890123'

--KIỂM TRA TRÙNG MÃ NHÂN VIÊN 
EXEC ThemNhanVien 
    @MaNhanVien = 'F000011',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '234967890123'

--KIỂM TRA TRÙNG MÃ NHÂN VIÊN VỚI QUẢN LÍ
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '234967890123'

--THỰC THI ĐÚNG
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456709',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '234967890123'

--KIỂM TRA PROCEDURE SUANHANVIEN
--Kiểm tra tồn tại nhân viên
EXEC SuaNhanVien
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0987654321',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moi_sua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

-- Kiểm tra định dạng số điện thoại
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '09876543XX',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moi_sua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

-- Kiểm tra trùng số điện thoại
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456789',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moi_sua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

-- Kiểm tra định dạng email
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moi_sua@tphcm',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

-- Kiểm tra trùng email
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'c1@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

-- Kiểm tra trùng số căn cước công dân
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moisua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '890123456789'

-- Kiểm tra giới tính
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Men',
    @DiaChi = '456 Duong DEF',
    @Email = 'moisua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '890123456089'

-- Kiểm tra mã nhân viên không trùng với mã quản lý 
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moisua@gmail.com',
    @MaQuanLy = 'F000014',
    @CanCuocCongDan = '890123456089'

--THỰC HIỆN ĐÚNG VIỆC UPDATE
EXEC SuaNhanVien
    @MaNhanVien = 'F000014',
    @SoDienThoai = '0123456799',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moisua@gmail.com',
    @MaQuanLy = 'F000009',
    @CanCuocCongDan = '890123456089'

--KIỂM TRA THỦ TỤC DELETE
--Kiểm tra sự tồn tại
EXEC XoaNhanVien @MaNhanVien = 'F000020'

--CÂU LỆNH THỰC THI ĐÚNG
EXEC XoaNhanVien @MaNhanVien = 'F000017'
--Chay 3 thu tuc vua tao
EXEC ThemNhanVien 
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0123456700',
    @NgayThangNamSinh = '1985-01-01',
    @NgayBatDauLam = '2024-01-01',
    @HoTen = 'Nguyen Van Moi',
    @GioiTinh = 'Nam',
    @DiaChi = '123 Duong ABC',
    @Email = 'moi@gmail.com',
    @MaQuanLy = 'F000017',
    @CanCuocCongDan = '987654321098'

EXEC SuaNhanVien
    @MaNhanVien = 'F000017',
    @SoDienThoai = '0987654321',
    @NgayThangNamSinh = '1986-02-02',
    @NgayBatDauLam = '2024-02-01',
    @HoTen = 'Nguyen Van Moi Sua',
    @GioiTinh = 'Nam',
    @DiaChi = '456 Duong DEF',
    @Email = 'moi_sua@gmail.com',
    @MaQuanLy = 'F000002',
    @CanCuocCongDan = '876543210987'

EXEC XoaNhanVien @MaNhanVien = 'F000017'
--*******************************************************************************************************************************************************************************
--****************************************************************************************************************************
-- Viết 2 trigger

-- Tạo 1 bảng dể lưu lương tính từ nhân viên
CREATE TABLE LuongNhanVien (
    MaNhanVien CHAR(7) PRIMARY KEY,
    Luong DECIMAL(12, 2) NOT NULL,
    ThoiGianCapNhat DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tính lương nhân viên PartTime
CREATE OR ALTER TRIGGER trg_CalculateLuongPartTime 
ON NhanVienPartTime 
AFTER INSERT, UPDATE 
AS 
BEGIN
    DECLARE @MaNhanVien CHAR(7), @SoGioMoiTuan INT, @LuongMoiGio DECIMAL(10, 2), @Luong DECIMAL(12, 2);

    -- Lấy thông tin nhân viên vừa được insert hoặc update
    SELECT 
        @MaNhanVien = i.MaNhanVien, 
        @SoGioMoiTuan = i.SoGioMoiTuan, 
        @LuongMoiGio = i.LuongMoiGio
    FROM inserted i;

    -- Kiểm tra nếu nhân viên tồn tại trong bảng NhanVienPartTime
    IF EXISTS (SELECT 1 FROM NhanVienPartTime WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        -- Tính lương
        SET @Luong = @SoGioMoiTuan * @LuongMoiGio * 4;

        -- Thêm hoặc cập nhật lương vào bảng LuongNhanVien
        IF EXISTS (SELECT 1 FROM LuongNhanVien WHERE MaNhanVien = @MaNhanVien)
        BEGIN
            UPDATE LuongNhanVien
            SET Luong = @Luong, ThoiGianCapNhat = GETDATE()
            WHERE MaNhanVien = @MaNhanVien;
        END
        ELSE
        BEGIN
            INSERT INTO LuongNhanVien (MaNhanVien, Luong)
            VALUES (@MaNhanVien, @Luong);
        END
    END
    ELSE
    BEGIN
        -- Tùy chọn: Xử lý trường hợp nhân viên không tồn tại
        RAISERROR('Nhân viên không tồn tại trong bảng NhanVienPartTime nên không thể thực hiện Update!!!.',16,1);
    END
END;
GO

--Tính lương cho nhân viên FullTime
CREATE OR ALTER TRIGGER trg_CalculateLuongFullTime
ON NhanVienFullTime
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MaNhanVien CHAR(7), @LuongCoBan DECIMAL(10, 2), @PhuCap DECIMAL(10, 2), @Luong DECIMAL(12, 2);
    -- Lấy thông tin nhân viên vừa được insert hoặc update
    SELECT 
        @MaNhanVien = i.MaNhanVien,
        @LuongCoBan = i.LuongCoBan,
        @PhuCap = i.PhuCap
    FROM inserted i;

    -- Kiểm tra nếu nhân viên tồn tại trong bảng NhanVienFullTime
    IF EXISTS (SELECT 1 FROM NhanVienFullTime WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        -- Kiểm tra điều kiện phụ cấp
        IF @LuongCoBan < @PhuCap 
        BEGIN
            RAISERROR('Phụ cấp không được lớn hơn lương cơ bản. Vui lòng nhập lại!', 16, 1);
            RETURN;
        END
        -- Tính lương
        SET @Luong = @LuongCoBan + @PhuCap;

        -- Thêm hoặc cập nhật lương vào bảng LuongNhanVien
        IF EXISTS (SELECT 1 FROM LuongNhanVien WHERE MaNhanVien = @MaNhanVien)
        BEGIN
            UPDATE LuongNhanVien
            SET Luong = @Luong, ThoiGianCapNhat = GETDATE()
            WHERE MaNhanVien = @MaNhanVien;
        END
        ELSE
        BEGIN
            INSERT INTO LuongNhanVien (MaNhanVien, Luong)
            VALUES (@MaNhanVien, @Luong);
        END
    END
    ELSE
    BEGIN
        -- Tùy chọn: Xử lý trường hợp nhân viên không tồn tại
        RAISERROR('Nhân viên không tồn tại trong bảng NhanVienFullTime để thực hiện Update!!!',16,1);
    END
END;
GO

-- Trigger xóa nhân viên

-- Xóa nhân viên PartTime
CREATE OR ALTER TRIGGER trg_DeleteLuongOnNhanVienPTDelete
ON NhanVienPartTime
AFTER DELETE
AS
BEGIN
    -- Kiểm tra xem nhân viên có tồn tại trong bảng NhanVienPartTime không
    IF NOT EXISTS (
        SELECT 1
        FROM LuongNhanVien l
        JOIN deleted d ON l.MaNhanVien = d.MaNhanVien
    )
    BEGIN
        RAISERROR('Không tìm thấy nhân viên cần xóa trong bảng NhanVienPartTime!', 16, 1);
        RETURN;
    END;
    -- Xóa lương của nhân viên
    DELETE FROM LuongNhanVien
    WHERE MaNhanVien IN (SELECT MaNhanVien FROM deleted);
END;
GO


-- Xóa nhân viên FullTime
CREATE OR ALTER TRIGGER trg_DeleteLuongOnNhanVienFTDelete
ON NhanVienFullTime
AFTER DELETE
AS
BEGIN
    -- Kiểm tra xem nhân viên có tồn tại trong bảng NhanVienFullTime không
    IF NOT EXISTS (
        SELECT 1
        FROM LuongNhanVien l
        JOIN deleted d ON l.MaNhanVien = d.MaNhanVien
    )
    BEGIN
        RAISERROR('Không tìm thấy nhân viên cần xóa trong bảng NhanVienFullTime!', 16, 1);
        RETURN;
    END;
    -- Xóa lương của nhân viên
    DELETE FROM LuongNhanVien
    WHERE MaNhanVien IN (SELECT MaNhanVien FROM deleted);
END;
GO

-- ta tạm tắt kiểm tra ràng buộc tới bảng nhân viên
ALTER TABLE Nhanvienfulltime NOCHECK CONSTRAINT FK_NhanVien 

-- insert vào 1 nhân viên có phụ cấp lớn hơn lương cơ bản
INSERT INTO NhanVienFullTime (MaNhanVien, PhuCap, LuongCoBan, BaoHiem, NgayNghiPhepNam)
VALUES ('T00030', 3000.00, 1500.00, 'AAAA123567', 12);
-- insert hợp lệ và lương được tính vào bảng lương
INSERT INTO NhanVienFullTime (MaNhanVien, PhuCap, LuongCoBan, BaoHiem, NgayNghiPhepNam)
VALUES ('T00030', 3000.00, 15000.00, 'AAAA123567', 12);
-- Ta bật lại kiểm tra ràng buộc
ALTER TABLE Nhanvienfulltime CHECK CONSTRAINT FK_NhanVien

-- Update cho 1 nhân viên không tồn tại
update NhanVienFullTime
set PhuCap = 2000.00 
where manhanvien = 'A000001'
select * from LuongNhanVien

-- Update phụ cấp mà lớn hơn lương cơ bản
update NhanVienFullTime
set PhuCap = 6000.00 
where manhanvien = 'F000001'
-- Update thành công và lương được lưu lại vào bảng LuongNhanVien
select * from NhanVienFullTime
update NhanVienFullTime
set PhuCap = 1111.00 
where manhanvien = 'F000001'
-- Update tiếp cùng 1 nhân viên với giá trị mới
update NhanVienFullTime
set PhuCap = 1234.00 
where manhanvien = 'F000001'
-- Update thêm một số nhân viên khác 
update NhanVienFullTime
set PhuCap = 2211.00 
where manhanvien = 'F000002'

update NhanVienFullTime
set PhuCap = 3333.00 
where manhanvien = 'F000003'

-- Xóa 1 nhân viên không tồn tại
delete NhanVienFullTime where MaNhanVien='T00333'
-- Xóa 1 nhân viên thành công
delete NhanVienFullTime where MaNhanVien='T00030'

select * from NhanVienPartTime
select * from LuongNhanVien

--Testcase cho Nhân viên parttime
--Insert
-- ta tạm tắt kiểm tra ràng buộc tới bảng nhân viên
ALTER TABLE NhanvienParttime NOCHECK CONSTRAINT FK_NhanVienPartTime
-- Insert giờ bị âm
INSERT INTO NhanVienPartTime (MaNhanVien, SoGioMoiTuan, LuongMoiGio, HopDongThoiVu)
VALUES 
('P000050', -10, 130.00, 'AS456789')
-- Insert lương bị âm
INSERT INTO NhanVienPartTime (MaNhanVien, SoGioMoiTuan, LuongMoiGio, HopDongThoiVu)
VALUES 
('P000050', 10, -130.00, 'AS456789')
-- Insert thành công
INSERT INTO NhanVienPartTime (MaNhanVien, SoGioMoiTuan, LuongMoiGio, HopDongThoiVu)
VALUES 
('P000050', 10, 130.00, 'AS456789')
--Ta bật lại ràng buộc
ALTER TABLE NhanvienParttime CHECK CONSTRAINT FK_NhanVienPartTime
-- Update
--Update cho 1 nhân viên không tồn tại
UPDATE NhanVienPartTime
SET LuongMoiGio = 115.00
WHERE MaNhanVien = 'A000001';
-- Update Lương
UPDATE NhanVienPartTime
SET LuongMoiGio = 115.00
WHERE MaNhanVien = 'P000001';
-- Update giờ làm việc
UPDATE NhanVienPartTime
SET SoGioMoiTuan = 22
WHERE MaNhanVien = 'P000002';
-- Thêm update
UPDATE NhanVienPartTime
SET SoGioMoiTuan = 20
WHERE MaNhanVien = 'P000050';

UPDATE NhanVienPartTime
SET LuongMoiGio = 111.00
WHERE MaNhanVien = 'P000050';

-- Delete
-- Xóa nhân viên không tồn tại
delete from NhanVienPartTime
where MaNhanVien='T000000';
-- Xóa nhân viên thành công
delete from NhanVienPartTime
where MaNhanVien='P000050';



-- Hết phần tính lương nhân viên *********************************************************************************************

-- *************************************************
--Trigger về cập nhật hàng hóa trong khohang khi Insert, Update, Delete 1 hàng hóa trong thông tin hóa đơn 
--Insert
--####################################################################################################################################################
-- Update thông tin trong hàng hóa khi thay đổi số lượng của chứa thông tin( hoa đơn, chưa thông tin, hang hoa) 

CREATE OR ALTER TRIGGER trg_UpdateHangHoaOnHoaDon_Insert----------DONE-----------------
ON ChuaThongTin
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra hàng hóa có tồn tại trong bảng HangHoa không
        IF EXISTS (
            SELECT 1
            FROM Inserted i
            WHERE NOT EXISTS (
                SELECT 1
                FROM HangHoa h
                WHERE h.MaHangHoa = i.MaHangHoa
            )
        )
        BEGIN
            RAISERROR ('Hàng hóa không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra hóa đơn có tồn tại không
        IF NOT EXISTS (
            SELECT 1
            FROM HoaDon h
            JOIN Inserted i ON h.MaHoaDon = i.MaHoaDon
        )
        BEGIN
            RAISERROR ('Hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra điều kiện: đủ số lượng hàng hóa trong kho
        IF EXISTS (
            SELECT 1
            FROM Inserted i
            JOIN HangHoa h ON i.MaHangHoa = h.MaHangHoa
            WHERE h.SoLuongConLai < i.SoLuong
        )
        BEGIN
            RAISERROR ('Không đủ số lượng hàng hóa để thực hiện giao dịch.', 16, 1);
            RETURN;
        END;

        -- Cập nhật số lượng hàng hóa còn lại khi INSERT
        UPDATE h
        SET h.SoLuongConLai = h.SoLuongConLai - i.SoLuong
        FROM HangHoa h
        JOIN inserted i ON h.MaHangHoa = i.MaHangHoa

    END TRY
    BEGIN CATCH
        -- Ném lỗi cho transaction bên ngoài xử lý
        THROW;
    END CATCH
END;
GO
-- Delete
CREATE OR ALTER TRIGGER trg_UpdateHangHoaOnHoaDon_Delete
ON ChuaThongTin
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra hóa đơn có tồn tại không
        IF NOT EXISTS (
            SELECT 1
            FROM HoaDon h
            JOIN Deleted d ON h.MaHoaDon = d.MaHoaDon
        )
        BEGIN
            RAISERROR ('Hóa đơn không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Cập nhật số lượng hàng hóa còn lại khi DELETE
        UPDATE h
        SET h.SoLuongConLai = h.SoLuongConLai + d.SoLuong
        FROM HangHoa h
        JOIN Deleted d ON h.MaHangHoa = d.MaHangHoa

    END TRY
    BEGIN CATCH
        -- Ném lỗi cho transaction bên ngoài xử lý
        THROW;
    END CATCH
END;
GO
--update
CREATE OR ALTER TRIGGER trg_UpdateHangHoaOnHoaDon_Update
ON ChuaThongTin
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra hóa đơn có tồn tại không
        IF NOT EXISTS (
            SELECT 1
            FROM HoaDon h
            JOIN Inserted i ON h.MaHoaDon = i.MaHoaDon
        )
        BEGIN
            RAISERROR ('Hóa đơn không tồn tại hoặc mã hàng hóa của bạn nhập vào không có trong hóa đơn!!!', 16, 1);
            RETURN;
        END;

        -- Kiểm tra đủ số lượng trong kho khi cập nhật
        IF EXISTS (
            SELECT 1
            FROM Inserted i
            JOIN Deleted d ON i.MaHangHoa = d.MaHangHoa
            JOIN HangHoa h ON i.MaHangHoa = h.MaHangHoa
            WHERE h.SoLuongConLai + d.SoLuong < i.SoLuong
        )
        BEGIN
            RAISERROR ('Không đủ số lượng hàng hóa để cập nhật.', 16, 1);
            RETURN;
        END;

        -- Cập nhật số lượng hàng hóa còn lại khi UPDATE
        UPDATE h
        SET h.SoLuongConLai = h.SoLuongConLai + d.SoLuong - i.SoLuong
        FROM HangHoa h
        JOIN Inserted i ON h.MaHangHoa = i.MaHangHoa
        JOIN Deleted d ON h.MaHangHoa = d.MaHangHoa

    END TRY
    BEGIN CATCH
        -- Ném lỗi cho transaction bên ngoài xử lý
        THROW;
    END CATCH
END;
GO
select * from ChuaThongTin
select * from HangHoa

--Testcase
-- Ta tạm tắt ràng buộc
ALTER TABLE chuathongtin NOCHECK CONSTRAINT ALL
--Insert
--Insert cho 1 hóa đơn không tồn tại
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa,Soluong)
VALUES
('01234500', 'UN12345',3)

-- Insert cho hóa đơn nhưng Mã hàng hóa không tồn tại
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa,Soluong)
VALUES
('01234567', 'UN12333',3)

-- Insert cho hóa đơn nhưng số lượng vượt số lượng 
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa,Soluong)
VALUES
('01234567', 'UN12345',30000)

--Insert cho 1 hóa đơn thành công
INSERT INTO ChuaThongTin (MaHoaDon, MaHangHoa,Soluong)
VALUES
('01234567', 'UN12345',3)
-- Bật lại ràng buộc
ALTER TABLE chuathongtin CHECK CONSTRAINT ALL

--Delete 
--Delete 1 hóa đơn không tồn tại
DELETE FROM ChuaThongTin WHERE MaHoaDon='80001234'
--Delete 1 hóa đơn mà mã hàng hóa không hợp lệ
DELETE FROM ChuaThongTin WHERE MaHoaDon='01234567' AND MaHangHoa='UN12347'
--Delete 1 hóa đơn thành công
DELETE FROM ChuaThongTin WHERE MaHoaDon='01234567' AND MaHangHoa='UN12345'
--Delete 1 hóa đơn chưa nhiều hàng hóa
DELETE FROM ChuaThongTin WHERE MaHoaDon='12345679'



-- Update
-- Cập nhật không thành công do lỗi mã hóa đơn
UPDATE ChuaThongTin
SET SoLuong = 5
WHERE MaHoaDon = '01234544' and MaHangHoa='MN76543'
-- Cập nhật không thành công do lỗi mã hàng hóa 
UPDATE ChuaThongTin
SET SoLuong = 5
WHERE MaHoaDon = '12345678' and MaHangHoa='UN12341'
-- Cập nhật không thành công thành công do vượt quá lượng hàng
UPDATE ChuaThongTin
SET SoLuong = 50000
WHERE MaHoaDon = '12345678' and MaHangHoa='DE54321'
-- Cập nhật thành công (tăng số lượng) -> Kho giảm đi hàng
UPDATE ChuaThongTin
SET SoLuong = 9
WHERE MaHoaDon = '12345678' and MaHangHoa='DE54321'
-- Cập nhật thành công (giảm số lượng) -> Kho tăng thêm hàng
UPDATE ChuaThongTin
SET SoLuong = 2
WHERE MaHoaDon = '12345678' and MaHangHoa='UN12345'

select * from ChuaThongTin

select * from HangHoa
-- Xong phần trigger***********************************************************************
--Phần 3. Viết 2 thủ tục

CREATE OR ALTER PROCEDURE HienThiHoaDonKhachHang
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    -- Kiểm tra nếu Ngày Bắt Đầu lớn hơn Ngày Kết Thúc
    IF @NgayBatDau > @NgayKetThuc
    BEGIN
        RAISERROR ('Vui lòng nhập Ngày Bắt Đầu trước Ngày Kết Thúc.', 16, 1);
        RETURN;
    END

    -- Kiểm tra nếu ngày vượt quá ngày hiện tại
    IF @NgayBatDau > GETDATE() OR @NgayKetThuc > GETDATE()
    BEGIN
        RAISERROR ('Vui lòng nhập Ngày Bắt Đầu hoặc Ngày Kết Thúc không vượt quá ngày hiện tại.', 16, 1);
        RETURN;
    END

    -- Truy vấn dữ liệu hóa đơn
    SELECT HD.MaHoaDon, HD.ThoiGianXuatHoaDon, KH.HoTen, KH.MaKhachHang
    FROM HoaDon HD
    INNER JOIN MuaHang MH ON HD.MaHoaDon = MH.MaHoaDon
    INNER JOIN KhachHang KH ON MH.MaKhachHang = KH.MaKhachHang
    WHERE HD.ThoiGianXuatHoaDon BETWEEN @NgayBatDau AND @NgayKetThuc
    ORDER BY HD.ThoiGianXuatHoaDon DESC;
END;


--testcase
-- Ngày kết thúc vượt quá ngày hiện tại
EXEC HienThiHoaDonKhachHang @NgayBatDau ='2024-10-01' , @NgayKetThuc='2025-10-10'

-- Ngày bắt đầu vượt quá ngày kết thúc
EXEC HienThiHoaDonKhachHang @NgayBatDau ='2024-11-01' , @NgayKetThuc='2024-10-10'

-- Hiển thị thành công
EXEC HienThiHoaDonKhachHang @NgayBatDau ='2024-10-01' , @NgayKetThuc='2024-10-10'
--***************************************************

-- Truy vấn tổng số lượng của các loại hàng hóa đã nhập trong các kho hàng, mục đích là kiểm tra xem loại hàng
-- nào đang chiếm số lượng lớn trong kho để quản lí có hàng tiến hành các dự án thanh lọc bớt
CREATE OR ALTER PROCEDURE KiemTraHangHoaTrongKho
    @MaKhoHang CHAR(2),
    @TongSoLuong INT
AS
BEGIN
    IF @TongSoLuong <=0
    BEGIN
        RAISERROR ('Vui lòng nhập Tổng số lượng lớn hơn 0.', 16, 1);
        RETURN;
    END
	 IF NOT EXISTS (
        SELECT 1
        FROM KhoHang
        WHERE MaKhoHang = @MaKhoHang
    )
    BEGIN
        RAISERROR ('Mã kho hàng bạn nhập cửa hàng không có. Vui lòng nhập Mã kho hàng hợp lệ.', 16, 1);
        RETURN;
    END;
    SELECT 
        LH.MaKhoHang,
        L.TenLoai AS LoaiHangHoa,
        SUM(CH.SoLuongHangHoa) AS TongSoLuongDaNhap
    FROM KhoHang KH
    INNER JOIN LuuTru LH ON KH.MaKhoHang = LH.MaKhoHang
    INNER JOIN Chua CH ON LH.MaLoHang = CH.MaLoHang 
    INNER JOIN HangHoa HH ON CH.MaHangHoa = HH.MaHangHoa
	INNER JOIN Loai L ON L.MaLoai = HH.MaLoai
    WHERE KH.MaKhoHang = @MaKhoHang
    GROUP BY LH.MaKhoHang, L.TenLoai
    HAVING SUM(CH.SoLuongHangHoa) > @TongSoLuong
    ORDER BY TongSoLuongDaNhap DESC;
END;

--##########################################################################################################################################

-- Kho hàng không tồn tại
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'B3', @TongSoLuong = 01;

-- Số lượng tối thiểu k đúng yêu cầu 
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'B2', @TongSoLuong = 0;

-- Thỏa mãn yêu cầu
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'A1', @TongSoLuong = 100;
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'A1', @TongSoLuong= 50;
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'B2', @TongSoLuong = 10;
EXEC KiemTraHangHoaTrongKho @MaKhoHang = 'C3', @TongSoLuong = 20;

--UN12345 
-- 4. Thủ tục
-- Tính lợi nhuận
CREATE OR ALTER FUNCTION CalculateProfit(@startDate DATE, @endDate DATE)
RETURNS DECIMAL(20, 2)
AS
BEGIN
    DECLARE @totalSales DECIMAL(20, 2) = 0;
    DECLARE @totalCosts DECIMAL(20, 2) = 0;
    DECLARE @profit DECIMAL(20, 2) = 0;
    DECLARE @currentDate DATE;
    DECLARE @sales DECIMAL(20, 2);
    DECLARE @cost DECIMAL(20, 2);
    
    -- Cursor for sales dates
    DECLARE curSalesDates CURSOR FOR
    SELECT DISTINCT CAST(ThoiGianXuatHoaDon AS DATE) 
    FROM HoaDon
    WHERE ThoiGianXuatHoaDon BETWEEN @startDate AND @endDate;
    
    -- Cursor for cost dates
    DECLARE curCostDates CURSOR FOR
    SELECT DISTINCT CAST(NgayCungCap AS DATE) 
    FROM LoHang
    WHERE NgayCungCap BETWEEN @startDate AND @endDate;

    -- Input parameter validation
    IF @startDate IS NULL OR @endDate IS NULL 
    BEGIN
        RETURN -1;
    END
	IF @startDate > @endDate
    BEGIN
        RETURN -2;
    END
    -- Open and process the sales cursor
    OPEN curSalesDates;
    FETCH NEXT FROM curSalesDates INTO @currentDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate sales for the current date
        SELECT @sales = COALESCE(SUM(ctt.Soluong * hh.Gia), 0)
        FROM HoaDon hd
        INNER JOIN ChuaThongTin ctt ON hd.MaHoaDon = ctt.MaHoaDon
        INNER JOIN HangHoa hh ON ctt.MaHangHoa = hh.MaHangHoa
        WHERE CAST(hd.ThoiGianXuatHoaDon AS DATE) = @currentDate;

        SET @totalSales = @totalSales + @sales;

        -- Fetch the next sales date
        FETCH NEXT FROM curSalesDates INTO @currentDate;
    END

    -- Close and deallocate the sales cursor
    CLOSE curSalesDates;
    DEALLOCATE curSalesDates;

    -- Open and process the cost cursor
    OPEN curCostDates;
    FETCH NEXT FROM curCostDates INTO @currentDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate costs for the current date
        SELECT @cost = COALESCE(SUM(lh.ChiPhiLoHang), 0)
        FROM LoHang lh
        WHERE CAST(lh.NgayCungCap AS DATE) = @currentDate;

        SET @totalCosts = @totalCosts + @cost;

        -- Fetch the next cost date
        FETCH NEXT FROM curCostDates INTO @currentDate;
    END

    -- Close and deallocate the cost cursor
    CLOSE curCostDates;
    DEALLOCATE curCostDates;

    -- Calculate profit
    SET @profit = @totalSales - @totalCosts;

    RETURN @profit;
END;


SELECT dbo.CalculateProfit(NULL, '2024-12-31') AS Profit;
SELECT dbo.CalculateProfit('2021-01-01', '2024-12-31') AS Profit;
SELECT dbo.CalculateProfit('2022-01-01', '2024-12-31') AS Profit;
SELECT dbo.CalculateProfit('2023-01-01', '2024-12-31') AS Profit;
SELECT dbo.CalculateProfit('2024-11-01', '2024-12-31') AS Profit;


-- Tính phần trăm đóng góp của 1 loại hàng hóa
CREATE OR ALTER FUNCTION CalculatePerformance(@startDate DATE, @endDate DATE, @MaHangHoa CHAR(8))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalRevenue DECIMAL(20, 2) = 0;
    DECLARE @productRevenue DECIMAL(20, 2) = 0;
    DECLARE @performance DECIMAL(20, 2) = 0;

    DECLARE @SoLuongHangHoa INT;
    DECLARE @Gia DECIMAL(20, 2);
    DECLARE @currentRevenue DECIMAL(20, 2);
	-- Bạn nhập ngày tháng không hợp lệ
	    IF @startDate IS NULL OR @endDate IS NULL OR @startDate > @endDate
    BEGIN
        RETURN -1;
    END
	-- Bạn nhập mã hàng hóa không đúng
	if @MaHangHoa not in (select MahangHoa from HangHoa)
	begin 
	return -2;
	end
    -- Calculate total revenue from all products within the specified period
    SELECT @totalRevenue = SUM(ctt.Soluong * hh.Gia)
    FROM HoaDon hd
    INNER JOIN ChuaThongTin ctt ON hd.MaHoaDon = ctt.MaHoaDon
    INNER JOIN HangHoa hh ON ctt.MaHangHoa = hh.MaHangHoa
    WHERE hd.ThoiGianXuatHoaDon BETWEEN @startDate AND @endDate;

    -- Declare a cursor for calculating product revenue
    DECLARE productRevenueCursor CURSOR FOR
    SELECT ctt.Soluong, hh.Gia
    FROM HoaDon hd
    INNER JOIN ChuaThongTin ctt ON hd.MaHoaDon = ctt.MaHoaDon
    INNER JOIN HangHoa hh ON ctt.MaHangHoa = hh.MaHangHoa
    WHERE ctt.MaHangHoa = @MaHangHoa AND hd.ThoiGianXuatHoaDon BETWEEN @startDate AND @endDate;

    -- Open the cursor
    OPEN productRevenueCursor;

    -- Fetch the first row
    FETCH NEXT FROM productRevenueCursor INTO @SoLuongHangHoa, @Gia;

    -- Loop through all rows in the result set
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate the current revenue
        SET @currentRevenue = @SoLuongHangHoa * @Gia;

        -- Add the current revenue to the total product revenue
        SET @productRevenue = @productRevenue + @currentRevenue;

        -- Fetch the next row
        FETCH NEXT FROM productRevenueCursor INTO @SoLuongHangHoa, @Gia;
    END

    -- Close and deallocate the cursor
    CLOSE productRevenueCursor;
    DEALLOCATE productRevenueCursor;

    -- Calculate performance
    IF @totalRevenue > 0
    BEGIN
        SET @performance = @productRevenue*100 / @totalRevenue;
    END
    ELSE
    BEGIN
        SET @performance = -3; -- To handle division by zero
    END

    RETURN @performance;
END;

-- Testcase
SELECT dbo.CalculatePerformance('2020-01-01', '2024-12-31', 'AB09876') AS Performance;
SELECT dbo.CalculatePerformance('2020-01-01', '2024-12-31', 'AB34567') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'CD10987') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'CD67890') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'DE54321') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'EF21098') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'EF56789') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'GH32109') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'GH43210') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'IJ65432') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'KL87654') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'MN76543') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'OP43210') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'QR54321') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'ST65432') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'UN12345') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'UV76543') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'WX87654') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'XY98765') AS Performance;
SELECT dbo.CalculatePerformance('2024-01-01', '2024-12-31', 'YZ98765') AS Performance;

-- tìm các trigger hiện có trong csdl
SELECT 
    name AS TriggerName,
    object_id AS ObjectID,
    type_desc AS TriggerType,
    parent_class_desc AS ParentClass,
    is_disabled AS IsDisabled
FROM sys.triggers
WHERE is_ms_shipped = 0;

CREATE TABLE admins (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE, 
    password VARCHAR(255) NOT NULL,
);
select * from admins
SET IDENTITY_INSERT admins ON;
-- Insert the new data
INSERT INTO admins (id, username, password) VALUES
('1','nam.nguyen', '2212142');
INSERT INTO admins (id, username, password) VALUES
('2','phat.oi', '2212512');
SET IDENTITY_INSERT admins OFF;
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'SELECT * FROM ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

EXEC sp_executesql @sql;
 
 ------------------------------------------------------------------My workspace------------------------------------------------------
