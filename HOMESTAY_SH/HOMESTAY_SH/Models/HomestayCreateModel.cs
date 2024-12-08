using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class HomestayCreateModel
    {     
            public string TenHomestay { get; set; }
            public string KhuVuc { get; set; }
            public string DiaChi { get; set; }
            public string MoTa { get; set; }
            public float GiaThue { get; set; }
            public int SoLuongKhach { get; set; }
            public string DienTich { get; set; }
            public string TienNghi { get; set; }
            public DateTime? NgayXayDung { get; set; }
            public string MaNhanVienTruc { get; set; }
            public string TrangThai { get; set; }
            public float? DiemTrungBinh { get; set; }
        
    }
}