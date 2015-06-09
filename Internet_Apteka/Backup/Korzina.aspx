<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Korzina.aspx.cs" Inherits="Internet_Apteka.Korzina" EnableSessionState="True" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        Проверьте правильной заполнения корзины и совершите покупку. Удачи :-)</p>
    <div>
        <div class="HeadRight" align="right">
            <asp:Button ID="BuyAllTovar" runat="server" Height="45px" OnClick="BuyAllTovar_Click"
                Text="Купить всё" Width="100px" Enabled="False" />
            <br />
            <br />
            <asp:Button ID="DelAllTovar" runat="server" Height="45px" OnClick="DelAllTovar_Click"
                Text="Очистить всё" Width="100px" />
            <br />
            <br />
            <asp:Label ID="Label5" runat="server" Text="Способ оплаты:"></asp:Label>
            <asp:DropDownList ID="DropDownList1" runat="server">
                <asp:ListItem Value="Наличные"></asp:ListItem>
                <asp:ListItem Value="Webmoney"></asp:ListItem>
            </asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="Label6" runat="server" Text="Способ доставки:"></asp:Label>
            <asp:DropDownList ID="DropDownList2" runat="server" AutoPostBack="True">
                <asp:ListItem Value="Почта РФ"></asp:ListItem>
                <asp:ListItem Value="Курьер"></asp:ListItem>
            </asp:DropDownList>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            DeleteCommand="DELETE FROM [Recycler] WHERE [id_recycler] = @id_recycler" InsertCommand="INSERT INTO [Recycler] ([id_tovar], [user_id], [status], [id_order]) VALUES (@id_tovar, @user_id, @status, @id_order)"
            SelectCommand="SELECT Recycler.id_recycler, Recycler.status, Goods.tovar_name, Goods.cost, Groups_Tovar.name_groups FROM Recycler INNER JOIN Goods ON Recycler.id_tovar = Goods.id_tovar INNER JOIN Groups_Tovar ON Goods.id_group = Groups_Tovar.id_groups"
            UpdateCommand="UPDATE [Recycler] SET [id_tovar] = @id_tovar, [user_id] = @user_id, [status] = @status, [id_order] = @id_order WHERE [id_recycler] = @id_recycler">
            <DeleteParameters>
                <asp:Parameter Name="id_recycler" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="id_tovar" Type="Int32" />
                <asp:Parameter Name="user_id" Type="Object" />
                <asp:Parameter Name="status" Type="String" />
                <asp:Parameter Name="id_order" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="id_tovar" Type="Int32" />
                <asp:Parameter Name="user_id" Type="Object" />
                <asp:Parameter Name="status" Type="String" />
                <asp:Parameter Name="id_order" Type="Int32" />
                <asp:Parameter Name="id_recycler" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetRecyclers"
            TypeName="Internet_Apteka.Internet_Apteka+RecyclerRow" OldValuesParameterFormatString="original_{0}">
        </asp:ObjectDataSource>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ObjectDataSource1"
            OnSelectedIndexChanged="DelTovarFromRecycler">
            <Columns>
                <asp:CommandField SelectText="Удалить" ShowSelectButton="True" />
                <asp:TemplateField HeaderText="Товар" SortExpression="id_tovar">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("id_tovar") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Server.HtmlEncode(GetTovarName((int)(Eval("id_tovar")))) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Цена">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# GetCost((int)(Eval("id_tovar"))) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Кол-во">
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# (int)Eval("kol_vo_tovar") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Сумма">
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# GetCost((int)(Eval("id_tovar")))*(int)Eval("kol_vo_tovar") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <asp:Label ID="LabelSumma" runat="server" Text="Общая сумма заказа ="
            Visible="False"></asp:Label>
        <br />
        <asp:Label ID="LabelGoodBuy" runat="server" Text="Покупка успешно совершена!" 
            Visible="False" Font-Names="Monotype Corsiva" Font-Size="X-Large" 
            ForeColor="Red"></asp:Label>
    </div>
</asp:Content>
