using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using HOMESTAY_SH.Database_ADO;
using SWEET_HOME.Models;
namespace SWEET_HOME.Controllers
{
    public class Admin_PageController : Controller
    {
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (var b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
        // GET: Admin_Page
        [HttpGet]
        public ActionResult CreateAccount()
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Danh sách khu vực
                ViewBag.KhuVucList = db.KhuVucs.Select(k => new SelectListItem
                {
                    Value = k.MaKhuVuc,
                    Text = k.TenKhuVuc
                }).ToList();

                // Tài khoản chưa được sử dụng
                ViewBag.AvailableAccounts = db.TaiKhoans
                    .Where(t => !db.NhanViens.Any(nv => nv.MaTaiKhoan == t.MaTaiKhoan))
                    .Select(t => new SelectListItem
                    {
                        Value = t.MaTaiKhoan,
                        Text = t.TenDangNhap
                    }).ToList();

                // Tạo danh sách vai trò
                ViewBag.RoleList = new List<SelectListItem>
        {
            new SelectListItem { Value = "Nhân viên trực", Text = "Nhân viên trực" },
            new SelectListItem { Value = "Khách hàng", Text = "Khách hàng" }
        };

                return View();
            }
        }

        [HttpPost]
        public ActionResult CreateAccount(TaiKhoan model)
        {
            if (ModelState.IsValid)
            {
                using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
                {
                    try
                    {
                        // Mã hóa mật khẩu
                        string hashedPassword = HashPassword(model.MatKhau);

                        // Tạo tài khoản mới
                        TaiKhoan account = new TaiKhoan
                        {
                            MaTaiKhoan = model.MaTaiKhoan,
                            TenDangNhap = model.TenDangNhap,
                            MatKhau = hashedPassword, // Lưu mật khẩu đã được mã hóa
                            Email = model.Email,
                            Role = model.Role,
                            NgayTao = DateTime.Now, // Ngày tạo là hiện tại
                        };
                        db.TaiKhoans.Add(account);
                        db.SaveChanges();
                        return RedirectToAction("AccountList");
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("", "Không thể thêm tài khoản: " + ex.Message);
                    }
                }
            }
            return View(model);
        }

        [HttpGet]
        public ActionResult AccountList()
        {

                using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
                {
                    // Lấy tất cả tài khoản, không phân trang
                    var accounts = db.TaiKhoans.OrderBy(a => a.NgayTao).ToList();

                    // Trả về danh sách tài khoản
                    return View(accounts);
                }

        }

