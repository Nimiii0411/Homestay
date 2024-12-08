using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HOMESTAY_SH.Models
{
    public class TaiKhoanViewModels
    {
        public string MaTK {  get; set; }
        public string TenTaiKhoan { get; set; }
        public string MatKhau { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
        public DateTime NgayTao { get; set; }
    }
}