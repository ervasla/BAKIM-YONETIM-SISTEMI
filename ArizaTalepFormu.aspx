<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ArizaTalepFormu.aspx.cs" Inherits="BakimYonetimSistemi.ArizaTalepFormu" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Arıza İş Talep Formu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            background-color: #f4f6f9;
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }
        .form-container {
            max-width: 1000px;
            margin: 20px auto;
            background: #ffffff;
            border: 1px solid #d2d6de;
            border-radius: 4px;
            box-shadow: 0 1px 1px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .form-title {
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            color: #444;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 18px;
        }
        label {
            display: block;
            font-weight: bold;
            font-size: 13px;
            color: #333;
            margin-bottom: 6px;
        }
        .form-control {
            width: 100%;
            height: 34px;
            padding: 6px 12px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 13px;
            color: #555;
        }
        .form-control.input-error {
            border-color: #dd4b39 !important;
            background-color: #fff8f8;
        }
        textarea.form-control {
            height: auto;
        }
        .grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }
        .grid-4 {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr 1fr;
            gap: 15px;
            align-items: start;
        }
        .radio-container {
            display: flex;
            gap: 15px;
            height: 34px;
            align-items: center;
        }
        .radio-container label {
            font-weight: normal;
            margin-bottom: 0;
            display: inline;
            cursor: pointer;
            font-size: 13px;
        }
        .validation-msg {
            color: #dd4b39;
            font-size: 12px;
            margin-top: 4px;
            display: none; /* Varsayılan gizli */
            font-weight: 500;
        }
        .btn-container {
            text-align: center;
            margin-top: 25px;
        }
        .btn-submit {
            background-color: #00796b;
            color: white;
            border: none;
            padding: 10px 40px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
            border-radius: 4px;
            cursor: pointer;
        }

        /* SAĞ ÜST KÖŞE BİLDİRİM KUTUSU */
        .custom-toast {
            display: none;
            position: fixed;
            top: 25px;
            right: 25px;
            background-color: #2e7d32;
            color: #ffffff;
            padding: 16px 24px;
            border-radius: 8px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 15px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            align-items: center;
            gap: 10px;
        }
    </style>

    <script type="text/javascript">
        // Kontrol Edilecek Alanlar Listesi
        function getFields() {
            return [
                { id: '<%= ddlTalepEdilenBirim.ClientID %>', msgId: 'errTalepEdilenBirim' },
                { id: '<%= txtAciklama.ClientID %>', msgId: 'errAciklama' },
                { id: '<%= txtKartlamaAciklamasi.ClientID %>', msgId: 'errKartlamaAciklamasi' },
                { id: '<%= txtBeklenenBakimTarihi.ClientID %>', msgId: 'errBeklenenBakimTarihi' },
                { id: '<%= ddlOncelikDurumu.ClientID %>', msgId: 'errOncelikDurumu' },
                { id: '<%= ddlArizaKodu.ClientID %>', msgId: 'errArizaKodu' },
                { id: '<%= txtArizaTarihi.ClientID %>', msgId: 'errArizaTarihi' },
                { id: '<%= txtArizaSaati.ClientID %>', msgId: 'errArizaSaati' },
                { id: '<%= ddlEkipmanSec.ClientID %>', msgId: 'errEkipmanSec' }
            ];
        }

        function validateForm() {
            var isValid = true;
            var fields = getFields();

            fields.forEach(function (field) {
                var element = document.getElementById(field.id);
                var errorSpan = document.getElementById(field.msgId);

                if (element && errorSpan) {
                    var val = element.value ? element.value.trim() : '';

                    if (val === '') {
                        errorSpan.style.display = 'block';
                        element.classList.add('input-error');
                        isValid = false;
                    } else {
                        errorSpan.style.display = 'none';
                        element.classList.remove('input-error');
                    }
                }
            });

            // RadioButtonList (Ekipman Durdu mu?) Kontrolü
            var rblEkipman = document.querySelectorAll("#<%= rblEkipmanDurduMu.ClientID %> input[type='radio']:checked");
            var errEkipmanDurdu = document.getElementById("errEkipmanDurduMu");
            if (rblEkipman.length === 0) {
                errEkipmanDurdu.style.display = 'block';
                isValid = false;
            } else {
                errEkipmanDurdu.style.display = 'none';
            }

            // RadioButtonList (Ünite Durdu mu?) Kontrolü
            var rblUnite = document.querySelectorAll("#<%= rblUniteDurduMu.ClientID %> input[type='radio']:checked");
            var errUniteDurdu = document.getElementById("errUniteDurduMu");
            if (rblUnite.length === 0) {
                errUniteDurdu.style.display = 'block';
                isValid = false;
            } else {
                errUniteDurdu.style.display = 'none';
            }

            return isValid;
        }

        // KULLANICI DOLDURMA YAPARKEN UYARILARI ANINDA KALDIRAN CANLI DİNLENİCİ
        document.addEventListener("DOMContentLoaded", function () {
            var fields = getFields();

            fields.forEach(function (field) {
                var element = document.getElementById(field.id);
                var errorSpan = document.getElementById(field.msgId);

                if (element && errorSpan) {
                    // Kutucuğa yazıldığında veya seçim yapıldığında çalışır
                    var checkInput = function () {
                        if (element.value && element.value.trim() !== '') {
                            errorSpan.style.display = 'none';
                            element.classList.remove('input-error');
                        }
                    };

                    element.addEventListener('input', checkInput);
                    element.addEventListener('change', checkInput);
                }
            });

            // Radio Buttonlar seçildiğinde uyarıyı kaldırır
            var rblEkipmanRadios = document.querySelectorAll("#<%= rblEkipmanDurduMu.ClientID %> input[type='radio']");
            rblEkipmanRadios.forEach(function (radio) {
                radio.addEventListener('change', function () {
                    document.getElementById("errEkipmanDurduMu").style.display = 'none';
                });
            });

            var rblUniteRadios = document.querySelectorAll("#<%= rblUniteDurduMu.ClientID %> input[type='radio']");
            rblUniteRadios.forEach(function (radio) {
                radio.addEventListener('change', function () {
                    document.getElementById("errUniteDurduMu").style.display = 'none';
                });
            });
        });

        function yesilKutuyuGoster() {
            var toast = document.getElementById("toastBox");
            if (toast) {
                toast.style.display = "flex";
                setTimeout(function () {
                    window.location.href = window.location.href;
                }, 2000);
            }
        }
    </script> 
