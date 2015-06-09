using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Internet_Apteka
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void NavigationMenu_MenuItemClick(object sender, MenuEventArgs e)
        {

        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("ChangePassword.aspx");

        }

        protected void HeadLoginView_ViewChanged(object sender, EventArgs e)
        {

        }
    }
}
