<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Giris.aspx.cs" Inherits="BakimYonetimSistemi.Giris" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Giriş Yap</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 350px; margin: 100px auto; padding: 25px; border: 1px solid #ddd; border-radius: 8px; font-family: Arial, sans-serif; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); background-color: #f9f9f9;">
            <h2 style="text-align: center; color: #333; margin-bottom: 5px;">Bakım Yönetimi</h2>
            <p style="text-align: center; color: #777; margin-top: 0; font-size: 14px;">Kullanıcı Girişi</p>
            <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;" />
            
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 14px; color: #555;">Kullanıcı Adı:</label>
                <asp:TextBox ID="txtKullanici" runat="server" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"></asp:TextBox>
            </div>
            
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 5px; font-weight: bold; font-size: 14px; color: #555;">Şifre:</label>
                <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"></asp:TextBox>
            </div>
            
            <div>
                <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" OnClick="btnGiris_Click" style="width: 100%; padding: 11px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold;" />
            </div>
            
            <div style="margin-top: 15px; text-align: center;">
                <asp:Label ID="lblHata" runat="server" ForeColor="Red" Font-Bold="true" font-size="14px"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>