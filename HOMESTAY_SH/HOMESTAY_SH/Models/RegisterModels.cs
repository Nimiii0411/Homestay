using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SWEET_HOME.Models
{
    public class RegisterModels
    {
        public string MaKH { get; set; }
        public string MaTK {  get; set; }
        public string TenKhachHang { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPass { get; set; }    
        public string CCCD { get; set; }
        public string SDT { get; set; }
        public string DiaChi { get; set; }
        public DateTime NgayTao { get; set; }
       
    }
}