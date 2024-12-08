
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class DichVuViewModel
    {
        public string MaDatHomestay { get; set; }
        public string MaDichVu { get; set; }
        public string TenDichVu { get; set; }
        public double GiaDichVu { get; set; } // Nullable type
        public string MoTaDichVu { get; set; }

    }
}