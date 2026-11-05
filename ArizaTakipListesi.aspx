<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArizaTakipListesi.aspx.cs" Inherits="BakimYonetimSistemi.ArizaTakipListesi" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title> Arıza Takip Listesi</title>
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
            padding: 24px;
            margin: 20px auto;
            max-width: 96%;
        }

        .header-title {
            color: #0f172a;
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* GRIDVIEW STİLLERİ */
        .table-custom {
            margin-top: 15px;
            border-radius: 8px;
            overflow: hidden;
        }

        .table-custom th {
            background-color: #f1f5f9 !important;
            color: #475569 !important;
            font-weight: 700;
            font-size: 13px;
            text-transform: uppercase;
            border-bottom: 2px solid #cbd5e1;
            padding: 12px 16px;
        }

        .table-custom td {
            font-size: 14px;
            padding: 12px 16px;
            vertical-align: middle;
        }

        .badge-acil {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 11px;
            border: 1px solid #fca5a5;
        }

        .badge-normal {
            background-color: #e0f2fe;
            color: #0369a1;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 11px;
            border: 1px solid #7dd3fc;
        }

        .btn-goster {
            background-color: #0d9488;
            color: white;
            font-weight: 600;
            font-size: 12px;
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            transition: all 0.2s;
        }

        .btn-goster:hover {
            background-color: #0f766e;
            color: white;
        }

        .btn-sil {
            background-color: #dc2626;
            color: white;
            font-weight: 600;
            font-size: 12px;
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            transition: all 0.2s;
        }

        .btn-sil:hover {
            background-color: #b91c1c;
            color: white;
        }
        /* GRIDVIEW SAYFALAMA (PAGER) STİLİ */
        .gridview-pager td {
            padding: 10px 4px !important;
        }

        .gridview-pager a, .gridview-pager span {
            padding: 6px 12px;
            margin: 0 2px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
        }

        .gridview-pager a {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .gridview-pager a:hover {
            background-color: #e2e8f0;
            color: #0f172a;
        }

        .gridview-pager span {
            background-color: #dc2626;
            color: white;
            border: 1px solid #dc2626;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card-custom">
            <!-- BAŞLIK & ARAMA BAR -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="header-title">
                    <i class="fa-solid fa-clipboard-list text-danger"></i>
                  Bekleyen Arıza Talepleri
                </h2>
                <div class="d-flex gap-2">
                    <asp:TextBox ID="txtAra" runat="server" CssClass="form-control form-control-sm" Placeholder="Talep No ile ara..." OnTextChanged="txtAra_TextChanged" AutoPostBack="true"></asp:TextBox>
                </div>
            </div>

            <!-- GRIDVIEW TABLOSU -->
            <div class="table-responsive">
                <asp:GridView ID="gvTalepler" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover table-custom" GridLines="None" 
                    EmptyDataText="Henüz kaydedilmiş bir arıza talebi bulunmamaktadır."
                    OnRowCommand="gvTalepler_RowCommand"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvTalepler_PageIndexChanging">
                    
                    <%-- Sayfalama Linklerinin Şık Durması İçin --%>
                    <PagerStyle CssClass="gridview-pager" HorizontalAlign="Center" />
                    <Columns>
                        <%-- (+) İŞ TALEBİ NO --%>
                        <asp:TemplateField HeaderText="Talep No">
                            <ItemTemplate>
                                <span class="fw-bold text-dark">#<%# Eval("IS_TALEP_NO") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- TALEP EDİLEN BİRİM --%>
                        <asp:BoundField DataField="Birim_adi" HeaderText="Talep Edilen Birim" />

                        <%-- EKİPMAN ADI --%>
                        <asp:BoundField DataField="Ekipman_adi" HeaderText="Ekipman Adı" NullDisplayText="-" />

                        <%-- (+) AÇIKLAMA --%>
                        <asp:TemplateField HeaderText="Açıklama">
                            <ItemTemplate>
                                <span title='<%# Eval("ACIKLAMA") %>'>
                                    <%# Eval("ACIKLAMA") != DBNull.Value && Eval("ACIKLAMA").ToString().Length > 35 ? Eval("ACIKLAMA").ToString().Substring(0, 35) + "..." : Eval("ACIKLAMA") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- (+) BEKLENEN BAKIM TARİHİ --%>
                        <asp:BoundField DataField="BEKLENEN_BAKIM_TARIHI" HeaderText="Beklenen Bakım Tarihi" DataFormatString="{0:dd.MM.yyyy}" NullDisplayText="-" />

                        <%-- ÖNCELİK DURUMU --%>
                        <asp:TemplateField HeaderText="Öncelik">
                            <ItemTemplate>
                                <span class='<%# Eval("ONCELIK_DURUMU") != DBNull.Value && Eval("ONCELIK_DURUMU").ToString() == "Acil" ? "badge-acil" : "badge-normal" %>'>
                                    <%# Eval("ONCELIK_DURUMU") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- İŞLEM (GÖSTER VE SİL BUTONLARI) --%>
                        <asp:TemplateField HeaderText="İşlem">
                            <ItemTemplate>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnGoster" runat="server" Text="GÖSTER" 
                                        CommandName="DetayGoster" CommandArgument='<%# Eval("IS_TALEBI_ID") %>' 
                                        CssClass="btn-goster" />

                                    <asp:Button ID="btnSil" runat="server" Text="SİL" 
                                        CommandName="TalepSil" CommandArgument='<%# Eval("IS_TALEBI_ID") %>' 
                                        CssClass="btn-sil" 
                                        OnClientClick="return confirm('Bu arıza talebini silmek istediğinize emin misiniz?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>