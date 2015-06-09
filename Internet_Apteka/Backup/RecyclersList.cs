using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Internet_Apteka
{
    public partial class Internet_Apteka
    {
        public partial class
        RecyclerRow
        {
            public static List<Internet_Apteka.RecyclerRow> GetRecyclers()
            {
                return Korzina.Instance.ListRecyclers;
            }

            public static void DelTovarFromRecycler(Internet_Apteka.RecyclerRow Row)
            {
                int index = Korzina.Instance.ListRecyclers.FindIndex(r => r.id_tovar == Row.id_tovar);
                Korzina.Instance.ListRecyclers.RemoveAt(index);
            }

            public static void DelTovarFromRecycler(int index)
            {
                Korzina.Instance.ListRecyclers.RemoveAt(index);
            }
        }
    }
}