        public ActionResult Homestay()
        {
            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();

            var ListhomestayWithNhanVien = (from homestay in db.Homestays
                                            join nhanVien in db.NhanViens
                                            on homestay.MaNhanVienTruc equals nhanVien.MaNhanVien
                                            select new HomestayViewModels
                                            {
                                                MaHomestay = homestay.MaHomestay,
                                                TenHomestay = homestay.TenHomestay,
                                                DiaChi = homestay.DiaChi,
                                                GiaThue = homestay.GiaThue,
                                                SoLuongKhach = homestay.SoLuongKhach,
                                                TrangThai = homestay.TrangThai,
                                                NhanVienTen = nhanVien.TenNhanVien
                                            }).ToList();

            return View(ListhomestayWithNhanVien);
        }
        [HttpGet]
        public ActionResult CreateHomestay()
        {
            using(QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Danh sách khu vực
                ViewBag.KhuVucList = db.KhuVucs.Select(k => new SelectListItem
                {
                    Value = k.MaKhuVuc,
                    Text = k.TenKhuVuc
                }).ToList();

                // Tài khoản chưa được sử dụng
                ViewBag.AvailableAccounts = db.TaiKhoans
                    .Where(t => !db.NhanViens.Any(nv => nv.MaTaiKhoan == t.MaTaiKhoan))
                    .Select(t => new SelectListItem
                    {
                        Value = t.MaTaiKhoan,
                        Text = t.TenDangNhap
                    }).ToList();

                return View();
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateHomestay(Homestay model, HttpPostedFileBase anhChinh, HttpPostedFileBase[] anhPhu)
        {
            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();
            if (ModelState.IsValid)
            {
                try
                {
                    // Generate unique MaHomestay
                    string newId = GenerateHomestayId();

                    // Upload ảnh chính
                    string anhChinhPath = null;
                    if (anhChinh != null && anhChinh.ContentLength > 0)
                    {
                        string fileName = Path.GetFileName(anhChinh.FileName);
                        anhChinhPath = Path.Combine(Server.MapPath("~/img"), fileName);
                        anhChinh.SaveAs(anhChinhPath);
                        anhChinhPath = "~/img/" + fileName;
                    }

                    // Upload ảnh phụ
                    string[] anhPhuPaths = new string[4];
                    for (int i = 0; i < Math.Min(4, anhPhu?.Length ?? 0); i++)
                    {
                        if (anhPhu[i] != null && anhPhu[i].ContentLength > 0)
                        {
                            string fileName = Path.GetFileName(anhPhu[i].FileName);
                            string filePath = Path.Combine(Server.MapPath("~/img"), fileName);
                            anhPhu[i].SaveAs(filePath);
                            anhPhuPaths[i] = "~/img/" + fileName;
                        }
                    }

                    // Tạo bản ghi AnhHomestay
                    var anhHomestay = new AnhHomestay
                    {
                        MaAnh = GenerateAnhId(),
                        AnhChinh = anhChinhPath,
                        AnhPhu1 = anhPhuPaths[0],
                        AnhPhu2 = anhPhuPaths[1],
                        AnhPhu3 = anhPhuPaths[2],
                        AnhPhu4 = anhPhuPaths[3]
                    };
                    db.AnhHomestays.Add(anhHomestay);
                    db.SaveChanges();

                    // Tạo bản ghi Homestay
                    var homestay = new Homestay
                    {
                        MaHomestay = newId,
                        TenHomestay = model.TenHomestay,
                        MaKhuVuc = Request.Form["MaKhuVuc"], // Lấy từ dropdown
                        MaAnh = anhHomestay.MaAnh,
                        DiaChi = model.DiaChi,
                        MoTa = model.MoTa,
                        GiaThue = model.GiaThue,
                        SoLuongKhach = model.SoLuongKhach,
                        DienTich = model.DienTich,
                        TienNghi = model.TienNghi,
                        NgayXayDung = model.NgayXayDung,
                        MaNhanVienTruc = null, // Để null
                        TrangThai = model.TrangThai,
                        DiemTrungBinh = model.DiemTrungBinh
                    };
                    db.Homestays.Add(homestay);
                    db.SaveChanges();

                    return RedirectToAction("Homestay", "Admin_Page");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Error creating homestay: " + ex.Message);
                }
            }

            // Load lại danh sách dropdown khi có lỗi
            var regions = db.KhuVucs.Select(k => new SelectListItem
            {
                Value = k.MaKhuVuc.ToString(), // Mã khu vực là value
                Text = k.TenKhuVuc             // Tên khu vực là text hiển thị
            }).ToList();
            ViewBag.Regions = regions;

            return View(model);
        }


        // Generate Homestay ID (SHXXXXX)
        private string GenerateHomestayId()
        {
            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();
            string id;
            Random random = new Random();
            do
            {
                id = "SH" + random.Next(10000, 99999).ToString();
            } while (db.Homestays.Any(h => h.MaHomestay == id));
            return id;
        }

        // Generate Anh ID
        private string GenerateAnhId()
        {
            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();
            string id;
            Random random = new Random();
            do
            {
                id = "MA" + random.Next(100, 9999).ToString();
            } while (db.AnhHomestays.Any(a => a.MaAnh == id));
            return id;
        }

        private string GenerateAccountId()
        {
            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();
            string id;
            Random random = new Random();
            do
            {
                id = "TK" + random.Next(50,1000).ToString();
            } while (db.Homestays.Any(h => h.MaHomestay == id));
            return id;
        }

        [HttpGet]
        public ActionResult Employee()
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Lấy danh sách nhân viên với khu vực và homestay
                var query = (from homestay in db.Homestays
                             join khuvuc in db.KhuVucs on homestay.MaKhuVuc equals khuvuc.MaKhuVuc
                             join nv in db.NhanViens on homestay.MaNhanVienTruc equals nv.MaNhanVien
                             select new EmployeeViewModel
                             {
                                 MaNV = nv.MaNhanVien,
                                 TenNV = nv.TenNhanVien,
                                 SDT = nv.SDT_NV,
                                 DiaChi = nv.DiaChiNV,
                                 KhuVuc = khuvuc.TenKhuVuc,
                                 HomestayCT = homestay.TenHomestay
                             }).ToList();

                return View(query);  // Re-render the view with the updated list
            }
        }

