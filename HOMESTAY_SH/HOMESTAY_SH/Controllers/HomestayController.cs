using HOMESTAY_SH.Database_ADO;
using HOMESTAY_SH.Models;
using SWEET_HOME.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static HOMESTAY_SH.Models.HomestayDetailViewModel;

namespace SWEET_HOME.Controllers
{
    public class HomestayController : Controller
    {
        // GET: Homestay
        public ActionResult Homestay_item_best()
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Lấy danh sách các homestay có điểm đánh giá >= 3.5 và join với bảng AnhHomestay
                var homestayBest = db.Homestays
                                      .Where(h => h.DiemTrungBinh >= 3.5)
                                      .OrderByDescending(h => h.DiemTrungBinh)
                                      .Select(h => new HomestayItemBestViewModel
                                      {
                                          MaHomestay = h.MaHomestay,
                                          TenHomestay = h.TenHomestay,
                                          MoTa = h.MoTa,
                                          TienNghi = h.TienNghi,
                                          DienTich = h.DienTich,
                                          DiemTrungBinh = h.DiemTrungBinh,
                                          AnhChinh = h.AnhHomestay.AnhChinh,

                                      })
                                      .ToList();

                return View("Homestay_Item_Best", homestayBest); // Return the full view with images
            }
        }

        public ActionResult Homestay_item_discount()
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Lấy danh sách các homestay có điểm đánh giá <= 3.5 và join với bảng AnhHomestay
                var homestayDiscount = (from homestay in db.Homestays
                                        join khuvuc in db.KhuVucs
                                        on homestay.MaKhuVuc equals khuvuc.MaKhuVuc // Join với MaKhuVuc thay vì TenKhuVuc
                                        join anh in db.AnhHomestays
                                        on homestay.MaAnh equals anh.MaAnh // Join với MaAnh
                                        where homestay.DiemTrungBinh <= 3.5
                                        orderby homestay.DiemTrungBinh descending
                                        select new HomestayItemDiscount
                                        {
                                            MaHomestay = homestay.MaHomestay,
                                            TenHomestay = homestay.TenHomestay,
                                            TenKhuVuc = khuvuc.TenKhuVuc,
                                            DiemTrungBinh = homestay.DiemTrungBinh,
                                            AnhChinh = anh.AnhChinh // Lấy hình ảnh chính từ bảng AnhHomestay
                                        }).ToList();




                return View("Homestay_Item_Discount", homestayDiscount); // Return the data to the view
            }
        }

        //search
        public ActionResult Search(string searchQuery)
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                var homestay = (from hs in db.Homestays
                                where hs.TenHomestay.Contains(searchQuery)
                                select new { hs.MaHomestay }).FirstOrDefault();

                if (homestay == null)
                {
                    // Nếu không tìm thấy homestay, có thể hiển thị thông báo hoặc quay về trang chủ
                    TempData["Message"] = "Không tìm thấy homestay nào phù hợp!";
                    return RedirectToAction("Index", "Home");
                }

                // Chuyển hướng sang trang chi tiết của homestay
                return RedirectToAction("Detail", new { MaHomestay = homestay.MaHomestay });
            }
        }
        public ActionResult SearchSuggestions(string keyword)
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                var suggestions = db.Homestays
                    .Where(hs => hs.TenHomestay.Contains(keyword))
                    .Select(hs => new
                    {
                        hs.MaHomestay,
                        hs.TenHomestay,
                        hs.DiaChi
                    })
                    .ToList();

                return Json(suggestions, JsonRequestBehavior.AllowGet);
            }
        }


        public ActionResult Detail(string MaHomestay, string maKhachHang)
        {
           
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                var Detailhomestay = (from hs in db.Homestays
                                      join kv in db.KhuVucs on hs.MaKhuVuc equals kv.MaKhuVuc
                                      join anh in db.AnhHomestays on hs.MaAnh equals anh.MaAnh
                                      where hs.MaHomestay == MaHomestay
                                      select new HomestayDetailViewModel
                                      {
                                          MaHomestay = hs.MaHomestay,
                                          TenHomestay = hs.TenHomestay,
                                          TenKhuVuc = kv.TenKhuVuc,
                                          DiaChi = hs.DiaChi,
                                          GiaThue = hs.GiaThue,
                                          AnhChinh = anh.AnhChinh,
                                          AnhPhu1 = anh.AnhPhu1,
                                          AnhPhu2 = anh.AnhPhu2,
                                          AnhPhu3 = anh.AnhPhu3,
                                          AnhPhu4 = anh.AnhPhu4,
                                          SoLuongKhach = hs.SoLuongKhach,
                                          DienTich = hs.DienTich,
                                          MoTa = hs.MoTa,
                                          TienNghi = hs.TienNghi
                                      }).FirstOrDefault();

                if (Detailhomestay == null) return HttpNotFound();
                return View(Detailhomestay);
            }
        }
        private string GenerateMaCTDatHomestay()
        {
            // Logic sinh mã đặt homestay duy nhất
            // Ví dụ: DH + mã tự tăng
            return "DH" + DateTime.Now.ToString("yyyyMMdd") + new Random().Next(1000, 9999).ToString();
        }

        private string GenerateMaThanhToan()
        {
            return "TT" + Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper();
        }
        [HttpGet]
        public ActionResult DatHomestay(string MaHomestay)
        {
            using (var db = new QLH_SWEETHOMEEntities())
            {
                var maKhachHang = Session["MaKhachHang"] as string;
                if (string.IsNullOrEmpty(maKhachHang))
                {
                    TempData["ErrorMessage"] = "Vui lòng đăng nhập để đặt homestay.";
                    return RedirectToAction("Login", "Account");
                }

                var currentUser = db.KhachHangs.Find(maKhachHang);
                if (currentUser == null)
                {
                    TempData["ErrorMessage"] = "Không tìm thấy thông tin người dùng.";
                    return RedirectToAction("Login", "Account");
                }

                var homestay = db.Homestays.Find(MaHomestay);
                if (homestay == null)
                {
                    ModelState.AddModelError("", "Homestay không tồn tại hoặc đã bị xóa.");
                    return RedirectToAction("Index", "Home");
                }

                // Ánh xạ dữ liệu từ DichVus vào DichVuViewModel
                var dichVus = db.DichVus.Select(dv => new DichVuViewModel
                {
                    MaDichVu = dv.MaDichVu,
                    TenDichVu = dv.TenDichVu,
                    GiaDichVu = dv.GiaDichVu ?? 0,  // Giá dịch vụ có thể là null, nên phải xử lý
                    MoTaDichVu = dv.MoTaDichVu
                }).ToList();

                var bookingViewModel = new HomestayBookingViewModel
                {
                    MaHomestay = MaHomestay,
                    TenHomestay = homestay.TenHomestay,
                    GiaThue = homestay.GiaThue,
                    MaKhachHang = maKhachHang,
                    TenKhachHang = currentUser.TenKhachHang,
                    Email = currentUser.Email,
                    SDT = currentUser.SDT,
                    NgayDat = DateTime.Now,
                    NgayNhan = DateTime.Now,
                    NgayTra = DateTime.Now.AddDays(1),
                    TrangThai = "Chờ xác nhận",
                    DichVuAvailable = dichVus,  // Gán danh sách dịch vụ đã ánh xạ vào ViewModel
                    SelectedDichVuIds = new List<string>()
                };

                return View(bookingViewModel);
            }
        }
        //public ActionResult DatHomestay(int maHomestay)
        //{
        //    var homestay = _homestayService.GetHomestayById(maHomestay); // Lấy thông tin homestay
        //    var dichVuAvailable = _dichVuService.GetDichVuByHomestay(maHomestay); // Lấy danh sách dịch vụ

        //    var model = new HomestayBookingViewModel
        //    {
        //        MaHomestay = homestay.MaHomestay,
        //        TenHomestay = homestay.TenHomestay,
        //        GiaThue = homestay.GiaThue,
        //        DichVuAvailable = dichVuAvailable // Truyền danh sách dịch vụ
        //    };

        //    return View(model);
        //}


        [HttpPost]
        public ActionResult DatHomestay(HomestayBookingViewModel model)
        {
            using (var db = new QLH_SWEETHOMEEntities())
            {
                if (!ModelState.IsValid)
                {
                    model.DichVuAvailable = db.DichVus
                        .Select(dv => new DichVuViewModel
                        {
                            MaDichVu = dv.MaDichVu,
                            TenDichVu = dv.TenDichVu,
                            GiaDichVu = dv.GiaDichVu ?? 0,
                            MoTaDichVu = dv.MoTaDichVu
                        }).ToList();
                    return View(model);
                }

                using (var transaction = db.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.NgayTra <= model.NgayNhan)
                        {
                            ModelState.AddModelError(nameof(model.NgayTra), "Ngày trả phải lớn hơn ngày nhận.");
                            return View(model);
                        }

                        var maDatHomestay = GenerateBookingCode();
                        var tongTienDichVu = CalculateServiceTotal(db, model.SelectedDichVuIds, model.SoNgayThue);
                        var booking = CreateBookingDetail(model, maDatHomestay, model.TongTienThue + tongTienDichVu);
                        db.ChiTietDatHomestays.Add(booking);

                        var payment = CreatePayment(maDatHomestay, model.PhuongThucThanhToan, model.TongTienThue + tongTienDichVu, model.GhiChu);
                        db.ThanhToans.Add(payment);

                        if (model.SelectedDichVuIds?.Any() == true)
                        {
                            SaveServiceDetails(db, maDatHomestay, model.SelectedDichVuIds, model.SoNgayThue);
                        }

                        db.SaveChanges();
                        transaction.Commit();

                        return RedirectToAction("BookingConfirmation", new { bookingId = maDatHomestay });
                    }
                    catch
                    {
                        transaction.Rollback();
                        return View(model);
                    }
                }
            }
        }


        // Tính tổng tiền dịch vụ
        private double CalculateServiceTotal(QLH_SWEETHOMEEntities db, List<string> selectedServices, int numberOfDays)
        {
            if (selectedServices == null || !selectedServices.Any())
                return 0;

            // Lấy danh sách dịch vụ theo danh sách ID đã chọn
            var services = db.DichVus
                .Where(dv => selectedServices.Contains(dv.MaDichVu) && dv.GiaDichVu.HasValue)
                .ToList();

            // Tính tổng giá trị dịch vụ
            return services.Sum(service => service.GiaDichVu.Value * numberOfDays);
        }


        // Sinh mã đặt homestay
        private string GenerateBookingCode()
        {
            return "HD" + DateTime.Now.ToString("yyyyMMddHHmmss");
        }


        // Tạo chi tiết đặt homestay
        private ChiTietDatHomestay CreateBookingDetail(HomestayBookingViewModel model, string maDatHomestay, double tongTien)
        {
            return new ChiTietDatHomestay
            {
                MaDatHomestay = maDatHomestay,
                MaKhachHang = model.MaKhachHang,
                MaHomestay = model.MaHomestay,
                NgayDat = DateTime.Now,
                NgayNhan = model.NgayNhan,
                NgayTra = model.NgayTra,
                SoLuongKhach = model.SoLuongNguoi,
                TongTien = tongTien,
                TrangThai = "Chờ xác nhận",
                GhiChu = model.GhiChu
            };
        }


        // Tạo thanh toán
        private ThanhToan CreatePayment(string bookingCode, string paymentMethod, double amount, string note)
        {
            return new ThanhToan
            {
                MaThanhToan = "TT" + DateTime.Now.ToString("yyyyMMdd") + Guid.NewGuid().ToString("N"),
                MaDatHomestay = bookingCode,
                NgayThanhToan = DateTime.Now,
                PhuongThucThanhToan = paymentMethod,
                SoTien = amount,
                TrangThaiTT = "Chưa thanh toán",
                GhiChu = ""
            };
        }

        // Lưu chi tiết dịch vụ
        private void SaveServiceDetails(QLH_SWEETHOMEEntities db, string maDatHomestay, List<string> selectedDichVuIds, int soNgayThue)
        {
            foreach (var maDichVu in selectedDichVuIds)
            {
                var dichVu = db.DichVus.FirstOrDefault(dv => dv.MaDichVu == maDichVu);
                if (dichVu != null)
                {
                    db.ChiTietDichVuDatHomestays.Add(new ChiTietDichVuDatHomestay
                    {
                        MaChiTietDichVuDatHomestay = Guid.NewGuid().ToString().Substring(0, 10).ToUpper(),
                        MaDatHomestay = maDatHomestay,
                        MaDichVu = maDichVu,
                        SoLuong = soNgayThue,
                        TongTienDichVu = (dichVu.GiaDichVu ?? 0) * soNgayThue
                    });
                }
            }
        }



        // Sinh mã chi tiết dịch vụ
        private string GenerateServiceDetailCode()
        {
            return "CTDV" + DateTime.Now.ToString("yyyyMMddHHmmss") +
                   new Random().Next(1000, 9999).ToString();
        }

    }
}
