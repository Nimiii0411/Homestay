using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SWEET_HOME.Models
{
    public class User
    {
        public string MaTK { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public DateTime NgayTao { get; set; }
    }

}