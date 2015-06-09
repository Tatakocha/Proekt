using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Internet_Apteka.Account
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ChangePasswordPushButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("ChangePasswordSuccess.aspx");
        }
    }
}
