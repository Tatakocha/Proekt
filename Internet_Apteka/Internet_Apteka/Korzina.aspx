<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Korzina.aspx.cs" Inherits="Internet_Apteka.Korzina" EnableSessionState="True" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        <asp:Label ID="Label7" runat="server" Font-Size="16pt" ForeColor="#000066" Height="55px" Width="445px">Перед совершением покупки проверьте правильность заполнения корзины</asp:Label>
</p>
    <asp:Panel ID="Panel1" runat="server" Height="40px" style="margin-left: 464px; margin-top: 0px" Width="135px">
        <asp:Image ID="Image3" runat="server" Height="29px" ImageUrl="~/Image/корзина.jpg" Width="47px" />
</asp:Panel>
    <div>
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
        <div class="HeadRight" align="right" style="font-size: 8px; padding-right: 2px;">
            <asp:Button ID="BuyAllTovar" runat="server" Height="34px" OnClick="BuyAllTovar_Click"
                Text="Подтвердить заказ" Width="100px" Enabled="False" Font-Size="8pt" />
            <br />
            <br />
            <asp:Button ID="DelAllTovar" runat="server" Height="34px" OnClick="DelAllTovar_Click"
                Text="Очистить корзину" Width="100px" Font-Size="8pt" />
            <br />
            <br />
            <asp:Label ID="Label5" runat="server" Text="Способ оплаты:" Width="106px" Font-Size="8pt" style="margin-top: 70px; margin-bottom: 0px"></asp:Label>
            <asp:DropDownList ID="DropDownList1" runat="server"  Width="117px" Height="16px" >
                <asp:ListItem Value="Наличные"></asp:ListItem>
                <asp:ListItem Value="Webmoney"></asp:ListItem>
            </asp:DropDownList>
            <br />
            <asp:Label ID="Label6" runat="server" Text="Способ доставки:" Width="112px" Font-Size="8pt"></asp:Label>
            <br />
            <asp:DropDownList ID="DropDownList2" runat="server" AutoPostBack="True" Width="120px" Height="16px">
                <asp:ListItem Value="Почта России"></asp:ListItem>
                <asp:ListItem Value="Курьер"></asp:ListItem>
            </asp:DropDownList>
        </div>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetRecyclers"
            TypeName="Internet_Apteka.Internet_Apteka+RecyclerRow" OldValuesParameterFormatString="original_{0}">
        </asp:ObjectDataSource>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ObjectDataSource1"
            OnSelectedIndexChanged="DelTovarFromRecycler" Width="719px">
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
