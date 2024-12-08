using HOMESTAY_SH.Database_ADO;
using HOMESTAY_SH.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace HOMESTAY_SH.Controllers
{
    public class SortController : Controller
    {

        public ActionResult AllHomestay(int? page)
        {
            int pageSize = 5; // Số lượng homestay trên mỗi trang
            int pageNumber = page ??1; // Trang hiện tại, mặc định là 1

            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Lấy tổng số bản ghi
                var totalRecords = db.Homestays.Count();

                // Lấy danh sách homestay cho trang hiện tại
                var Allhomestay = (from homestay in db.Homestays
                                   join khuvuc in db.KhuVucs
                                   on homestay.MaKhuVuc equals khuvuc.MaKhuVuc
                                   join anh in db.AnhHomestays
                                   on homestay.MaAnh equals anh.MaAnh
                                   orderby homestay.TenHomestay // Sắp xếp theo tên
                                   select new HomestayDetailViewModel
                                   {
                                       MaHomestay = homestay.MaHomestay,
                                       TenHomestay = homestay.TenHomestay,
                                       TenKhuVuc = khuvuc.TenKhuVuc,
                                       DiemTrungBinh = homestay.DiemTrungBinh,
                                       TienNghi = homestay.TienNghi,
                                       AnhChinh = anh.AnhChinh
                                   })
                                  .Skip((pageNumber - 1) * pageSize)
                                  .Take(pageSize)
                                  .ToList();

                // Tạo dữ liệu phân trang để gửi đến View
                ViewBag.TotalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                ViewBag.CurrentPage = pageNumber;

                return View("AllHomestay", Allhomestay);
            }
        }


    }
}