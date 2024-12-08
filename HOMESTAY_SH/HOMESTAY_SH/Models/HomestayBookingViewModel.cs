using HOMESTAY_SH.Database_ADO;
using System.Collections.Generic;
using System;
using System.ComponentModel.DataAnnotations;
using HOMESTAY_SH.Models;

public class HomestayBookingViewModel
{

    
        public string MaHomestay { get; set; }
        public string TenHomestay { get; set; }
        public double GiaThue { get; set; }
        public string MaKhachHang { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tên")]
        [Display(Name = "Tên Khách Hàng")]
        public string TenKhachHang { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập email")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số CCCD")]
        [StringLength(12, MinimumLength = 9, ErrorMessage = "Số CCCD phải từ 9 đến 12 ký tự")]
        [Display(Name = "Số CCCD")]
        public string SoCCCD { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [Phone(ErrorMessage = "Số điện thoại không hợp lệ")]
        [Display(Name = "Số Điện Thoại")]
        public string SDT { get; set; }
        public DateTime NgayDat {  get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ngày nhận")]
        [Display(Name = "Ngày Nhận")]
        [DataType(DataType.Date)]
        public DateTime NgayNhan { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ngày trả")]
        [Display(Name = "Ngày Trả")]
        [DataType(DataType.Date)]
        public DateTime NgayTra { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số lượng người")]
        [Range(1, 10, ErrorMessage = "Số lượng người phải từ 1 đến 10")]
        [Display(Name = "Số Lượng Người")]
        public int SoLuongNguoi { get; set; }

        [Display(Name = "Ghi Chú")]
        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string GhiChu { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn phương thức thanh toán")]
        [Display(Name = "Phương Thức Thanh Toán")]

        public string TrangThai { get; set; }
        public string PhuongThucThanhToan { get; set; }

        // Tính toán số ngày thuê
        public int SoNgayThue => NgayTra > NgayNhan ? (NgayTra - NgayNhan).Days : 0;

        // Danh sách dịch vụ
        public List<DichVuViewModel> DichVuAvailable { get; set; } = new List<DichVuViewModel>();

    // Các dịch vụ được chọn
    public List<string> SelectedDichVuIds { get; set; } = new List<string>();



    // Tính tổng tiền thuê homestay
    public double TongTienThue => GiaThue * SoNgayThue;

        // Tính tổng tiền dịch vụ
        public double TongTienDichVu { get; set; }

        // Tổng tiền thanh toán cuối cùng
        public double TongTienThanhToan => TongTienThue + TongTienDichVu;
    }

