//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HOMESTAY_SH.Database_ADO
{
    using System;
    using System.Collections.Generic;
    
    public partial class ThanhToan
    {
        public string MaThanhToan { get; set; }
        public string MaDatHomestay { get; set; }
        public Nullable<System.DateTime> NgayThanhToan { get; set; }
        public string PhuongThucThanhToan { get; set; }
        public Nullable<double> SoTien { get; set; }
        public string TrangThaiTT { get; set; }
        public string GhiChu { get; set; }
    
        public virtual ChiTietDatHomestay ChiTietDatHomestay { get; set; }
    }
}
