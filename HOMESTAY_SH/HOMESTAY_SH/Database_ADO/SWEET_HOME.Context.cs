﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class QLH_SWEETHOMEEntities : DbContext
    {
        public QLH_SWEETHOMEEntities()
            : base("name=QLH_SWEETHOMEEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<AnhHomestay> AnhHomestays { get; set; }
        public virtual DbSet<BaoDuong> BaoDuongs { get; set; }
        public virtual DbSet<ChiTietDatHomestay> ChiTietDatHomestays { get; set; }
        public virtual DbSet<ChiTietDichVuDatHomestay> ChiTietDichVuDatHomestays { get; set; }
        public virtual DbSet<DanhGia> DanhGias { get; set; }
        public virtual DbSet<DichVu> DichVus { get; set; }
        public virtual DbSet<Homestay> Homestays { get; set; }
        public virtual DbSet<KhachHang> KhachHangs { get; set; }
        public virtual DbSet<KhuVuc> KhuVucs { get; set; }
        public virtual DbSet<NhanVien> NhanViens { get; set; }
        public virtual DbSet<TaiKhoan> TaiKhoans { get; set; }
        public virtual DbSet<ThanhToan> ThanhToans { get; set; }
    }
}