</head>
<body>
    <form id="form1" runat="server">
        <!-- SAĞ ÜST KÖŞE YEŞİL BİLDİRİM KUTUSU (TOAST) -->
        <div id="toastBox" class="custom-toast">
            <i class="fa-solid fa-circle-check" style="font-size: 18px;"></i>
            <span>İşleminiz gerçekleşti</span>
        </div>

        <div class="form-container">
            <div class="form-title">Arıza İş Talep Formu</div>

            <!-- Talep Edilen Birim -->
            <div class="form-group">
                <label>Talep Edilen Birim</label>
                <asp:DropDownList ID="ddlTalepEdilenBirim" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                    <asp:ListItem Value="">-- Seçiniz --</asp:ListItem>
                </asp:DropDownList>
                <span id="errTalepEdilenBirim" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen talep edilen birimi seçiniz.</span>
            </div>

            <!-- Açıklama -->
            <div class="form-group">
                <label>Açıklama</label>
                <asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                <span id="errAciklama" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen açıklama alanını doldurunuz.</span>
            </div>

            <!-- Kartlama Açıklaması -->
            <div class="form-group">
                <label>Kartlama Açıklaması</label>
                <asp:TextBox ID="txtKartlamaAciklamasi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                <span id="errKartlamaAciklamasi" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen kartlama açıklamasını doldurunuz.</span>
            </div>

            <!-- Üçlü Satır -->
            <div class="grid-3">
                <div class="form-group">
                    <label>Beklenen Bakım Tarihi</label>
                    <asp:TextBox ID="txtBeklenenBakimTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    <span id="errBeklenenBakimTarihi" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen beklenen bakım tarihini seçiniz.</span>
                </div>
                <div class="form-group">
                    <label>Öncelik Durumu</label>
                    <asp:DropDownList ID="ddlOncelikDurumu" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">-- Seçiniz --</asp:ListItem>
                        <asp:ListItem Value="Normal">Normal</asp:ListItem>
                        <asp:ListItem Value="Acil">Acil</asp:ListItem>
                    </asp:DropDownList>
                    <span id="errOncelikDurumu" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen öncelik durumunu seçiniz.</span>
                </div>
                <!-- Arıza Kodu -->
                <div class="form-group">
                    <label>Arıza Kodu</label>
                    <asp:DropDownList ID="ddlArizaKodu" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                        <asp:ListItem Value="">-- Seçiniz --</asp:ListItem>
                    </asp:DropDownList>
                    <span id="errArizaKodu" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen arıza kodunu seçiniz.</span>
                </div>
            </div>

            <!-- Dörtlü Satır -->
            <div class="grid-4">
                <div class="form-group">
                    <label>Arıza Tarihi</label>
                    <asp:TextBox ID="txtArizaTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    <span id="errArizaTarihi" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen arıza tarihini seçiniz.</span>
                </div>
                <div class="form-group">
                    <label>Arıza Saati</label>
                    <asp:TextBox ID="txtArizaSaati" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    <span id="errArizaSaati" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen arıza saatini seçiniz.</span>
                </div>
                <div class="form-group">
                    <label>Ekipman Durdu mu?</label>
                    <asp:RadioButtonList ID="rblEkipmanDurduMu" runat="server" RepeatDirection="Horizontal" CssClass="radio-container">
                        <asp:ListItem Value="Evet">Evet</asp:ListItem>
                        <asp:ListItem Value="Hayır">Hayır</asp:ListItem>
                    </asp:RadioButtonList>
                    <span id="errEkipmanDurduMu" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen seçim yapınız.</span>
                </div>
                <div class="form-group">
                    <label>Ünite Durdu mu ?</label>
                    <asp:RadioButtonList ID="rblUniteDurduMu" runat="server" RepeatDirection="Horizontal" CssClass="radio-container">
                        <asp:ListItem Value="Evet">Evet</asp:ListItem>
                        <asp:ListItem Value="Hayır">Hayır</asp:ListItem>
                    </asp:RadioButtonList>
                    <span id="errUniteDurduMu" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen seçim yapınız.</span>
                </div>
            </div>

            <!-- Ekipman Seç -->
            <div class="form-group" style="margin-top: 15px;">
                <label>Ekipman Seç</label>
                <asp:DropDownList ID="ddlEkipmanSec" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                    <asp:ListItem Value="">-- Seçiniz --</asp:ListItem>
                </asp:DropDownList>
                <span id="errEkipmanSec" class="validation-msg"><i class="fa-solid fa-circle-exclamation"></i> Lütfen ekipman seçiniz.</span>
            </div>

            <!-- Gönder -->
            <div class="btn-container">
                <asp:Button ID="btnGonder" runat="server" Text="GÖNDER" CssClass="btn-submit" OnClick="btnGonder_Click" OnClientClick="return validateForm();" />
            </div>

            <div style="margin-top: 15px; text-align: center;">
                <asp:Label ID="lblMesaj" runat="server" Font-Bold="true" Font-Size="14px"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>