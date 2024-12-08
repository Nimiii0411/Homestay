-- Tạo database
CREATE DATABASE QLH_SWEETHOME
GO
USE QLH_SWEETHOME


-- Bảng TaiKhoan (Account)
CREATE TABLE TaiKhoan 
(
    MaTaiKhoan VARCHAR(10),
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,
    Email VARCHAR(50) UNIQUE NOT NULL,
    NgayTao DATETIME DEFAULT GETDATE(),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN (N'Nhân viên trực', N'Khách hàng',N'Admin')),
    CONSTRAINT PK_TaiKhoan PRIMARY KEY (MaTaiKhoan)
)

-- Bảng NhanVien
CREATE TABLE NhanVien
(
    MaNhanVien VARCHAR(10), --Mã nhân viên
    TenNhanVien NVARCHAR(30), --Tên nhân viên
    DiaChiNV NVARCHAR(90), -- Địa chỉ nhân viên
    SDT_NV VARCHAR(15), -- Số điện thoại
    CCCD VARCHAR(20), -- Căn cước công dân 
    ChucVu NVARCHAR(20), -- 'Nhân viên trực' hoặc 'Quản lý khu vực'
	MaTaiKhoan VARCHAR(10),
	MaKhuVuc VARCHAR(10),
    CONSTRAINT PK_NV PRIMARY KEY (MaNhanVien),
	CONSTRAINT FK_NhanVien_TaiKhoan FOREIGN KEY (MaTaiKhoan) REFERENCES TaiKhoan(MaTaiKhoan),
	CONSTRAINT FK_NhanVien_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES KhuVuc (MaKhuVuc)
)

-- Bảng KhuVuc
CREATE TABLE KhuVuc
(
    MaKhuVuc VARCHAR(10), --Mã khu vực  
    TenKhuVuc NVARCHAR(50), --VD: Tp.Hồ Chí Minh, Vũng tàu, Đà Lạt 
    CONSTRAINT PK_KhuVuc PRIMARY KEY (MaKhuVuc), 
)

CREATE TABLE AnhHomestay (
    MaAnh VARCHAR(10),
    MaHomestay VARCHAR(10),
    AnhChinh NVARCHAR(255),
	AnhPhu1 NVARCHAR(255),
	AnhPhu2 NVARCHAR(255),
	AnhPhu3 NVARCHAR(255),
	AnhPhu4 NVARCHAR(255),
	CONSTRAINT PK_AnhHomestay PRIMARY KEY (MaAnh)
);
-- Bảng Homestay
CREATE TABLE Homestay
(
    MaHomestay VARCHAR(10) PRIMARY KEY, -- Mã homestay
    TenHomestay NVARCHAR(100) NOT NULL, -- Tên homestay
    MaKhuVuc VARCHAR(10) NOT NULL, -- Mã khu vực
	MaAnh VARCHAR(10),
    DiaChi NVARCHAR(200), -- Địa chỉ homestay
    MoTa NVARCHAR(MAX), -- Mô tả homestay
    GiaThue FLOAT NOT NULL CHECK (GiaThue > 0), -- Giá thuê homestay 1 ngày (phải > 0)
    SoLuongKhach INT NOT NULL CHECK (SoLuongKhach > 0), -- Số lượng khách chứa tối đa (phải > 0)
    DienTich NVARCHAR(20), -- Diện tích homestay
    TienNghi NVARCHAR(500), -- Tiện nghi homestay
    NgayXayDung DATE, -- Ngày xây dựng homestay
    MaNhanVienTruc VARCHAR(10) NOT NULL, -- Nhân viên trực homestay
    TrangThai NVARCHAR(20) NOT NULL CHECK (TrangThai IN (N'Trống', N'Đã đặt', N'Đang bảo dưỡng')), -- Trạng thái homestay
    DiemTrungBinh FLOAT CHECK (DiemTrungBinh >= 0 AND DiemTrungBinh <= 5), -- Điểm trung bình đánh giá (0 đến 5)
    CONSTRAINT FK_Homestay_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES KhuVuc(MaKhuVuc),
    CONSTRAINT FK_Homestay_NhanVien FOREIGN KEY (MaNhanVienTruc) REFERENCES NhanVien(MaNhanVien),
	CONSTRAINT FK_Homestay_AnhHomestay FOREIGN KEY (MaAnh) REFERENCES AnhHomestay (MaAnh)
);

-- Bảng DichVu
CREATE TABLE DichVu
(
    MaDichVu VARCHAR(10), --Mã dịch vụ
    TenDichVu NVARCHAR(50), --Tên dịch vụ
    GiaDichVu FLOAT, --giá dịch vụ theo ngày
    MoTaDichVu NVARCHAR(100), --Mô tả dịch vụ
    CONSTRAINT PK_DichVu PRIMARY KEY (MaDichVu)
)

-- Bảng KhachHang
CREATE TABLE KhachHang
(
    MaKhachHang VARCHAR(10),--Mã khách hàng
    TenKhachHang NVARCHAR(50),--Tên khách hàng
    CCCD VARCHAR(20),
    SDT VARCHAR(15),
    Email NVARCHAR(50),
    DiaChiKH NVARCHAR(100), --Địa chỉ khách hàng
	MaTaiKhoan VARCHAR(10),
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKhachHang),
	CONSTRAINT FK_KhachHang_TaiKhoan FOREIGN KEY (MaTaiKhoan) REFERENCES TaiKhoan(MaTaiKhoan)
)

CREATE TABLE DanhGia
(
	MaDanhGia VARCHAR(10), 
	MaKhachHang VARCHAR(10),
	MaHomestay VARCHAR(10),
	DiemDanhGia FLOAT,
	NoiDungDanhGia NVARCHAR(1000), --Nội dung đánh giá
	CONSTRAINT PK_DanhGia PRIMARY KEY (MaDanhGia),
	CONSTRAINT FK_DanhGia_Homestay FOREIGN KEY (MaHomestay) REFERENCES Homestay (MaHomestay),
	CONSTRAINT FK_DanhGia_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang (MaKhachHang)
)

