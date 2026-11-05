<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Anasayfa.aspx.cs" Inherits="BakimYonetimSistemi.Anasayfa" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Bakım Yönetim Portalı</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body, html {
            background-color: #0f172a;
            color: #333;
            height: 100%;
            overflow-x: hidden;
        }

        /* --- HEADER --- */
        .top-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 4%;
            background: #ffffff;
            border-bottom: 3px solid #e53935;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 70px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo-box {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .logo-circle {
            width: 44px;
            height: 44px;
            background: #1a2a3a;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e53935;
            font-size: 20px;
            font-weight: bold;
        }

        .logo-text {
            color: #111;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: 0.5px;
        }

        .logo-subtext {
            font-size: 10px;
            color: #d32f2f;
            display: block;
            font-weight: 700;
        }

        .nav-menu {
            display: flex;
            gap: 18px;
            list-style: none;
        }

        .nav-menu a {
            text-decoration: none;
            color: #2c3e50;
            font-weight: 700;
            font-size: 13px;
            text-transform: uppercase;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }

        .nav-menu a:hover {
            background-color: #f0f4f8;
            color: #e53935;
        }

        /* --- ORTA ALAN --- */
        .main-container {
            max-width: 100%;
            height: calc(100vh - 70px);
            padding: 20px 2%;
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 20px;
        }

        .news-box {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 18px;
            color: #1e293b;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            height: fit-content;
            max-height: 100%;
            overflow-y: auto;
            border: 1px solid #f87171;
        }

        .news-box-title {
            font-size: 14px;
            color: #dc2626;
            display: flex;
            align-items: center;
            gap: 6px;
            margin: 0;
            font-weight: 700;
        }

        .acil-card {
            background: #ffffff !important;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #dc2626 !important;
            padding: 10px 12px;
            border-radius: 6px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
        }

        .acil-card-text {
            font-size: 13px;
            color: #1e293b !important;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .talep-no-badge {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 2px 7px;
            border-radius: 4px;
            font-weight: 800;
            font-size: 11px;
            border: 1px solid #fca5a5;
        }

        .slider-container {
            position: relative;
            width: 100%;
            height: 100%;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            background-color: #0f172a;
        }

        .slide {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.8s ease-in-out;
        }

        .slide.active { opacity: 1; }

        .slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .slide-overlay {
            position: absolute;
            bottom: 0; left: 0; right: 0;
            padding: 25px;
            background: linear-gradient(transparent, rgba(0, 0, 0, 0.85));
            color: white;
            font-weight: bold;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .slider-dots {
            position: absolute;
            bottom: 20px;
            right: 25px;
            display: flex;
            gap: 6px;
            z-index: 10;
        }

        .dot {
            width: 8px;
            height: 8px;
            background-color: rgba(255,255,255,0.5);
            border-radius: 50%;
            cursor: pointer;
            transition: background 0.3s, width 0.3s;
        }

        .dot.active {
            background-color: #e53935;
            width: 22px;
            border-radius: 10px;
        }

        /* --- KULLANICI EKLE MODAL STİLLERİ --- */
        .custom-modal-overlay {
            display: none; 
            position: fixed; 
            z-index: 99999; 
            left: 0; top: 0; 
            width: 100%; height: 100%; 
            background-color: rgba(15, 23, 42, 0.75); 
            backdrop-filter: blur(4px);
            align-items: center; 
            justify-content: center;
        }

        .custom-modal-content {
            background-color: #ffffff;
            width: 90%;
            max-width: 500px;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .custom-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }

        .custom-modal-header h2 {
            font-size: 18px;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .close-btn {
            font-size: 24px;
            font-weight: bold;
            color: #64748b;
            cursor: pointer;
        }

        .close-btn:hover { color: #dc2626; }

        .form-row { display: flex; gap: 12px; margin-bottom: 12px; }
        .form-group { flex: 1; display: flex; flex-direction: column; gap: 4px; margin-bottom: 12px; }
        .form-group.full { width: 100%; }

        .form-group label { font-size: 12px; font-weight: 700; color: #475569; }

        .modal-input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
        }

        .modal-input:focus { outline: none; border-color: #0d9488; }

        .modal-btn {
            width: 100%;
            background-color: #0d9488;
            color: white;
            border: none;
            padding: 10px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .modal-btn:hover { background-color: #0f766e; }
    </style>
</head>
<body>
    <form id="form1" runat="server" style="height: 100%;">
        
        <!-- HEADER -->
        <header class="top-header">
            <div class="header-left">
                <a href="#" class="logo-box">
                    <div class="logo-circle"><i class="fa-solid fa-bolt"></i></div>
                    <div>
                        <span class="logo-text">BAKIM YÖNETİM SİSTEMİ</span>
                        <span class="logo-subtext">SAHA & BAKIM PORTALI</span>
                    </div>
                </a>
            </div>

            <!-- Üst Menü -->
            <ul class="nav-menu">
                <li><a href="ArizaTalepFormu.aspx"><i class="fa-solid fa-wrench"></i> ARIZA TALEBİ OLUŞTUR</a></li>
                <li><a href="ArizaTakipListesi.aspx"><i class="fa-solid fa-list-check"></i> ARIZA TAKİP LİSTESİ</a></li>
                <li><a onclick="openModal()"><i class="fa-solid fa-user-plus"></i> KULLANICI EKLE</a></li>
                <li><a href="KullaniciListesi.aspx"><i class="fa-solid fa-users"></i> KULLANICI LİSTESİ</a></li>
                <li>
                    <asp:LinkButton ID="btnCikis" runat="server" OnClick="btnCikis_Click" style="color: #dc2626 !important; text-decoration: none;">
                        <i class="fa-solid fa-right-from-bracket"></i> ÇIKIŞ YAP
                    </asp:LinkButton>
                </li>
            </ul>
        </header>

        <!-- ORTA ALAN -->
        <div class="main-container">
            
            <!-- SOL KISIM: KÜÇÜK ACİL ARIZA BİLDİRİM KUTUSU -->
            <div class="news-box">
                <div class="news-box-header">
                    <h2 class="news-box-title">
                        <i class="fa-solid fa-triangle-exclamation fa-beat"></i> ACİL BİLDİRİMLER
                    </h2>
                </div>

                <asp:Repeater ID="rptAcilArizalar" runat="server">
                    <ItemTemplate>
                        <div class="acil-card">
                            <i class="fa-solid fa-circle-exclamation" style="color: #dc2626; font-size: 15px;"></i>
                            <div class="acil-card-text">
                                <%# Eval("IS_TALEP_NO") != DBNull.Value && !string.IsNullOrEmpty(Eval("IS_TALEP_NO").ToString()) ? "<span class='badge bg-danger' style='background-color: #ef4444; color: white; padding: 2px 6px; border-radius: 4px; font-weight: bold; font-size: 11px;'>#" + Eval("IS_TALEP_NO") + "</span>" : "" %>
                                
                                <%# Eval("BIRIM_ADI") != DBNull.Value && !string.IsNullOrEmpty(Eval("BIRIM_ADI").ToString()) ? "<span style='background-color: #f1f5f9; color: #334155; border: 1px solid #cbd5e1; padding: 2px 6px; border-radius: 4px; font-weight: 600; font-size: 11px; margin-left: 4px;'>" + Eval("BIRIM_ADI") + "</span>" : "" %>
                                
                                <div style="margin-top: 4px; width: 100%; font-size: 13px; font-weight: 500;"><%# Eval("ACIKLAMA") %></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlAcilYok" runat="server" Visible="false" Style="text-align: center; padding: 20px 5px; color: #4ade80;">
                    <i class="fa-solid fa-circle-check" style="font-size: 24px; margin-bottom: 8px;"></i>
                    <p style="font-size: 11px; font-weight: 600;">Aktif acil bildirim bulunmamaktadır.</p>
                </asp:Panel>
            </div>

            <!-- SAĞ KISIM: SLIDER -->
            <div class="slider-container" id="slider">
                <div class="slide active"><img src="images/santral1.jpg" alt="Santral 1" /><div class="slide-overlay"><i class="fa-solid fa-industry"></i> Termik Santral Saha Operasyonları</div></div>
                <div class="slide"><img src="images/santral2.jpg" alt="Santral 2" /><div class="slide-overlay"><i class="fa-solid fa-water"></i> Hidroelektrik Santrallerimiz (HES)</div></div>
                <div class="slide"><img src="images/santral3.jpg" alt="Santral 3" /><div class="slide-overlay"><i class="fa-solid fa-wind"></i> Rüzgar Enerji Santralleri (RES)</div></div>
                <div class="slide"><img src="images/santral4.jpg" alt="Santral 4" /><div class="slide-overlay"><i class="fa-solid fa-mountain"></i> Baraj Havzası & Ünite Yapıları</div></div>
                <div class="slide"><img src="images/santral5.jpg" alt="Santral 5" /><div class="slide-overlay"><i class="fa-solid fa-bolt"></i> Enerji Üretim Tesisleri</div></div>
                <div class="slide"><img src="images/santral6.jpg" alt="Santral 6" /><div class="slide-overlay"><i class="fa-solid fa-gears"></i> Türbin ve Ekipman Alanları</div></div>
                <div class="slide"><img src="images/santral7.jpg" alt="Santral 7" /><div class="slide-overlay"><i class="fa-solid fa-industry"></i> Ünite ve Şalt Tesisleri</div></div>
                <div class="slide"><img src="images/santral8.jpg" alt="Santral 8" /><div class="slide-overlay"><i class="fa-solid fa-water"></i> Baraj ve Su Tutma Yapıları</div></div>
                <div class="slide"><img src="images/santral9.jpg" alt="Santral 9" /><div class="slide-overlay"><i class="fa-solid fa-mountain"></i> Santral Genel Saha Görünümü</div></div>
                <div class="slide"><img src="images/santral10.jpg" alt="Santral 10" /><div class="slide-overlay"><i class="fa-solid fa-bolt"></i> Elektrik Üretim Sahası</div></div>
                <div class="slide"><img src="images/santral11.jpg" alt="Santral 11" /><div class="slide-overlay"><i class="fa-solid fa-industry"></i> Santral Kontrol Binası</div></div>
                <div class="slide"><img src="images/santral12.jpg" alt="Santral 12" /><div class="slide-overlay"><i class="fa-solid fa-water"></i> HES Türbin ve Havza Yapısı</div></div>
                <div class="slide"><img src="images/santral13.jpg" alt="Santral 13" /><div class="slide-overlay"><i class="fa-solid fa-gears"></i> Saha Bakım ve Operasyon</div></div>
                <div class="slide"><img src="images/santral14.jpg" alt="Santral 14" /><div class="slide-overlay"><i class="fa-solid fa-camera"></i> Tesislerimizden Genel Görünüm</div></div>

                <div class="slider-dots">
                    <span class="dot active" onclick="setSlide(0)"></span>
                    <span class="dot" onclick="setSlide(1)"></span>
                    <span class="dot" onclick="setSlide(2)"></span>
                    <span class="dot" onclick="setSlide(3)"></span>
                    <span class="dot" onclick="setSlide(4)"></span>
                    <span class="dot" onclick="setSlide(5)"></span>
                    <span class="dot" onclick="setSlide(6)"></span>
                    <span class="dot" onclick="setSlide(7)"></span>
                    <span class="dot" onclick="setSlide(8)"></span>
                    <span class="dot" onclick="setSlide(9)"></span>
                    <span class="dot" onclick="setSlide(10)"></span>
                    <span class="dot" onclick="setSlide(11)"></span>
                    <span class="dot" onclick="setSlide(12)"></span>
                    <span class="dot" onclick="setSlide(13)"></span>
                </div>
            </div>
        </div>

        <!-- KULLANICI EKLE MODAL PENCERESİ -->
        <div id="kullaniciModal" class="custom-modal-overlay">
            <div class="custom-modal-content">
                <div class="custom-modal-header">
                    <h2><i class="fa-solid fa-user-plus text-danger"></i> Kullanıcı Ekle</h2>
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                </div>
                <div class="custom-modal-body">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Adı</label>
                            <asp:TextBox ID="txtAdi" runat="server" CssClass="modal-input" Placeholder="Ad giriniz"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Soyadı</label>
                            <asp:TextBox ID="txtSoyadi" runat="server" CssClass="modal-input" Placeholder="Soyad giriniz"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group full">
                        <label>TC Kimlik No</label>
                        <asp:TextBox ID="txtTc" runat="server" CssClass="modal-input" Placeholder="11 haneli TC No" MaxLength="11"></asp:TextBox>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Kullanıcı Adı</label>
                            <asp:TextBox ID="txtKullaniciAdi" runat="server" CssClass="modal-input" Placeholder="Kullanıcı adı"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Şifre</label>
                            <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" CssClass="modal-input" Placeholder="Şifre giriniz"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group full">
                        <label>Kullanıcı Rolü</label>
                        <asp:DropDownList ID="ddlAdminMi" runat="server" CssClass="modal-input">
                            <asp:ListItem Value="0">Kullanıcı</asp:ListItem>
                            <asp:ListItem Value="1">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="btnEkle" runat="server" Text="EKLE" CssClass="modal-btn" OnClick="btnEkle_Click" />
                </div>
            </div>
        </div>

    </form>

    <!-- JAVASCRIPT KODLARI -->
    <script type="text/javascript">
        // SLIDER
        var currentSlide = 0;
        var slides = document.querySelectorAll('.slide');
        var dots = document.querySelectorAll('.dot');
        var slideTimer;

        function showSlide(index) {
            slides.forEach(function (slide) { slide.classList.remove('active'); });
            dots.forEach(function (dot) { dot.classList.remove('active'); });

            slides[index].classList.add('active');
            dots[index].classList.add('active');
            currentSlide = index;
        }

        function nextSlide() {
            var next = (currentSlide + 1) % slides.length;
            showSlide(next);
        }

        function setSlide(index) {
            showSlide(index);
            restartTimer();
        }

        function startTimer() {
            slideTimer = setInterval(nextSlide, 2500);
        }

        function restartTimer() {
            clearInterval(slideTimer);
            startTimer();
        }

        var sliderBox = document.getElementById('slider');
        if (sliderBox) {
            sliderBox.addEventListener('mouseenter', function () { clearInterval(slideTimer); });
            sliderBox.addEventListener('mouseleave', function () { startTimer(); });
        }
        startTimer();

        // MODAL FONKSİYONLARI
        function openModal() {
            document.getElementById('kullaniciModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('kullaniciModal').style.display = 'none';
        }

        window.onclick = function (event) {
            var modal = document.getElementById('kullaniciModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>