<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KullaniciListesi.aspx.cs" Inherits="BakimYonetimSistemi.KullaniciListesi" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title> Kullanıcı Listesi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />

    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #334155;
        }

        .card-custom {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            padding: 28px;
            margin: 40px auto;
            max-width: 900px;
        }

        .header-title {
            color: #0f172a;
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 24px;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .table-custom {
            width: 100%;
            border-collapse: collapse;
        }

        .table-custom th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 700;
            font-size: 13px;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 2px solid #e2e8f0;
        }

        .table-custom td {
            padding: 12px 16px;
            font-size: 14px;
            border-bottom: 1px solid #e2e8f0;
            color: #1e293b;
        }

        /* Rol Etiketi Stilleri */
        .badge-admin {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fca5a5;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 12px;
            display: inline-block;
        }

        .badge-kullanici {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #86efac;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 12px;
            display: inline-block;
        }
        .btn-guncelle-link {
            background-color: #0284c7;
            color: white !important;
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-guncelle-link:hover { background-color: #0369a1; }

        .custom-modal-overlay {
            display: none; position: fixed; z-index: 99999; 
            left: 0; top: 0; width: 100%; height: 100%; 
            background-color: rgba(15, 23, 42, 0.75); backdrop-filter: blur(4px);
            align-items: center; justify-content: center;
        }

        .custom-modal-content {
            background-color: #ffffff; width: 90%; max-width: 520px;
            border-radius: 12px; padding: 24px; box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }

        .custom-modal-header {
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 20px;
        }

        .close-btn { font-size: 24px; font-weight: bold; color: #64748b; cursor: pointer; }
        .close-btn:hover { color: #dc2626; }
        .form-row { display: flex; gap: 12px; margin-bottom: 12px; }
        .form-group { flex: 1; display: flex; flex-direction: column; gap: 4px; margin-bottom: 12px; }
        .form-group.full { width: 100%; }
        .form-group label { font-size: 12px; font-weight: 700; color: #475569; }
        .modal-input { width: 100%; padding: 8px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; }
        .modal-btn-kaydet { width: 100%; background-color: #0d9488; color: white; border: none; padding: 10px; font-weight: 700; border-radius: 6px; cursor: pointer; margin-top: 10px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card-custom">
            <h2 class="header-title">
                <i class="fa-solid fa-users text-danger"></i>
                Kullanıcı Listesi
            </h2>

            <asp:GridView ID="gvKullanicilar" runat="server" AutoGenerateColumns="False" CssClass="table-custom" GridLines="None" EmptyDataText="Sistemde aktif kullanıcı bulunamadı.">
                <Columns>
                    <asp:BoundField DataField="KULLANICI_ADI" HeaderText="Kullanıcı Adı" />
                    <asp:BoundField DataField="ADI" HeaderText="Adı" />
                    <asp:BoundField DataField="SOYADI" HeaderText="Soyadı" />
                    
                    <%-- ROLÜ ADMİN İSE KIRMIZI, KULLANICI İSE YEŞİL ETİKET GÖSTERİR --%>
                    <asp:TemplateField HeaderText="Yetki / Rol">
                        <ItemTemplate>
                            <span class='<%# Eval("ROL_ADI").ToString() == "Admin" ? "badge-admin" : "badge-kullanici" %>'>
                                <%# Eval("ROL_ADI") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                  
                    <%-- GÜNCELLE BUTONU KOLONU --%>
                    <asp:TemplateField HeaderText="İşlemler">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnGuncelle" runat="server" CssClass="btn-guncelle-link" 
                                CommandArgument='<%# Eval("KULLANICI_ADI") %>' OnClick="btnGuncelle_Click" OnClientClick="openModal();">
                                <i class="fa-solid fa-pen-to-square"></i> Güncelle
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <!-- KULLANICI GÜNCELLEME MODAL PENCERESİ -->
       <!-- KULLANICI GÜNCELLEME POP-UP PENCERESİ -->
<div id="guncelleModal" style="display:none; position:fixed; z-index:99999; left:0; top:0; width:100%; height:100%; background:rgba(15,23,42,0.75); align-items:center; justify-content:center;">
    <div style="background:#fff; width:90%; max-width:500px; border-radius:12px; padding:24px; box-shadow:0 10px 25px rgba(0,0,0,0.3);">
        <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #e2e8f0; padding-bottom:10px; margin-bottom:15px;">
            <h4 style="margin:0; font-weight:bold; color:#0f172a;"><i class="fa-solid fa-user-pen text-danger"></i> Kullanıcı Güncelle</h4>
            <span style="font-size:24px; cursor:pointer; color:#64748b;" onclick="closeModal()">&times;</span>
        </div>
        <div>
            <div style="display:flex; gap:10px; margin-bottom:10px;">
                <div style="flex:1;"><label style="font-size:12px; font-weight:bold;">Adı</label><asp:TextBox ID="txtAdi" runat="server" CssClass="form-control"></asp:TextBox></div>
                <div style="flex:1;"><label style="font-size:12px; font-weight:bold;">Soyadı</label><asp:TextBox ID="txtSoyadi" runat="server" CssClass="form-control"></asp:TextBox></div>
            </div>
            <div style="margin-bottom:10px;"><label style="font-size:12px; font-weight:bold;">TC Kimlik No</label><asp:TextBox ID="txtTc" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox></div>
            <div style="display:flex; gap:10px; margin-bottom:10px;">
                <div style="flex:1;"><label style="font-size:12px; font-weight:bold;">Kullanıcı Adı</label><asp:TextBox ID="txtKullaniciAdi" runat="server" CssClass="form-control" ReadOnly="true" Style="background:#f1f5f9;"></asp:TextBox></div>
                <div style="flex:1;"><label style="font-size:12px; font-weight:bold;">Şifre</label><asp:TextBox ID="txtSifre" runat="server" CssClass="form-control"></asp:TextBox></div>
            </div>
            <div style="margin-bottom:15px;"><label style="font-size:12px; font-weight:bold;">Kullanıcı Rolü</label>
                <asp:DropDownList ID="ddlAdminMi" runat="server" CssClass="form-control">
                    <asp:ListItem Value="0">Kullanıcı</asp:ListItem>
                    <asp:ListItem Value="1">Admin</asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="btnKaydet" runat="server" Text="GÜNCELLE" CssClass="btn btn-success w-100" OnClick="btnKaydet_Click" />
        </div>
    </div>
</div>

<script type="text/javascript">
    function openModal() { document.getElementById('guncelleModal').style.display = 'flex'; }
    function closeModal() { document.getElementById('guncelleModal').style.display = 'none'; }
</script>
    </form>
    <script type="text/javascript">
function openModal() {
    document.getElementById('guncelleModal').style.display = 'flex';
}
function closeModal() {
    document.getElementById('guncelleModal').style.display = 'none';
}
window.onclick = function(event) {
    var modal = document.getElementById('guncelleModal');
    if (event.target == modal) { closeModal(); }
        }
    </script>
</body>
</html>