-- Bảng DatHomestay
CREATE TABLE ChiTietDatHomestay
(
    MaDatHomestay VARCHAR(10), --Mã đặt homestay
    MaKhachHang VARCHAR(10),-- Mã khách hàng
    MaHomestay VARCHAR(10), --Mã homestay
    NgayDat DATE, --Ngày đặt
    NgayNhan DATE, -- Ngày nhận
    NgayTra DATE, --Ngày trả
    SoLuongKhach INT, --Số lượng khách đến
    TongTien FLOAT, --Tổng tiền
    TrangThai NVARCHAR(20), -- 'Chờ xác nhận', 'Hoàn thành'
    GhiChu NVARCHAR(500), --Ghi chú khi đặt
    CONSTRAINT PK_CTDatHomestay PRIMARY KEY (MaDatHomestay),
    CONSTRAINT FK_CTDatHomestay_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),
    CONSTRAINT FK_CTDatHomestay_Homestay FOREIGN KEY (MaHomestay) REFERENCES Homestay(MaHomestay)
)

CREATE TABLE ChiTietDichVuDatHomestay (
    MaChiTietDichVuDatHomestay VARCHAR(10) PRIMARY KEY,
    MaDatHomestay VARCHAR(10),
    MaDichVu VARCHAR(10),
    SoLuong INT,
    TongTienDichVu FLOAT,
    CONSTRAINT FK_CTDichVuDatHomestay_CTDatHomestay FOREIGN KEY (MaDatHomestay) REFERENCES ChiTietDatHomestay(MaDatHomestay),
    CONSTRAINT FK_CTDichVuDatHomestay_DichVu FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);


-- Bảng ThanhToan
CREATE TABLE ThanhToan
(
    MaThanhToan VARCHAR(10), --
    MaDatHomestay VARCHAR(10),
    NgayThanhToan DATE,
    PhuongThucThanhToan NVARCHAR(30),
    SoTien FLOAT,
    TrangThaiTT NVARCHAR(20), -- 'Đã thanh toán', 'Chưa thanh toán', 'Hoàn tiền'
    GhiChu NVARCHAR(200),
    CONSTRAINT PK_ThanhToan PRIMARY KEY (MaThanhToan),
    CONSTRAINT FK_ThanhToan_DatHomestay FOREIGN KEY (MaDatHomestay) REFERENCES ChiTietDatHomestay(MaDatHomestay)
)

-- Bảng BaoDuong 
CREATE TABLE BaoDuong
(
    MaBaoDuong VARCHAR(10),
    MaHomestay VARCHAR(10),
    NgayBaoDuong DATE, --Ngày bảo dưỡng
    NgayHoanThanh DATE,--Ngày hoàn thành
    ChiPhi FLOAT, --Chi phí bảo dưỡng
    MoTaCongViec NVARCHAR(500),
    TrangThai NVARCHAR(20), -- 'Đang thực hiện', 'Hoàn thành'
    CONSTRAINT PK_BaoDuong PRIMARY KEY (MaBaoDuong),
    CONSTRAINT FK_BaoDuong_Homestay FOREIGN KEY (MaHomestay) REFERENCES Homestay(MaHomestay)
)

-----------------------------------------INSERT DỮ LIỆU-----------------------------------
delete TaiKhoan
-- Admin Account
INSERT INTO TaiKhoan (MaTaiKhoan, TenDangNhap, MatKhau, Email, NgayTao, Role) VALUES
('TK001', 'admin', 'password123', 'admin@homestay.com', GETDATE(), N'Admin');

-- Employee Accounts (TK002 - TK021)
INSERT INTO TaiKhoan (MaTaiKhoan, TenDangNhap, MatKhau, Email, NgayTao, Role) VALUES
('TK002', 'nhanvien01', 'nvpass01', 'nhanvien01@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK003', 'nhanvien02', 'nvpass02', 'nhanvien02@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK004', 'nhanvien03', 'nvpass03', 'nhanvien03@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK005', 'nhanvien04', 'nvpass04', 'nhanvien04@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK006', 'nhanvien05', 'nvpass05', 'nhanvien05@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK007', 'nhanvien06', 'nvpass06', 'nhanvien06@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK008', 'nhanvien07', 'nvpass07', 'nhanvien07@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK009', 'nhanvien08', 'nvpass08', 'nhanvien08@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK010', 'nhanvien09', 'nvpass09', 'nhanvien09@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK011', 'nhanvien10', 'nvpass10', 'nhanvien10@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK012', 'nhanvien11', 'nvpass11', 'nhanvien11@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK013', 'nhanvien12', 'nvpass12', 'nhanvien12@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK014', 'nhanvien13', 'nvpass13', 'nhanvien13@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK015', 'nhanvien14', 'nvpass14', 'nhanvien14@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK016', 'nhanvien15', 'nvpass15', 'nhanvien15@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK017', 'nhanvien16', 'nvpass16', 'nhanvien16@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK018', 'nhanvien17', 'nvpass17', 'nhanvien17@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK019', 'nhanvien18', 'nvpass18', 'nhanvien18@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK020', 'nhanvien19', 'nvpass19', 'nhanvien19@homestay.com', GETDATE(), N'Nhân viên trực'),
('TK021', 'nhanvien20', 'nvpass20', 'nhanvien20@homestay.com', GETDATE(), N'Nhân viên trực');

