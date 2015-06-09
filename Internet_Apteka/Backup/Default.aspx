<%@ Page Title="Домашняя страница" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Internet_Apteka._Default" ValidateRequest="false" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <p>
        Выберите категорию товара =&gt; 
        Укажите количество =&gt; Нажмите &quot;Добавить
        в корзину&quot; =&gt; Перейдите в корзину и совершите покупку. Удачи :-)</p>
    <div>
        <div class="HeadRight" align="right">
            <asp:LoginView ID="LoginView1" runat="server">
                <AnonymousTemplate>
                </AnonymousTemplate>
                <LoggedInTemplate>
                    <asp:Button ID="MyKorzina" runat="server" Height="45px" OnClick="MyKorzina_Click"
                        Text="Моя корзина" Width="100px" />
                    <br />
                    <br />
                        <asp:Button ID="MyKabinet" runat="server" Height="45px" OnClick="MyKabinet_Click"
                        Text="Мой кабинет" Width="100px" />
                    <br />
                </LoggedInTemplate>
                <RoleGroups>
                    <asp:RoleGroup Roles="adminka,mods">
                        <ContentTemplate>
                            <asp:Button ID="AdminButton" runat="server" Height="45px" OnClick="AdminButton_Click"
                                Text="Админка" Width="100px" />
                        </ContentTemplate>
                    </asp:RoleGroup>
                </RoleGroups>
            </asp:LoginView>
            <br />
        </div>
        <div>
            <p>
                Группы препаратов:
            </p>
            <asp:Label ID="LabelError1" runat="server" Text="Label" Font-Size="Medium" 
                ForeColor="Red" Visible="False"></asp:Label>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="SELECT * FROM [Groups_Tovar]" DeleteCommand="DELETE FROM [Groups_Tovar] WHERE [id_groups] = @id_groups"
                InsertCommand="INSERT INTO [Groups_Tovar] ([name_groups]) VALUES (@name_groups)"
                UpdateCommand="UPDATE [Groups_Tovar] SET [name_groups] = @name_groups WHERE [id_groups] = @id_groups">
                <DeleteParameters>
                    <asp:Parameter Name="id_groups" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="name_groups" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="name_groups" Type="String" />
                    <asp:Parameter Name="id_groups" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView1" runat="server" AllowSorting="True" DataSourceID="SqlDataSource1"
                AutoGenerateColumns="False" DataKeyNames="id_groups" 
                OnRowDeleted="GridView_1and2_RowDeleted" 
                onrowupdating="GridView1_RowUpdating" AllowPaging="True">
                <Columns>
                    <asp:CommandField ShowSelectButton="True" />
                    <asp:CommandField ShowEditButton="True" />
                    <asp:CommandField ShowDeleteButton="True" />
                    <asp:BoundField DataField="id_groups" HeaderText="№ Группы" 
                        InsertVisible="False" ReadOnly="True"
                        SortExpression="id_groups" />
                    <asp:BoundField DataField="name_groups" HeaderText="Категория" SortExpression="name_groups" />
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
                Имеющиеся в наличии лекарства:
            </p>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                SelectCommand="SELECT * FROM [Goods] WHERE ([id_group] = @id_group)" DeleteCommand="DELETE FROM [Goods] WHERE [id_tovar] = @id_tovar"
                InsertCommand="INSERT INTO [Goods] ([tovar_name], [cost], [id_group], [opisanie]) VALUES (@tovar_name, @cost, @id_group, @opisanie)"
                
                UpdateCommand="UPDATE [Goods] SET [tovar_name] = @tovar_name, [cost] = @cost, [opisanie] = @opisanie WHERE [id_tovar] = @id_tovar">
                <DeleteParameters>
                    <asp:Parameter Name="id_tovar" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="tovar_name" Type="String" />
                    <asp:Parameter Name="cost" Type="Double" />
                    <asp:Parameter Name="id_group" Type="Int32" />
                    <asp:Parameter Name="opisanie" Type="String" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="id_group" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="tovar_name" Type="String" />
                    <asp:Parameter Name="cost" Type="Double" />
                    <asp:Parameter Name="opisanie" Type="String" />
                    <asp:Parameter Name="id_tovar" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:GridView ID="GridView2" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px"
                CellPadding="3" DataKeyNames="id_tovar" DataSourceID="SqlDataSource2" GridLines="Vertical"
                Height="98px" OnSelectedIndexChanged="AddKorzina_Click" 
                onrowupdating="GridView2_RowUpdating" AllowPaging="True">
                <AlternatingRowStyle BackColor="#DCDCDC" />
                <Columns>
                    <asp:CommandField ShowSelectButton="True" SelectText="Добавить в корзину" />
                    <asp:CommandField ShowEditButton="True" />
                    <asp:CommandField ShowDeleteButton="True" />
                    <asp:BoundField DataField="id_group" HeaderText="№ Кат." 
                        SortExpression="id_group" ReadOnly="True" />
                    <asp:BoundField DataField="id_tovar" HeaderText="№ Тов." InsertVisible="False" ReadOnly="True"
                        SortExpression="id_tovar" />
                    <asp:BoundField DataField="tovar_name" HeaderText="Наименование" SortExpression="tovar_name" />
                    <asp:BoundField DataField="cost" HeaderText="Цена, руб." SortExpression="cost" />
                    <asp:BoundField DataField="opisanie" HeaderText="Описание" SortExpression="opisanie" />
                    <asp:TemplateField HeaderText="Кол-во">
                        <ItemTemplate>
                            <asp:TextBox ID="KolVoTovarDDList" runat="server">1</asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
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
        <asp:LoginView ID="LoginView2" runat="server">
            <AnonymousTemplate>
            </AnonymousTemplate>
            <RoleGroups>
                <asp:RoleGroup Roles="adminka,mods">
                    <ContentTemplate>
                        <div>
                            <strong>Добавление группы:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                Наименование товара:</strong><br />
                            <em>Категория&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp; &nbsp; Название&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; Цена&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                Описание</em></div>
                        <asp:TextBox ID="TextBoxGroup" runat="server" Width="140px"></asp:TextBox>
                        &nbsp;
                        <asp:Button ID="AddNewGroup" runat="server" Text="Доб. кат." OnClick="AddNewGroup_Click" />
                        &nbsp;
                        <asp:TextBox ID="TovarTB1" runat="server"></asp:TextBox>
                        &nbsp;
                        <asp:TextBox ID="TovarTB2" runat="server"></asp:TextBox>
                        &nbsp;
                        <asp:TextBox ID="TovarTB3" runat="server"></asp:TextBox>
                        &nbsp;
                        <asp:Button ID="AddNewTovar" runat="server" Text="Доб. тов." OnClick="AddNewTovar_Click" />
                        &nbsp;
                    </ContentTemplate>
                </asp:RoleGroup>
            </RoleGroups>
        </asp:LoginView>
    </div>
</asp:Content>
