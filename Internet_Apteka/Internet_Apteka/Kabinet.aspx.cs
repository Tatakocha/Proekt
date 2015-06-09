using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace Internet_Apteka
{
    public partial class Kabinet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["CurrentUserId"] = GetCurrentUserId();
        }

        public string GetUserNameByUserId(Guid userId)
        {
            return Membership.GetUser(userId).UserName;
        }

        public Guid GetCurrentUserId()
        {
            return (Guid)Membership.GetUser(User.Identity.Name).ProviderUserKey;
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Label3.Text = "Список товаров";
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("ChangePassword.aspx");
        }
    }
}