-- Customer Accounts (TK022 - TK041)
INSERT INTO TaiKhoan (MaTaiKhoan, TenDangNhap, MatKhau, Email, NgayTao, Role) VALUES
('TK022', 'khachhang01', 'khpass01', 'khachhang01@gmail.com', GETDATE(), N'Khách hàng'),
('TK023', 'khachhang02', 'khpass02', 'khachhang02@gmail.com', GETDATE(), N'Khách hàng'),
('TK024', 'khachhang03', 'khpass03', 'khachhang03@gmail.com', GETDATE(), N'Khách hàng'),
('TK025', 'khachhang04', 'khpass04', 'khachhang04@gmail.com', GETDATE(), N'Khách hàng'),
('TK026', 'khachhang05', 'khpass05', 'khachhang05@gmail.com', GETDATE(), N'Khách hàng'),
('TK027', 'khachhang06', 'khpass06', 'khachhang06@gmail.com', GETDATE(), N'Khách hàng'),
('TK028', 'khachhang07', 'khpass07', 'khachhang07@gmail.com', GETDATE(), N'Khách hàng'),
('TK029', 'khachhang08', 'khpass08', 'khachhang08@gmail.com', GETDATE(), N'Khách hàng'),
('TK030', 'khachhang09', 'khpass09', 'khachhang09@gmail.com', GETDATE(), N'Khách hàng'),
('TK031', 'khachhang10', 'khpass10', 'khachhang10@gmail.com', GETDATE(), N'Khách hàng'),
('TK032', 'khachhang11', 'khpass11', 'khachhang11@gmail.com', GETDATE(), N'Khách hàng'),
('TK033', 'khachhang12', 'khpass12', 'khachhang12@gmail.com', GETDATE(), N'Khách hàng'),
('TK034', 'khachhang13', 'khpass13', 'khachhang13@gmail.com', GETDATE(), N'Khách hàng'),
('TK035', 'khachhang14', 'khpass14', 'khachhang14@gmail.com', GETDATE(), N'Khách hàng'),
('TK036', 'khachhang15', 'khpass15', 'khachhang15@gmail.com', GETDATE(), N'Khách hàng'),
('TK037', 'khachhang16', 'khpass16', 'khachhang16@gmail.com', GETDATE(), N'Khách hàng'),
('TK038', 'khachhang17', 'khpass17', 'khachhang17@gmail.com', GETDATE(), N'Khách hàng'),
('TK039', 'khachhang18', 'khpass18', 'khachhang18@gmail.com', GETDATE(), N'Khách hàng'),
('TK040', 'khachhang19', 'khpass19', 'khachhang19@gmail.com', GETDATE(), N'Khách hàng'),
('TK041', 'khachhang20', 'khpass20', 'khachhang20@gmail.com', GETDATE(), N'Khách hàng');

select count(*) from TaiKhoan where Role = N'Nhân viên trực'

---INSERT DỮ LIỆU NHÂN VIÊN
-- Nhân viên cho khu vực TP. Hồ Chí Minh (KV001)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV017', N'Lê Hoài Nam', N'988 Đường F, TP.HCM', '0945679856', '009856856325', N'Nhân viên trực', 'TK017', 'KV001'),
('NV005', N'Trần Thế Nghĩa', N'456 Đường E, Vũng Tàu', '0945678901', '005678901234', N'Nhân viên trực', 'TK005', 'KV001'),
('NV006', N'Nguyễn Như Lan', N'456 Đường E Hồ Xuân Hương, Vũng Tàu', '0945678901', '005678901234', N'Nhân viên trực', 'TK006', 'KV001');

-- Nhân viên cho khu vực Đà Lạt (KV002)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV009', N'Nguyễn Ngọc Tuấn', N'456 Đường E, Vũng Tàu', '0985423659', '004585236525', N'Nhân viên trực', 'TK009', 'KV002'),
('NV010', N'Lý Hoàng Anh', N'Hẻm 50/18 Nguyễn Đình Chiểu, Phú Nhuận', '0978952365', '002352523652', N'Nhân viên trực', 'TK010', 'KV002');

-- Nhân viên cho khu vực Vũng Tàu (KV003)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV001', N'Nguyễn Văn An', N'287/ 23 Hồ Xuân Hương phường Võ Thị Sáu quận Đống Đa , Hà Nội', '0901234567', '001201234567', N'Nhân viên trực', 'TK001', 'KV003'),
('NV002', N'Trần Thị Lệ Thu', N'456 Đường B, Đà Nẵng', '0912345678', '002345678901', N'Nhân viên trực', 'TK002', 'KV003'),
('NV003', N'Lê Văn Duyệt', N'287/2 Nguyễn Đình Chiểu phường 5, quận 3, TP.HCM', '0923456789', '003456789012', N'Nhân viên trực', 'TK003', 'KV003'),
('NV018', N'Trần Văn Quốc', N'678 Đường N, Hà Nội', '094568889', '008542563256', N'Nhân viên trực', 'TK018', 'KV003'),
('NV019', N'Nguyễn Ngọc Tuấn', N'478 Đường C, Kiên Giang', '0945679568', '004584524526', N'Nhân viên trực', 'TK019', 'KV003');

-- Nhân viên cho khu vực Khánh Hòa (KV004)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV020', N'Nguyễn Ngọc Ngạn', N'568 Đường D, Đồng nai', '0925678981', '001254254785', N'Nhân viên trực', 'TK020', 'KV004'),
('NV016', N'Đặng Quốc Cường', N'678 Đường A, Khánh Hòa', '09879678901', '007856589523', N'Nhân viên trực', 'TK016', 'KV004'),
('NV012', N'Phạm Băng Băng', N'489 Đường W, Khánh Hòa', '0987954523', '002356253525', N'Nhân viên trực', 'TK012', 'KV004');

-- Nhân viên cho khu vực Huế (KV005)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV008', N'Lê Hoàng Anh', N'Hẻm 46 Liên Khu 10-11, Binh Tân', '0945678909', '008678901234', N'Nhân viên trực', 'TK008', 'KV005');

-- Nhân viên cho khu vực Hà Nội (KV006)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV011', N'Cao Tú Cường', N'Hẻm 472/16 Phan Huy Ích, Gò Vấp', '0978562314', '008745214523', N'Nhân viên trực', 'TK011', 'KV006');

-- Nhân viên cho khu vực Kiên Giang (KV007)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV013', N'Trần Ngọc Dương', N'987/12 Đường H, Vũng Tàu', '09236541251', '008565896589', N'Nhân viên trực', 'TK013', 'KV007'),
('NV014', N'Nguyễn Huy Hoàng', N'123/45 Đường K, Cần Thơ', '0978542569', '00785452536', N'Nhân viên trực', 'TK014', 'KV007');

-- Nhân viên cho khu vực Cần Thơ (KV008)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV004', N'Nguyễn Ngọc Anh Thư', N'12 Đường D Thới An, Ô Môn, Cần Thơ', '0934567890', '004567890123', N'Nhân viên trực', 'TK004', 'KV008'),
('NV007', N'Trần Minh Quyết', N'12 Đường D Thới An, Ô Môn, Cần Thơ', '0934567890', '004567890123', N'Nhân viên trực', 'TK007', 'KV008');