        [HttpGet]
        public ActionResult CreateEmployee()
        {
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                // Danh sách khu vực
                ViewBag.KhuVucList = db.KhuVucs.Select(k => new SelectListItem
                {
                    Value = k.MaKhuVuc,
                    Text = k.TenKhuVuc
                }).ToList();

                // Tài khoản chưa được sử dụng
                ViewBag.AvailableAccounts = db.TaiKhoans
                    .Where(t => !db.NhanViens.Any(nv => nv.MaTaiKhoan == t.MaTaiKhoan))
                    .Select(t => new SelectListItem
                    {
                        Value = t.MaTaiKhoan,
                        Text = t.TenDangNhap
                    }).ToList();

                return View();
            }
        }

        [HttpPost]
        public ActionResult CreateEmployee(EmployeeViewModel model)
        {
            string newId = GenerateHomestayId();
            if (ModelState.IsValid)
            {
                using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
                {
                    try
                    {
                        // Thêm nhân viên mới
                        NhanVien nv = new NhanVien
                        {
                            MaNhanVien = newId,
                            TenNhanVien = model.TenNV,
                            DiaChiNV = model.DiaChi,
                            SDT_NV = model.SDT,
                            CCCD = model.CCCD,
                            ChucVu = "Nhân viên trực",
                            MaKhuVuc = model.KhuVuc
                        };

                        // Thêm nhân viên vào cơ sở dữ liệu
                        db.NhanViens.Add(nv);
                        db.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("", "Không thể lưu dữ liệu: " + ex.Message);
                    }
                }

                // Sau khi thêm nhân viên mới, chuyển hướng lại trang danh sách nhân viên
                return RedirectToAction("Employee");
            }

            // Nếu có lỗi, load lại danh sách khu vực và tài khoản
            using (QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities())
            {
                ViewBag.KhuVucList = db.KhuVucs.Select(k => new SelectListItem
                {
                    Value = k.MaKhuVuc,
                    Text = k.TenKhuVuc
                }).ToList();

                ViewBag.AvailableAccounts = db.TaiKhoans
                   .Where(t => !db.NhanViens.Any(nv => nv.MaTaiKhoan == t.MaTaiKhoan))
                   .Select(t => new SelectListItem
                   {
                       Value = t.MaTaiKhoan,
                       Text = t.TenDangNhap
                   }).ToList();
            }

            return View(model);
        }


        public ActionResult Customer()
        {

            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();

            var Customer = (from KhachHang in db.KhachHangs               
                           select new CustomerViewModels
                           {
                             MaKH = KhachHang.MaKhachHang,
                             TenKhachHang = KhachHang.TenKhachHang,
                             SDT = KhachHang.SDT,
                             Email = KhachHang.Email,
                             DiaChi = KhachHang.DiaChiKH
                           }).ToList();

            return View(Customer);
           
        }

        public ActionResult Maintaince()
        {

            QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();

            var Maintance = (from BaoDuong in db.BaoDuongs
                             join Homestay in db.Homestays
                             on BaoDuong.MaHomestay equals Homestay.MaHomestay
                             select new MaintanceViewModels
                             {
                                 MaBaoDuong = BaoDuong.MaBaoDuong,
                                 TenHomestay = Homestay.TenHomestay,
                                 ChiPhi = BaoDuong.ChiPhi,
                                 NgayBaoDuong = BaoDuong.NgayBaoDuong,
                                 NgayHoanThanh = BaoDuong.NgayHoanThanh,
                                 TrangThai = BaoDuong.TrangThai
                             }).ToList();

            return View(Maintance);

        }


    }

}