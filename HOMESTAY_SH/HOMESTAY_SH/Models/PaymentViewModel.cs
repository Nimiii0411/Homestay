using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class PaymentViewModel
    {
        public string MaDatHomestay { get; set; }
        public string PhuongThucThanhToan { get; set; }
        public float TongTien { get; set; }
        public string GhiChu { get; set; }
    }

}