-- Nhân viên cho khu vực Quảng Ninh (KV009)
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, DiaChiNV, SDT_NV, CCCD, ChucVu, MaTaiKhoan, MaKhuVuc) VALUES
('NV015', N'Trần Xuân Diệu', N'789 Đường U, Bình Thuận', '0923569856', '007854523658', N'Nhân viên trực', 'TK015', 'KV009');

------INSERT MÃ ẢNH --------


INSERT INTO AnhHomestay (MaAnh, MaHomestay, AnhChinh, AnhPhu1, AnhPhu2, AnhPhu3, AnhPhu4) VALUES
('MA001', 'HS001', 'HS001_Chinh.png', 'HS001_AnhPhu1.png', 'HS001_AnhPhu2.png', 'HS001_AnhPhu3.png', 'HS001_AnhPhu4.png'),
('MA002', 'HS002', 'HS002_Chinh.png', 'HS002_AnhPhu1.png', 'HS002_AnhPhu2.png', 'HS002_AnhPhu3.png', 'HS002_AnhPhu4.png'),
('MA003', 'HS003', 'HS003_Chinh.png', 'HS003_AnhPhu1.png', 'HS003_AnhPhu2.png', 'HS003_AnhPhu3.png', 'HS003_AnhPhu4.png'),
('MA004', 'HS004', 'HS004_Chinh.png', 'HS004_AnhPhu1.png', 'HS004_AnhPhu2.png', 'HS004_AnhPhu3.png', 'HS004_AnhPhu4.png'),
('MA005', 'HS005', 'HS005_Chinh.png', 'HS005_AnhPhu1.png', 'HS005_AnhPhu2.png', 'HS005_AnhPhu3.png', 'HS005_AnhPhu4.png'),
('MA006', 'HS006', 'HS006_Chinh.png', 'HS006_AnhPhu1.png', 'HS006_AnhPhu2.png', 'HS006_AnhPhu3.png', 'HS006_AnhPhu4.png'),
('MA007', 'HS007', 'HS007_Chinh.png', 'HS007_AnhPhu1.png', 'HS007_AnhPhu2.png', 'HS007_AnhPhu3.png', 'HS007_AnhPhu4.png'),
('MA008', 'HS008', 'HS008_Chinh.png', 'HS008_AnhPhu1.png', 'HS008_AnhPhu2.png', 'HS008_AnhPhu3.png', 'HS008_AnhPhu4.png'),
('MA009', 'HS009', 'HS009_Chinh.png', 'HS009_AnhPhu1.png', 'HS009_AnhPhu2.png', 'HS009_AnhPhu3.png', 'HS009_AnhPhu4.png'),
('MA010', 'HS010', 'HS010_Chinh.png', 'HS010_AnhPhu1.png', 'HS010_AnhPhu2.png', 'HS010_AnhPhu3.png', 'HS010_AnhPhu4.png'),
('MA011', 'HS011', 'HS011_Chinh.png', 'HS011_AnhPhu1.png', 'HS011_AnhPhu2.png', 'HS011_AnhPhu3.png', 'HS011_AnhPhu4.png'),
('MA012', 'HS012', 'HS012_Chinh.png', 'HS012_AnhPhu1.png', 'HS012_AnhPhu2.png', 'HS012_AnhPhu3.png', 'HS012_AnhPhu4.png'),
('MA013', 'HS013', 'HS013_Chinh.png', 'HS013_AnhPhu1.png', 'HS013_AnhPhu2.png', 'HS013_AnhPhu3.png', 'HS013_AnhPhu4.png'),
('MA014', 'HS014', 'HS014_Chinh.png', 'HS014_AnhPhu1.png', 'HS014_AnhPhu2.png', 'HS014_AnhPhu3.png', 'HS014_AnhPhu4.png'),
('MA015', 'HS015', 'HS015_Chinh.png', 'HS015_AnhPhu1.png', 'HS015_AnhPhu2.png', 'HS015_AnhPhu3.png', 'HS015_AnhPhu4.png'),
('MA016', 'HS016', 'HS016_Chinh.png', 'HS016_AnhPhu1.png', 'HS016_AnhPhu2.png', 'HS016_AnhPhu3.png', 'HS016_AnhPhu4.png'),
('MA017', 'HS017', 'HS017_Chinh.png', 'HS017_AnhPhu1.png', 'HS017_AnhPhu2.png', 'HS017_AnhPhu3.png', 'HS017_AnhPhu4.png'),
('MA018', 'HS018', 'HS018_Chinh.png', 'HS018_AnhPhu1.png', 'HS018_AnhPhu2.png', 'HS018_AnhPhu3.png', 'HS018_AnhPhu4.png'),
('MA019', 'HS019', 'HS019_Chinh.png', 'HS019_AnhPhu1.png', 'HS019_AnhPhu2.png', 'HS019_AnhPhu3.png', 'HS019_AnhPhu4.png'),
('MA020', 'HS020', 'HS020_Chinh.png', 'HS020_AnhPhu1.png', 'HS020_AnhPhu2.png', 'HS020_AnhPhu3.png', 'HS020_AnhPhu4.png');

SELECT * FROM NhanVien



---INSERT DỮ LIỆU KHU VỰC
INSERT INTO KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
('KV001', N'TP. Hồ Chí Minh'),
('KV002', N'Đà Lạt'),
('KV003', N'Vũng Tàu'),
('KV004', N'Khánh Hòa'),
('KV005', N'Huế'),
('KV006', N'Hà Nội'),
('KV007', N'Kiên Giang'),
('KV008', N'Cần Thơ'),
('KV009', N'Quảng Ninh'),
('KV010', N'Ninh Bình'),
('KV011', N'Đà Nẵng');
select * from KhuVuc

