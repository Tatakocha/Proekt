<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Adminka.aspx.cs" Inherits="Internet_Apteka.Adminka" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        Данные о совершённых покупках. Аdmin :-)</p>
    <div>
        <div>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                DeleteCommand="DELETE FROM [Orders] WHERE [id_order] = @id_order" InsertCommand="INSERT INTO [Orders] ([order_date], [user_id]) VALUES (@order_date, @user_id)"
                SelectCommand="SELECT * FROM [Orders]" UpdateCommand="UPDATE [Orders] SET [order_date] = @order_date, [user_id] = @user_id WHERE [id_order] = @id_order">
                <DeleteParameters>
                    <asp:Parameter Name="id_order" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="order_date" Type="DateTime" />
                    <asp:Parameter Name="user_id" Type="Object" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="order_date" Type="DateTime" />
                    <asp:Parameter Name="user_id" Type="Object" />
                    <asp:Parameter Name="id_order" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id_order" 
                DataSourceID="SqlDataSource1" BackColor="White" BorderColor="White" 
                BorderStyle="Ridge" BorderWidth="2px" CellPadding="3" CellSpacing="1" 
                GridLines="None">
                <Columns>
                    <asp:CommandField ShowDeleteButton="True" ShowSelectButton="True" />
                    <asp:BoundField DataField="id_order" HeaderText="№ Покупки" 
                        InsertVisible="False" ReadOnly="True" SortExpression="id_order" />
                    <asp:BoundField DataField="order_date" HeaderText="Дата покупки" 
                        SortExpression="order_date" />
                    <asp:TemplateField HeaderText="Покупатель" SortExpression="user_id">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("user_id") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" 
                                Text='<%# GetUserNameByUserId((Guid)Eval("user_id")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="summa_all" HeaderText="Сумма покупки (руб)" 
                        SortExpression="summa_all" />
                    <asp:BoundField DataField="sposob_oplati" HeaderText="Способ оплаты" 
                        SortExpression="sposob_oplati" />
                    <asp:BoundField DataField="sposob_dostavki" HeaderText="Способ доставки" 
                        SortExpression="sposob_dostavki" />
                </Columns>
                <FooterStyle BackColor="#C6C3C6" ForeColor="Black" />
                <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#E7E7FF" />
                <PagerStyle BackColor="#C6C3C6" ForeColor="Black" HorizontalAlign="Right" />
                <RowStyle BackColor="#DEDFDE" ForeColor="Black" />
                <SelectedRowStyle BackColor="#9471DE" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#594B9C" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#33276A" />
            </asp:GridView>
            <p>
                Список купленных товаров:</p>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                
                SelectCommand="SELECT Recycler.id_recycler, Recycler.id_tovar, Recycler.status, Recycler.id_order, Goods.tovar_name, Goods.cost, Groups_Tovar.name_groups, Recycler.kol_vo_tovar, Recycler.summa FROM Recycler INNER JOIN Goods ON Recycler.id_tovar = Goods.id_tovar INNER JOIN Groups_Tovar ON Goods.id_group = Groups_Tovar.id_groups WHERE (Recycler.id_order = @id_order)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="id_order" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView2" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px"
                CellPadding="3" DataKeyNames="id_recycler" DataSourceID="SqlDataSource2" GridLines="Vertical">
                <AlternatingRowStyle BackColor="#DCDCDC" />
                <Columns>
                    <asp:BoundField DataField="id_recycler" HeaderText="№ корзины" SortExpression="id_recycler"
                        InsertVisible="False" ReadOnly="True" />
                    <asp:BoundField DataField="id_tovar" HeaderText="№ товара" SortExpression="id_tovar" />
                    <asp:BoundField DataField="id_order" HeaderText="№ покупки" 
                        SortExpression="id_order" />
                    <asp:BoundField DataField="tovar_name" HeaderText="Название товара" 
                        SortExpression="tovar_name" />
                    <asp:BoundField DataField="cost" HeaderText="Цена" SortExpression="cost" />
                    <asp:BoundField DataField="kol_vo_tovar" HeaderText="Кол-во" 
                        SortExpression="kol_vo_tovar" />
                    <asp:BoundField DataField="summa" HeaderText="Сумма" SortExpression="summa" />
                    <asp:BoundField DataField="name_groups" HeaderText="Название группы" 
                        SortExpression="name_groups" />
                    <asp:BoundField DataField="status" HeaderText="Статус" 
                        SortExpression="status" />
                </Columns>
                <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#0000A9" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#000065" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
