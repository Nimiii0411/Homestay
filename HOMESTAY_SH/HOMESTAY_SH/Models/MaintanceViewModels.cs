using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SWEET_HOME.Models
{
    public class MaintanceViewModels
    {
        public string MaBaoDuong { get; set; }
        public string TenHomestay {  get; set; }
        public Nullable<double> ChiPhi { get; set; }
        public Nullable<System.DateTime> NgayBaoDuong { get; set; }
        public Nullable<System.DateTime> NgayHoanThanh { get; set; }
        public string TrangThai {  get; set; }

    }
}