---INSERT DỮ LIỆU HOMESTAY
INSERT INTO Homestay (MaHomestay, TenHomestay, MaKhuVuc, MaAnh, DiaChi, MoTa, GiaThue, SoLuongKhach, DienTich, TienNghi, NgayXayDung, MaNhanVienTruc, TrangThai, DiemTrungBinh) 
VALUES
('HS001', N'Green Valley', 'KV001','MA001', N'123 Đường A, TP. Hồ Chí Minh', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 120.000, 4, '5 X 10', N'Tivi, Máy lạnh, Wifi miễn phí', '2018-06-15', 'NV017',N'Đã đặt',3.5),
('HS002', N'Lakeview Retreat', 'KV001','MA002', N'456 Đường B, TP. Hồ Chí Minh', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 180.000, 6, '7 X 12', N'Tủ lạnh, Máy sấy tóc, Bồn tắm', '2020-03-10', 'NV005', N'Đã đặt',4.5),
('HS003', N'Sunshine Homestay', 'KV001','MA003', N'789 Đường C, TP. Hồ Chí Minh', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 150.000, 5, '9 X 13', N'Máy giặt, Lò vi sóng, Wifi miễn phí', '2019-07-20', 'NV006', N'Trống', 4.8),
('HS004', N'Ocean Bliss', 'KV002','MA004', N'101 Đường D, Đà Lạt', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 250.000, 8, '15 X 30', N'Bếp nấu ăn, Tivi màn hình lớn, Điều hòa', '2017-05-05', 'NV009', N'Đã đặt', 5.0),
('HS005', N'Mountain Escape', 'KV002','MA005', N'202 Đường E, Đà Lạt', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 140.000,  4, '5 X 12', N'Lò sưởi, Bếp BBQ, Wifi miễn phí', '2016-12-25', 'NV010', N'Đã đặt',3.8),
('HS006', N'Riverside Cozy', 'KV003','MA006', N'303 Đường F, Vũng Tàu', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 170.000,  5, '7 X 11', N'Tủ quần áo, Máy pha cà phê, Tivi', '2018-09-12', 'NV001', N'Đã đặt',2.5),
('HS007', N'Tropical Paradise', 'KV003','MA007', N'404 Đường G, Vũng Tàu', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 300.000,  10, '16 X 32', N'Hồ bơi, Bếp đầy đủ dụng cụ, Điều hòa', '2021-01-15', 'NV002', N'Đã đặt',2.0),
('HS008', N'City Lights', 'KV003','MA008', N'505 Đường H, Vũng Tàu', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 220.000,  4, '5 X 10', N'Tủ lạnh, Máy lạnh, Máy giặt', '2019-11-22', 'NV003', N'Đã đặt',4.2),
('HS009', N'Forest Retreat', 'KV010','MA009', N'606 Đường I, Ninh Bình', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 160.000 , 6, '10 X 11', N'Ghế massage, Lò sưởi, Máy giặt', '2015-08-30', 'NV018', N'Đã đặt',5.0),
('HS010', N'Heritage Haven', 'KV011','MA010', N'707 Đường J, Đà Nẵng', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 200.000,  5, '9 X 12', N'Bếp nhỏ, Máy lạnh, Wifi miễn phí', '2017-03-18', 'NV019', N'Đã đặt',4.1),
('HS011', N'Venti', 'KV004','MA011', N'709 Đường A, Khánh Hòa', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 300.000,  5, '6 X 10', N'Bếp nhỏ, Máy lạnh, Wifi miễn phí', '2017-05-19', 'NV020', N'Đã đặt',4.4),
('HS012', N'Jean Gunnhildr', 'KV004','MA012', N'409 Đường N, Khánh Hòa', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 320.000,  6, '10 X 12', N'Bếp lớn, Lò vi sóng ,Ti Vi, Máy lạnh, Wifi miễn phí', '2018-07-16', 'NV016', N'Đã đặt',2),
('HS013', N'Barbara Pegg', 'KV004','MA013', N'317 Đường H, Khánh Hòa', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 150.000, 4, '5 X 11', N'Ti vi, Máy lạnh', '2018-10-17', 'NV012', N'Đã đặt',3.1),
('HS014', N'Amber', 'KV005','MA014', N'709 Đường S, Huế', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 110.000,  5, '6 X 12', N'Bếp lớn, Lò nướng, Máy lạnh, Wifi miễn phí', '2019-05-19', 'NV008', N'Đã đặt',4.4),
('HS015', N'Lisa Minci', 'KV006','MA015', N'111 Đường B, Hà Nội', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 430.000,  12, '15 X 30', N'Máy lạnh, Lò vi sóng, Ti vi', '2018-06-19', 'NV011',N'Đã đặt', 4.8),
('HS016', N'Kaeya Alberich', 'KV007','MA016', N'256 Đường A, Kiên Giang', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 220.000,  5, '10 X 12', N'Máy giặt, Máy lạnh, Tủ quần áo, Wifi miễn phí', '2019-05-20', 'NV013',N'Đã đặt',5.0),
('HS017', N'Diluc Ragnvindr', 'KV007','MA017', N'356 Đường D, Kiên Giang', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 170.000,  5, '5 X 12', N'Bếp nhỏ, Máy lạnh, Wifi miễn phí', '2018-07-11', 'NV014', N'Đã đặt',3.4),
('HS018', N'Razor', 'KV008','MA018', N'852 Đường M, Cần Thơ', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 200.000, 5, '6 X 13', N'Tủ lạnh, Máy giặt, Ti vi', '2019-05-22', 'NV004', N'Đã đặt',5.0),
('HS019', N'Klee', 'KV008','MA019', N'135 Đường N, Cần Thơ', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 300.000, 10, '7 X 20', N'Bếp lớn, Máy lạnh, Wifi miễn phí, Lò nướng, Tủ lạnh', '2019-07-19', 'NV007', N'Đã đặt',4.1),
('HS020', N'Bennett', 'KV009','MA020', N'258 Đường J, Quảng Ninh', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo. Etiam maximus mi sollicitudin dolor convallis condimentum. Donec magna felis, gravida ac tincidunt quis, rutrum pulvinar elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque blandit urna at nibh maximus facilisis. <br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.<br /><br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque viverra libero sit amet massa rutrum convallis in eget nunc. Cras bibendum metus a metus feugiat, sollicitudin tristique velit rhoncus. Quisque lacinia rhoncus commodo.<br /><br />Curabitur leo lorem, interdum nec nibh vel, ullamcorper laoreet massa. Sed congue lorem elit, cursus venenatis dolor dictum et. Ut a felis vel massa aliquet tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In interdum nisi eget augue molestie blandit.', 240.000, 8, '5 X 8', N'Tủ lạnh, Bồn tắm, Máy chiếu phim, Máy pha Cafe', '2017-08-10', 'NV015', N'Đã đặt',2.7);

---INSERT DỮ LIỆU DỊCH VỤ
INSERT INTO DichVu (MaDichVu, TenDichVu, GiaDichVu, MoTaDichVu) VALUES
('DV001', N'Thuê xe máy', 150.000, N'Dịch vụ thuê xe máy hàng ngày'),
('DV002', N'Đưa đón sân bay', 200.000, N'Dịch vụ đưa đón sân bay tiện lợi'),
('DV003', N'Giặt ủi', 70.000, N'Giặt ủi lấy liền trong ngày'),
('DV004', N'Dịch vụ ăn uống', 100.000, N'Bữa ăn tại homestay'),
('DV005', N'Thú cưng', 20.000, N'Phí mang theo thú cưng mỗi ngày');

---INSERT DỮ LIỆU KHÁCH HÀNG
INSERT INTO KhachHang (MaKhachHang, TenKhachHang, CCCD, SDT, Email, DiaChiKH, MaTaiKhoan) VALUES
('KH001', N'Nguyễn Văn Xuân', '123456789012', '0901234567', 'x@gmail.com', N'123 Đường A, Hà Nội', 'TK022'),
('KH002', N'Trần Thị Yến Nhi', '223456789012', '0912345678', 'y@gmail.com', N'456 Đường B, Đà Nẵng', 'TK023'),
('KH003', N'Phạm Thị Mỹ Lệ', '423456789012', '0934567890', 'm@gmail.com', N'123 Đường D, Cần Thơ', 'TK024'),
('KH004', N'Đặng Văn Anh Tú', '523456789012', '0945678901', 'n@gmail.com', N'456 Đường E, Vũng Tàu', 'TK025'),
('KH005', N'Trần Văn Bích', '120325036025', '0945678901', 'c@gmail.com', N'852 Đường U, TP. Hà Nội', 'TK026'),
('KH006', N'Nguyễn Thị Viên', '9523625825425', '0945678901', 'd@gmail.com', N'365 Đường Y, TP. Trà Vinh', 'TK027'),
('KH007', N'Đỗ Ngọc Minh Thư', '841252369852', '0945678901', 'nf@gmail.com', N'425 Đường V, TP. Bình Dương', 'TK028'),
('KH008', N'Lê Anh Lộc', '523625236259', '0945678901', 'o@gmail.com', N'568 Đường K, TP. Khánh Hòa', 'TK029'),
('KH009', N'Đào Văn Xuyến', '895236523256', '0945678901', 'p@gmail.com', N'963 Đường O, TP. Sóc Trăng', 'TK030'),
('KH010', N'Trần Đại Du', '523523523526', '0945678901', 'q@gmail.com', N'789 Đường Q, TP. Đà Lạt', 'TK031'),
('KH011', N'Nguyễn Ngọc Thiên Chi', '236521425032', '0945678901', 'w@gmail.com', N'147 Đường K, TP. Long An', 'TK032'),
('KH012', N'Phạm Văn Phú', '785231452369', '0945678901', 'i@gmail.com', N'856 Đường Z, TP. HCM', 'TK033'),
('KH013', N'Ngô Anh Trang', '856856985693', '0945678901', 'h@gmail.com', N'409 Đường N, TP. Đà Nẵng', 'TK034'),
('KH014', N'Nguyễn Văn Tài', '789654123652', '0945678901', 'j@gmail.com', N'258 Đường J, TP. Hải Phòng', 'TK035'),
('KH015', N'Võ Văn Hùng', '123654258523', '0945678901', 'z@gmail.com', N'606 Đường I, TP. Đà Lạt', 'TK036');

----INSERT DỮ LIỆU ĐÁNH GIÁ
INSERT INTO DanhGia (MaDanhGia, MaKhachHang, MaHomestay, DiemDanhGia, NoiDungDanhGia) VALUES
('DG001', 'KH001', 'HS001', 5, N'Rất hài lòng với chất lượng dịch vụ và không gian thoải mái.'),
('DG002', 'KH002', 'HS002', 4, N'Phong cảnh đẹp, phòng sạch sẽ nhưng dịch vụ hơi chậm.'),
('DG003', 'KH003', 'HS003', 5, N'Giá cả hợp lý, view đẹp, tôi sẽ quay lại lần sau.'),
('DG004', 'KH004', 'HS004', 3, N'Dịch vụ tạm ổn, WiFi yếu và đồ dùng hơi cũ.'),
('DG005', 'KH001', 'HS005', 5, N'Homestay đẹp và tiện nghi, nhưng cách âm không tốt.'),
('DG006', 'KH005', 'HS006', 4, N'Phòng ốc sạch sẽ, đầy đủ tiện nghi, cảm giác như đang ở nhà mình vậy.'),
('DG007', 'KH006', 'HS007', 3, N'Vị trí thuận tiện, gần trung tâm nhưng vẫn giữ được sự yên bình.'),
('DG008', 'KH007', 'HS008', 5, N'Homestay có thiết kế độc đáo, mỗi góc đều rất ăn ảnh.'),
('DG009', 'KH008', 'HS009', 4, N'Dịch vụ tuyệt vời, đồ ăn sáng phong phú và ngon miệng.'),
('DG010', 'KH009', 'HS010', 3, N'Giá cả hợp lý, xứng đáng với chất lượng dịch vụ.'),
('DG011', 'KH010', 'HS011', 5, N'Không gian xanh mát, nhiều cây cối tạo cảm giác dễ chịu.'),
('DG012', 'KH011', 'HS012', 5, N'Phòng rộng rãi, thoáng mát và view nhìn ra núi rất đẹp.'),
('DG013', 'KH012', 'HS013', 3, N'Ban công rộng, có thể ngắm hoàng hôn rất đẹp.'),
('DG014', 'KH013', 'HS014', 4, N'Không gian lý tưởng cho nhóm bạn đi nghỉ dưỡng.'),
('DG015', 'KH014', 'HS015', 4, N'Homestay sử dụng nhiều vật liệu thân thiện với môi trường.')

select * from DanhGia

select * from ChiTietDatHomestay

---INSERT DỮ LIỆU CHI TIẾT ĐẶT HOMESTAY
INSERT INTO ChiTietDatHomestay (MaDatHomestay, MaKhachHang, MaHomestay, NgayDat, NgayNhan, NgayTra, SoLuongKhach, TongTien, TrangThai, GhiChu) VALUES 
('DH001', 'KH001', 'HS001', '2024-11-01', '2024-11-03', '2024-11-05', 4, 720.000, N'Chờ xác nhận', N'Không có yêu cầu đặc biệt.'),
('DH002', 'KH002', 'HS002', '2024-11-02', '2024-11-04', '2024-11-06', 2, 510.000, N'Hoàn thành', N'Yêu cầu thêm dịch vụ bữa sáng.'),
('DH003', 'KH003', 'HS003', '2024-11-03', '2024-11-05', '2024-11-07', 3, 760.000, N'Chờ xác nhận', N'Không có yêu cầu đặc biệt.'),
('DH004', 'KH004', 'HS004', '2024-11-04', '2024-11-06', '2024-11-09', 6, 1250.000, N'Chờ xác nhận', N'Set up nhà bếp chung đầy đủ tiện nghi để khách tự nấu.'),
('DH005', 'KH005', 'HS005', '2024-11-05', '2024-11-07', '2024-11-09', 5, 650.000, N'Hoàn thành', N'Chuẩn bị sẵn nước uống đóng chai miễn phí hàng ngày.'),
('DH006', 'KH006', 'HS006', '2024-11-06', '2024-11-08', '2024-11-09', 4, 430.000, N'Chờ xác nhận', N'Dịch vụ giao đồ ăn tận phòng.'),
('DH007', 'KH007', 'HS007', '2024-11-07', '2024-11-09', '2024-11-09', 2, 650.000, N'Hoàn thành', N'Không có yêu cầu đặc biệt.'),
('DH008', 'KH008', 'HS008', '2024-11-08', '2024-11-10', '2024-11-09', 6, 580.000, N'Hoàn thành', N'Bữa sáng tùy chọn theo khẩu vị khách .'),
('DH009', 'KH009', 'HS009', '2024-11-09', '2024-11-11', '2024-11-09', 5, 630.000, N'Chờ xác nhận', N'Không có yêu cầu đặc biệt.'),
('DH010', 'KH010', 'HS010', '2024-11-10', '2024-11-12', '2024-11-09', 6, 1150.000, N'Chờ xác nhận', N'Cung cấp dịch vụ BBQ ngoài trời.'),
('DH011', 'KH011', 'HS011', '2024-11-11', '2024-11-13', '2024-11-09', 3, 720.000, N'Chờ xác nhận', N'Không có yêu cầu đặc biệt.'),
('DH012', 'KH012', 'HS012', '2024-11-12', '2024-11-14', '2024-11-09', 2, 650.000, N'Hoàn thành', N'Cho thuê xe máy, xe đạp hoặc ô tô tự lái.'),
('DH013', 'KH013', 'HS013', '2024-11-13', '2024-11-15', '2024-11-09', 3, 1350.000, N'Chờ xác nhận', N'Bố trí góc làm việc với bàn ghế và ổ cắm điện.'),
('DH014', 'KH014', 'HS014', '2024-11-14', '2024-11-16', '2024-11-09', 4, 1920.000, N'Hoàn thànhn', N'Dịch vụ giữ trẻ để phụ huynh có thời gian nghỉ ngơi.'),
('DH015', 'KH015', 'HS015', '2024-11-15', '2024-11-17', '2024-11-09', 5, 2250.000, N'Chờ xác nhận', N'Không có yêu cầu đặc biệt.');
---INSERT DỮ LIỆU DỊCH VỤ 
INSERT INTO ChiTietDichVuDatHomestay (MaChiTietDichVuDatHomestay, MaDatHomestay, MaDichVu, SoLuong, TongTienDichVu) VALUES 
('DVCT001', 'DH001', 'DV001', 1, 500000),
('DVCT002', 'DH002', 'DV002', 2, 300000),
('DVCT003', 'DH003', 'DV003', 3, 300000),
('DVCT004', 'DH005', 'DV004', 2, 600000),
('DVCT005', 'DH004', 'DV005', 2, 700000),
('DVCT006', 'DH006', 'DV001', 1, 100000),
('DVCT007', 'DH007', 'DV003', 3, 200000),
('DVCT008', 'DH008', 'DV005', 3, 100000),
('DVCT009', 'DH009', 'DV005', 2, 200000),
('DVCT010', 'DH010', 'DV001', 1, 300000),
('DVCT011', 'DH011', 'DV002', 3, 400000),
('DVCT012', 'DH012', 'DV003', 2, 800000),
('DVCT013', 'DH013', 'DV004', 3, 400000),
('DVCT014', 'DH014', 'DV004', 1, 500000),
('DVCT015', 'DH015', 'DV005', 1, 500000);
select * from ChiTietDichVuDatHomestay

--INSERT DỮ LIỆU THANH TOÁN
INSERT INTO ThanhToan (MaThanhToan, MaDatHomestay, NgayThanhToan, PhuongThucThanhToan, SoTien, TrangThaiTT, GhiChu) VALUES
('TT001', 'DH001', '2024-11-06', N'Thanh toán online', 450.000, N'Đã thanh toán', N'Không có ghi chú'),
('TT002', 'DH002', '2024-11-07', N'Thẻ tín dụng', 700.000, N'Đã thanh toán', N'Đã gửi hóa đơn qua email'),
('TT003', 'DH003', '2024-11-08', N'Tiền mặt', 1020.000, N'Đã thanh toán', N'Khách hàng yêu cầu nhận hóa đơn VAT'),
('TT004', 'DH005', '2024-11-09', N'Thanh toán online', 6500000, N'Đã thanh toán', N'Hoàn tất thanh toán qua cổng online'),
('TT005', 'DH005', '2024-11-10', N'Tiền mặt', 1000.000, N'Đã thanh toán', N'Hoàn tất thanh toán qua cổng online'),
('TT006', 'DH006', '2024-11-11', N'Thanh toán online', 1500.000, N'Đã thanh toán', N'Hoàn tất thanh toán qua cổng online'),
('TT007', 'DH007', '2024-11-12', N'Tiền mặt', 2500.000, N'Đã thanh toán', N'Không có ghi chú'),
('TT008', 'DH008', '2024-11-13', N'Thanh toán online', 2000.000, N'Đã thanh toán', N'Đã gửi hóa đơn qua email'),
('TT009', 'DH009', '2024-11-14', N'Thẻ tín dụng', 1300.000, N'Đã thanh toán', N'Đã gửi hóa đơn qua email'),
('TT010', 'DH010', '2024-11-15', N'Tiền mặt', 600.000, N'Đã thanh toán', N'Hoàn tất thanh toán qua cổng online'),
('TT011', 'DH011', '2024-11-16', N'Thanh toán online', 550.000, N'Đã thanh toán', N'Đã gửi hóa đơn qua email'),
('TT012', 'DH012', '2024-11-17', N'Thanh toán online', 450.000, N'Đã thanh toán', N'Không có ghi chú'),
('TT013', 'DH013', '2024-11-18', N'Thẻ tín dụng', 950.000, N'Đã thanh toán', N'Đã gửi hóa đơn qua email'),
('TT014', 'DH014', '2024-11-19', N'Tiền mặt', 250.000, N'Đã thanh toán', N'Khách hàng yêu cầu nhận hóa đơn VAT'),
('TT015', 'DH015', '2024-11-20', N'Thẻ tín dụng', 850.000, N'Đã thanh toán', N'Khách hàng yêu cầu nhận hóa đơn VAT');

SELECT * FROM ThanhToan
--INSERT DỮ LIỆU BẢO DƯỠNG
INSERT INTO BaoDuong (MaBaoDuong, MaHomestay, NgayBaoDuong, NgayHoanThanh, ChiPhi, MoTaCongViec, TrangThai) VALUES
('BD001', 'HS001', '2024-10-01', '2024-10-05', 500.000, N'Sửa chữa hệ thống điện', N'Hoàn thành'),
('BD002', 'HS002', '2024-10-02', '2024-10-07', 550.000, N'Vệ sinh tổng quát', N'Hoàn thành'),
('BD003', 'HS003', '2024-10-03', NULL, 1000.000, N'Sửa chữa cửa sổ', N'Đang thực hiện'),
('BD004', 'HS004', '2024-10-04', '2024-10-08', 2500.000, N'Thay mới nội thất', N'Hoàn thành'),
('BD005', 'HS005', '2024-10-05', NULL, 1000.000, N'Vệ sinh tổng quát', N'Đang thực hiện'),
('BD006', 'HS006', '2024-10-06', NULL, 2000.000, N'Sửa chữa hệ thống điện', N'Đang thực hiện'),
('BD007', 'HS007', '2024-10-07', '2024-10-09', 3000.000, N'Vệ sinh tổng quát', N'Hoàn thành'),
('BD008', 'HS008', '2024-10-08', NULL, 1500.000, N'Sửa chữa hệ thống điện', N'Đang thực hiện'),
('BD009', 'HS009', '2024-10-09', '2024-10-11', 2500.000, N'Thay mới nội thất', N'Hoàn thành'),
('BD010', 'HS010', '2024-10-10', '2024-10-12',1000.000, N'Kiểm tra hệ thống cấp thoát nước', N'Hoàn thành'),
('BD011', 'HS011', '2024-10-11', NULL, 3500.000, N'Vệ sinh tổng quát', N'Đang thực hiện'),
('BD012', 'HS012', '2024-10-12', '2024-10-13', 2500.000, N'Thay mới nội thất', N'Hoàn thành'),
('BD013', 'HS013', '2024-10-13','2024-10-15', 2000.000, N'Kiểm tra hệ thống cấp thoát nước', N'Hoàn thành'),
('BD014', 'HS014', '2024-10-14', NULL, 1500.000, N'Sửa chữa hệ thống điện', N'Đang thực hiện'),
('BD015', 'HS015', '2024-10-15', '2024-10-19', 1000.000, N'Thay mới nội thất', N'Hoàn thành');

SELECT * FROM BaoDuong

-------------------------------------------
-- Trigger tự động thông báo bảo dưỡng định kỳ

-- Function tính tiền thuê homestay thông thường

-- Procedure kiểm tra phòng trống

--  Trigger tự động cập nhật tổng tiền khi thêm/sửa chi tiết dịch vụ
CREATE TRIGGER trg_CapNhatTongTien
ON ChiTietDichVu
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @MaDatHomestay VARCHAR(10)

    -- Lấy MaDatHomestay từ bản ghi được thêm/sửa/xóa
    SELECT @MaDatHomestay = MaDatHomestay FROM inserted
    IF @MaDatHomestay IS NULL
        SELECT @MaDatHomestay = MaDatHomestay FROM deleted

    -- Cập nhật tổng tiền
    IF @MaDatHomestay IS NOT NULL
        EXEC sp_CapNhatTongTien @MaDatHomestay
END

--Kiểm tra xem ngày đặt có hợp lệ không
CREATE TRIGGER trg_KiemTraNgayDatHomestay
ON ChiTietDatHomestay
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE NgayTra <= NgayNhan  
        OR NgayNhan < NgayDat     
    )
    BEGIN
        RAISERROR (N'Lỗi: Ngày không hợp lệ! Ngày trả phải sau ngày nhận và ngày nhận phải sau ngày đặt.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END

---trigger mã hóa hashtable
CREATE TRIGGER trg_HashPassword
ON TaiKhoan
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO TaiKhoan (MaTaiKhoan, TenDangNhap, MatKhau, Email, NgayTao, Role)
        SELECT 
            MaTaiKhoan,
            TenDangNhap,
            CASE 
                WHEN LEN(MatKhau) = 64 THEN MatKhau -- Giả định mật khẩu băm SHA256 luôn có độ dài 64 ký tự
                ELSE CONVERT(VARCHAR(100), HASHBYTES('SHA2_256', MatKhau), 2) 
            END,
            Email,
            ISNULL(NgayTao, GETDATE()),
            Role
        FROM inserted;
    END
END;

