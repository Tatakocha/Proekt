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
using System.Web.SessionState;

namespace Internet_Apteka
{
    public partial class Korzina : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Instance = this;
            ConStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (Context != null && Context.Session != null)
            {
                if (Session["Recycler"] != null)
                {
                    this.ListRecyclers = (List<Internet_Apteka.RecyclerRow>)Session["Recycler"];

                    if (this.ListRecyclers.Count > 0)
                    {
                        BuyAllTovar.Enabled = true;
                        LabelSumma.Visible = true;
                    }
                }
            }
        }

        protected override void OnLoadComplete(EventArgs e)
        {
            base.OnLoadComplete(e);
            SummaVsexTovarov();
        }

        string ConStr = "";
        public List<Internet_Apteka.RecyclerRow> ListRecyclers;

        public string GetUserNameByUserId(Guid userId)
        {
            return Membership.GetUser(userId).UserName;
        }

        public Guid GetCurrentUserId()
        {
            return (Guid)Membership.GetUser(User.Identity.Name).ProviderUserKey;
        }

        protected void BuyAllTovar_Click(object sender, EventArgs e) // нужна проверка на юзера
        {
            SqlConnection Connect = new SqlConnection(ConStr);
            Connect.Open();
            SqlCommand Com = Connect.CreateCommand();

            Com.CommandText = "INSERT INTO Orders (order_date, user_id, summa_all, sposob_oplati, sposob_dostavki) VALUES (@OrderDate, @UserId, @SummaAll, @SposobOplati, @SposobDostavki)";

            Com.Parameters.Add("@OrderDate", SqlDbType.DateTime).Value = DateTime.Now;
            Com.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = GetCurrentUserId();
            Com.Parameters.Add("@SummaAll", SqlDbType.Float).Value = SummaVsexTovarov();
            Com.Parameters.Add("@SposobOplati", SqlDbType.NVarChar, 50).Value = DropDownList1.SelectedValue;
            Com.Parameters.Add("@SposobDostavki", SqlDbType.NVarChar, 50).Value = DropDownList2.SelectedValue;
            
            Com.ExecuteNonQuery();

            Com = Connect.CreateCommand();

            Com.CommandText = ("SELECT MAX(id_order) FROM Orders");

            var id_order_znachenie = Com.ExecuteScalar();

            Com = Connect.CreateCommand();

            Com.CommandText = "INSERT INTO Recycler (id_tovar, user_id, status, id_order, kol_vo_tovar, summa) VALUES (@IdTovar, @UserId, @Status, @IdOrder, @Kol_vo_Tovar, @Summa)";
            Com.Parameters.Add("@IdTovar", SqlDbType.Int);
            Com.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier);
            Com.Parameters.Add("@Status", SqlDbType.NVarChar, 50);
            Com.Parameters.Add("@IdOrder", SqlDbType.Int);
            Com.Parameters.Add("@Kol_vo_Tovar", SqlDbType.Int);
            Com.Parameters.Add("@Summa", SqlDbType.Float);

            var Com2 = Connect.CreateCommand();
            Com2.CommandText = "SELECT cost FROM Goods WHERE id_tovar = @id_tovar";
            Com2.Parameters.Add("@id_tovar", SqlDbType.Int);

            foreach (var item in ListRecyclers)
            {
                Com.Parameters["@IdTovar"].Value = item.id_tovar;
                Com.Parameters["@UserId"].Value = GetCurrentUserId();
                Com.Parameters["@Status"].Value = "Оплачено!";
                Com.Parameters["@IdOrder"].Value = id_order_znachenie;
                Com.Parameters["@Kol_vo_Tovar"].Value = item.kol_vo_tovar;

                Com2.Parameters["@id_tovar"].Value = item.id_tovar;
                float price = Convert.ToSingle(Com2.ExecuteScalar());

                Com.Parameters["@Summa"].Value = price * item.kol_vo_tovar;

                Com.ExecuteNonQuery();
                LabelSumma.Visible = false;
                LabelGoodBuy.Visible = true;
            }

            Connect.Close();
            BuyAllTovar.Enabled = false;
            ListRecyclers.Clear();
            GridView1.DataBind();
        }

        protected void DelAllTovar_Click(object sender, EventArgs e)
        {
            ListRecyclers.Clear();
            Response.Redirect("Korzina.aspx");
        }

        protected void DelTovarFromRecycler(object sender, EventArgs e)
        {
            Korzina.Instance.ListRecyclers.RemoveAt(GridView1.SelectedIndex);
            GridView1.DataBind();
        }

        public static Korzina Instance;

        public string GetTovarName(int id)
        {
            SqlConnection Connect = new SqlConnection(ConStr);
            Connect.Open();
            SqlCommand Com = Connect.CreateCommand();

            Com.CommandText = "SELECT (tovar_name) FROM Goods WHERE id_tovar = @IdTovar";

            Com.Parameters.Add("@IdTovar", SqlDbType.Int).Value = id;

            string Result = Convert.ToString(Com.ExecuteScalar());

            Connect.Close();

            return Result;
        }

        public float GetCost(int id)
        {
            SqlConnection Connect = new SqlConnection(ConStr);
            Connect.Open();
            SqlCommand Com = Connect.CreateCommand();

            Com.CommandText = "SELECT (cost) FROM Goods WHERE id_tovar = @IdTovar";

            Com.Parameters.Add("@IdTovar", SqlDbType.Int).Value = id;

            float Result = Convert.ToSingle(Com.ExecuteScalar());

            Connect.Close();

            return Result;
        }

        protected void DelTovarFromRecycler(int index)
        {
            Korzina.Instance.ListRecyclers.RemoveAt(index);
        }

        public float SummaVsexTovarov()
        {
            int a = ListRecyclers.Count;
            float Z = 0;
            int f = 0;
            for (int i = 0; i < a; i++)
            {
                int b = ListRecyclers[i].kol_vo_tovar;
                int c = ListRecyclers[i].id_tovar;
                float d = GetCost(c);
                Z += d * b;
            }

            if (DropDownList2.SelectedIndex == 0)
            {
                f = 50;
            }
            else f = 100;

            if (a == 0)
            {
                BuyAllTovar.Enabled = false;
                LabelSumma.Visible = false;
                return 0f;
            }

            float FinalSumma = Z + f;

            BuyAllTovar.Enabled = true;
            LabelSumma.Visible = true;
            LabelSumma.Text = "Общая сумма заказа = " + Z.ToString() + " + доставка = " + f.ToString() + ". Итого = " + FinalSumma.ToString() + " рублей";

            return FinalSumma;
        }

        public int recyclerRow { get; set; }
    }
}