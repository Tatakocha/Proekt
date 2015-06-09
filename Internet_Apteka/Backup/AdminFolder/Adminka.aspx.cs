using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace Internet_Apteka
{
    public partial class Adminka : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string GetUserNameByUserId(Guid userId)
        {
            return Membership.GetUser(userId).UserName;
        }
    }
}