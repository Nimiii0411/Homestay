using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class HomestayDetailViewModel
    {
            public string MaKhachHang {  get; set; }
            public string MaHomestay { get; set; }
            public string TenHomestay { get; set; }
            public string TenKhuVuc { get; set; }
            public string DiaChi { get; set; }
            public double GiaThue { get; set; }
            public double? DiemTrungBinh { get; set; }
            public string AnhChinh { get; set; }
            public string AnhPhu1 { get; set; }
            public string AnhPhu2 { get; set; }
            public string AnhPhu3 { get; set; }
            public string AnhPhu4 { get; set; }
            public int SoLuongKhach { get; set; }
            public string DienTich { get; set; }
            public string MoTa { get; set; }
            public string TienNghi { get; set; }
        }

}