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
    
    public partial class NhanVien
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public NhanVien()
        {
            this.Homestays = new HashSet<Homestay>();
        }
    
        public string MaNhanVien { get; set; }
        public string TenNhanVien { get; set; }
        public string DiaChiNV { get; set; }
        public string SDT_NV { get; set; }
        public string CCCD { get; set; }
        public string ChucVu { get; set; }
        public string MaTaiKhoan { get; set; }
        public string MaKhuVuc { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Homestay> Homestays { get; set; }
        public virtual KhuVuc KhuVuc { get; set; }
        public virtual TaiKhoan TaiKhoan { get; set; }
    }
}
