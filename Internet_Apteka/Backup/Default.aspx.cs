using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;

namespace Internet_Apteka
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Recycler"] == null)
            {
                ListRecyclers = new List<Internet_Apteka.RecyclerRow>();
                Session["Recycler"] = ListRecyclers;
            }
            else
            {
                ListRecyclers = (List<Internet_Apteka.RecyclerRow>)Session["Recycler"];
            }

            if (!User.IsInRole("adminka") && !User.IsInRole("mods"))
            {
                GridView1.Columns[1].Visible = false;
                GridView1.Columns[2].Visible = false;
                GridView1.Columns[3].Visible = false;

                GridView2.Columns[1].Visible = false;
                GridView2.Columns[2].Visible = false;
                GridView2.Columns[3].Visible = false;
            }

            if (User.IsInRole("adminka") || User.IsInRole("mods"))
            {
                GridView2.Columns[0].Visible = false;
            }
            if (User.Identity.IsAuthenticated == false)
            {
                GridView2.Columns[0].Visible = false;
            }
        }

        string ConStr = "";
        List<Internet_Apteka.RecyclerRow> ListRecyclers;

        protected void AddKorzina_Click(object sender, EventArgs e)
        {
            TextBox KolVoTovarDDList = (TextBox)GridView2.SelectedRow.FindControl("KolVoTovarDDList");

            var recyclerRow = (new Internet_Apteka()).Recycler.NewRecyclerRow();
            int idTovar = Convert.ToInt32(GridView2.SelectedRow.Cells[4].Text);
            recyclerRow.id_tovar = idTovar;            

            String strKolVo = KolVoTovarDDList.Text.ToString();
            float ayt;

            if (float.TryParse(strKolVo, out ayt))
            {
                int KolVoTovar = Convert.ToInt32(KolVoTovarDDList.Text);
                recyclerRow.kol_vo_tovar = KolVoTovar;

                int FindIndexxx = ListRecyclers.FindIndex(rr => rr.id_tovar == idTovar);

                if (FindIndexxx == -1)
                {
                    ListRecyclers.Add(recyclerRow);
                    LabelError1.Visible = false;
                }
                else
                {
                    LabelError1.Visible = true;
                    LabelError1.Text = "Этот товар уже в корзине!";
                    return;
                }
            }
            else
            {
                LabelError1.Visible = true;
                LabelError1.Text = "Введите верное кол-во товара";
                KolVoTovarDDList.Text = "1";
            }
        }

        public Guid GetCurrentUserId()
        {
            return (Guid)Membership.GetUser(User.Identity.Name).ProviderUserKey;
        }

        protected void MyKorzina_Click(object sender, EventArgs e)
        {
            Response.Redirect("Korzina.aspx");
        }

        protected void AdminButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminFolder/Adminka.aspx");
        }

        protected void GridView_1and2_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            GridView1.DataBind();
            GridView2.DataBind();
        }

        protected void AddNewGroup_Click(object sender, EventArgs e)
        {
            TextBox TextBoxGroup = (TextBox)LoginView2.FindControl("TextBoxGroup");

            if (String.IsNullOrWhiteSpace(TextBoxGroup.Text))
            {
                LabelError1.Visible = true;
                LabelError1.Text = "Ошибка в поле значения группы";
                return;
            }

            ConStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            SqlConnection Connect = new SqlConnection(ConStr);
            Connect.Open();
            SqlCommand Com = Connect.CreateCommand();

            Com.CommandText = "INSERT INTO Groups_Tovar (name_groups) VALUES (@NameGroups)";

            Com.Parameters.Add("@NameGroups", SqlDbType.NVarChar, 50).Value = Server.HtmlDecode(TextBoxGroup.Text);
            Com.ExecuteNonQuery();
            Connect.Close();

            GridView1.DataBind();
            TextBoxGroup.Text = "";
            LabelError1.Visible = false;
        }

        protected void AddNewTovar_Click(object sender, EventArgs e)
        {
            TextBox TovarTB1 = (TextBox)LoginView2.FindControl("TovarTB1");
            TextBox TovarTB2 = (TextBox)LoginView2.FindControl("TovarTB2");
            TextBox TovarTB3 = (TextBox)LoginView2.FindControl("TovarTB3");

            String strchenatov = TovarTB2.Text.ToString();
            float b;

            if (String.IsNullOrWhiteSpace(TovarTB1.Text) || String.IsNullOrWhiteSpace(TovarTB2.Text) || String.IsNullOrWhiteSpace(TovarTB3.Text) || GridView1.SelectedRow == null || !float.TryParse(strchenatov, out b))
            {
                LabelError1.Visible = true;
                LabelError1.Text = "Ошибка в полях значений товара";
                return;
            }

            ConStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            SqlConnection Connect = new SqlConnection(ConStr);
            Connect.Open();
            SqlCommand Com = Connect.CreateCommand();

            int ID = Convert.ToInt32(GridView1.SelectedRow.Cells[3].Text);

            Com.CommandText = "INSERT INTO Goods (tovar_name, cost, id_group, opisanie) VALUES (@TovarName, @Cost, @IdGroup, @Opisanie)";

            Com.Parameters.Add("@TovarName", SqlDbType.NVarChar, 100).Value = Server.HtmlDecode(TovarTB1.Text);
            Com.Parameters.Add("@Cost", SqlDbType.Float).Value = Server.HtmlDecode(TovarTB2.Text);
            Com.Parameters.Add("@IdGroup", SqlDbType.Int).Value = ID;
            Com.Parameters.Add("@Opisanie", SqlDbType.NVarChar, 200).Value = Server.HtmlDecode(TovarTB3.Text);

            Com.ExecuteNonQuery();
            Connect.Close();

            GridView2.DataBind();
            TovarTB1.Text = "";
            TovarTB2.Text = "";
            TovarTB3.Text = "";
            LabelError1.Visible = false;
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            String str0 = (string)e.NewValues[0];
            if (String.IsNullOrWhiteSpace(str0))
            {
                e.Cancel = true;
                LabelError1.Visible = true;
                LabelError1.Text = "Не верно введено название группы";
            }
            else
            {
                LabelError1.Visible = false;
            }
        }

        protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            String str1 = e.NewValues[1].ToString();
            String str0 = (string)e.NewValues[0];
            String str2 = (string)e.NewValues[2];
            float a;
            
            if (!float.TryParse(str1, out a) || String.IsNullOrWhiteSpace(str0) || String.IsNullOrWhiteSpace(str2))
            {
                e.Cancel = true;
                LabelError1.Visible = true;
                LabelError1.Text = "Не верно указанны поля товара";
            }
            else
            {
                LabelError1.Visible = false;
            }
        }

        protected void MyKabinet_Click(object sender, EventArgs e)
        {
            Response.Redirect("Kabinet.aspx");
        }
    }
}
