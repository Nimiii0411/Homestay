using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class HomestayItemDiscount
    {
        public string MaHomestay {  get; set; }
        public string TenHomestay { get; set; }
        public string MoTa { get; set; }
        public string TienNghi { get; set; }
        public string TenKhuVuc { get; set; }
        public double? DiemTrungBinh { get; set; }
        public string AnhChinh { get; set; }
        public string DienTich { get; set; }
    }
}