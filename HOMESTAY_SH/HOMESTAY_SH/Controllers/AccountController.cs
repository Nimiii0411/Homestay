using HOMESTAY_SH.Database_ADO;
using SWEET_HOME.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;


public class AccountController : Controller
{
    private readonly QLH_SWEETHOMEEntities db = new QLH_SWEETHOMEEntities();
    [HttpGet]
    public ActionResult Register()
    {
        return View();
    }
    // Registration GET
    // Registration POST
    [HttpPost]
    public ActionResult Register(RegisterModels model)
    {
        if (ModelState.IsValid)
        {
            // Check if username or email already exists
            if (db.TaiKhoans.Any(t => t.TenDangNhap == model.Username || t.Email == model.Email))
            {
                ModelState.AddModelError("", "Username or Email already exists.");
                return View(model);
            }

            // Generate new MaTaiKhoan
            string newId = GenerateMaTaiKhoan();
            string newIdKh = GenerateMaKhachHang();
            // Create new TaiKhoan
            var newAccount = new TaiKhoan
            {
                MaTaiKhoan = newId,
                TenDangNhap = model.Username,
                MatKhau = model.Password,  // Don't hash the password
                Email = model.Email,
                Role = "Khách hàng",
                NgayTao = DateTime.Now
            };

            var NewKhachHang = new KhachHang
            {
                MaKhachHang = newIdKh,
                TenKhachHang = model.Username,
                Email = model.Email,
                CCCD = model.CCCD,
                DiaChiKH = model.DiaChi,
                MaTaiKhoan = newId
            };

            // Save to database
            db.TaiKhoans.Add(newAccount);
            db.KhachHangs.Add(NewKhachHang);
            db.SaveChanges();

            return RedirectToAction("Login", "Account");
        }

        return View(model);
    }



    private string GenerateMaTaiKhoan()
    {

        // Format the new ID as "TKxxxx"
        string maTaiKhoan = "TK" + new Random().Next(30, 1000).ToString();
        return maTaiKhoan;
    }

    private string GenerateMaKhachHang()
    {

        // Format the new ID as "TKxxxx"
        string makh = "KH" + new Random().Next(30, 1000).ToString();
        return makh;
    }
    // Hash password using SHA256
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
    [HttpGet]
    public ActionResult Login()
    {
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public ActionResult Login(LoginModel model)
    {
        if (ModelState.IsValid)
        {
            using (var db = new QLH_SWEETHOMEEntities())
            {
                var user = db.TaiKhoans
                    .FirstOrDefault(u => u.TenDangNhap.ToLower() == model.Username.ToLower());

                if (user == null)
                {
                    ModelState.AddModelError("", "Tên đăng nhập không tồn tại.");
                    return View(model);
                }

                if (user.MatKhau != model.Password)
                {
                    ModelState.AddModelError("", "Mật khẩu không chính xác.");
                    return View(model);
                }

                // Lưu thông tin tài khoản
                Session["MaTaiKhoan"] = user.MaTaiKhoan;
                Session["TenDangNhap"] = user.TenDangNhap;
                Session["Role"] = user.Role;


                // Nếu là khách hàng, lấy thông tin khách hàng
                if (user.Role == "Khách hàng")
                {
                    var khachHang = db.KhachHangs.Where(k => k.MaTaiKhoan == user.MaTaiKhoan)
   .FirstOrDefault();

                    if (khachHang != null)
                    {
                        Session["MaKhachHang"] = khachHang.MaKhachHang; // Lưu ID khách hàng
                    }
                }

                // Điều hướng mặc định
                return RedirectToAction("Index", "Home");
            }
        }

        return View(model);
    }

    public ActionResult Logout()
    {
        Session.Clear();
        return RedirectToAction("Login");
    }
}