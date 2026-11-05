using System;
using System.Configuration;
using System.Data.SqlClient;

namespace BakimYonetimSistemi
{
    public partial class ArizaTalepFormu : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["BakimBaglantisi"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMesaj.Text = "";
                BirimleriGetir();
                ArizaKodlariniGetir();
                EkipmanlariGetir();
            }
        }

        private void BirimleriGetir()
        {
            string query = "SELECT Birim_id, Birim_adi FROM BİRİMLER";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();

                        ddlTalepEdilenBirim.DataSource = dr;
                        ddlTalepEdilenBirim.DataTextField = "Birim_adi";
                        ddlTalepEdilenBirim.DataValueField = "Birim_id";
                        ddlTalepEdilenBirim.DataBind();
                    }
                    catch (Exception)
                    {
                        BirimleriGetirAlternatif();
                    }
                }
            }
        }

        private void BirimleriGetirAlternatif()
        {
            string query = "SELECT Birim_id, Birim_adi FROM BIRIMLER";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();

                        ddlTalepEdilenBirim.DataSource = dr;
                        ddlTalepEdilenBirim.DataTextField = "Birim_adi";
                        ddlTalepEdilenBirim.DataValueField = "Birim_id";
                        ddlTalepEdilenBirim.DataBind();
                    }
                    catch (Exception ex)
                    {
                        lblMesaj.ForeColor = System.Drawing.Color.Red;
                        lblMesaj.Text += " [Birimler Hatası: " + ex.Message + "]";
                    }
                }
            }
        }

        private void ArizaKodlariniGetir()
        {
            string query = "SELECT Ariza_id, Ariza_kodu, (Ariza_kodu + ' - ' + Ariza_adi) AS GosterilecekAd FROM ARIZA_KODLARI";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();

                        ddlArizaKodu.DataSource = dr;
                        ddlArizaKodu.DataTextField = "GosterilecekAd";
                        ddlArizaKodu.DataValueField = "Ariza_id";
                        ddlArizaKodu.DataBind();
                    }
                    catch (Exception ex)
                    {
                        lblMesaj.ForeColor = System.Drawing.Color.Red;
                        lblMesaj.Text += " [Arıza Kodu Hatası: " + ex.Message + "]";
                    }
                }
            }
        }

        // EKİPMANLARI Ekipman_id İLE ÇEKİYORUZ
        private void EkipmanlariGetir()
        {
            string query = "SELECT Ekipman_id, (Ekipman_kodu + ' - ' + Ekipman_adi) AS GosterilecekAd FROM EKIPMANLAR WHERE Kayit_durum = 1";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();

                        ddlEkipmanSec.DataSource = dr;
                        ddlEkipmanSec.DataTextField = "GosterilecekAd";
                        ddlEkipmanSec.DataValueField = "Ekipman_id"; 
                        ddlEkipmanSec.DataBind();
                    }
                    catch (Exception ex)
                    {
                        lblMesaj.ForeColor = System.Drawing.Color.Red;
                        lblMesaj.Text += " [Ekipman Hatası: " + ex.Message + "]";
                    }
                }
            }
        }

        protected void btnGonder_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlTalepEdilenBirim.SelectedValue) ||
                string.IsNullOrEmpty(txtAciklama.Text.Trim()) ||
                string.IsNullOrEmpty(ddlArizaKodu.SelectedValue))
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Lütfen zorunlu alanları (Birim, Açıklama, Arıza Kodu) doldurunuz.";
                return;
            }

            string query = @"INSERT INTO TALEPLER 
                    (IS_TALEP_NO, TALEP_EDILEN_BIRIM_ID, ACIKLAMA, KARTLAMA_ACIKLAMASI, BEKLENEN_BAKIM_TARIHI, TALEP_TARIHI, TALEP_SAATI, ARIZA_KODU_ID, EKIPMAN_ID, ONCELIK_DURUMU, EKIPMAN_DURUMU, UNITE_DURUMU, KAYIT_DURUMU) 
                    VALUES 
                    (@isTalepNo, @birimId, @aciklama, @kartlama, @beklenenTarih, @talepTarih, @talepSaat, @arizaKoduId, @ekipmanId, @oncelik, @ekipmanDurumu, @uniteDurumu, 1)";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    string isTalepNo = DateTime.Now.ToString("yyyyMMddHHmm");
                    cmd.Parameters.AddWithValue("@isTalepNo", isTalepNo);

                    cmd.Parameters.AddWithValue("@birimId", Convert.ToInt32(ddlTalepEdilenBirim.SelectedValue));
                    cmd.Parameters.AddWithValue("@arizaKoduId", Convert.ToInt32(ddlArizaKodu.SelectedValue));

                    cmd.Parameters.AddWithValue("@ekipmanId", string.IsNullOrEmpty(ddlEkipmanSec.SelectedValue) ? (object)DBNull.Value : Convert.ToInt32(ddlEkipmanSec.SelectedValue));

                    cmd.Parameters.AddWithValue("@aciklama", txtAciklama.Text.Trim());
                    cmd.Parameters.AddWithValue("@kartlama", string.IsNullOrEmpty(txtKartlamaAciklamasi.Text) ? (object)DBNull.Value : txtKartlamaAciklamasi.Text.Trim());

                    cmd.Parameters.AddWithValue("@beklenenTarih", string.IsNullOrEmpty(txtBeklenenBakimTarihi.Text) ? (object)DBNull.Value : txtBeklenenBakimTarihi.Text);
                    cmd.Parameters.AddWithValue("@talepTarih", string.IsNullOrEmpty(txtArizaTarihi.Text) ? (object)DBNull.Value : txtArizaTarihi.Text);
                    cmd.Parameters.AddWithValue("@talepSaat", string.IsNullOrEmpty(txtArizaSaati.Text) ? (object)DBNull.Value : txtArizaSaati.Text);

                    cmd.Parameters.AddWithValue("@oncelik", string.IsNullOrEmpty(ddlOncelikDurumu.SelectedValue) ? (object)DBNull.Value : ddlOncelikDurumu.SelectedValue);

                    cmd.Parameters.AddWithValue("@ekipmanDurumu", rblEkipmanDurduMu.SelectedItem != null ? rblEkipmanDurduMu.SelectedValue : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@uniteDurumu", rblUniteDurduMu.SelectedItem != null ? rblUniteDurduMu.SelectedValue : (object)DBNull.Value);

                    try
                    {
                        con.Open();
                        int sonuc = cmd.ExecuteNonQuery();

                        if (sonuc > 0)
                        {
                            // Sunucu belleğindeki ve form elemanlarındaki tüm seçimleri sıfırla
                            FormuTemizle();

                            // Kullanıcıya mesaj gösterip Anasayfa'ya yönlendir
                            string script = "alert('Arıza talebiniz başarıyla kaydedilmiştir! Talep No: " + isTalepNo + "'); window.location.href='Anasayfa.aspx';";
                            ClientScript.RegisterStartupScript(this.GetType(), "GonderSuccess", script, true);
                        }
                        else
                        {
                            lblMesaj.ForeColor = System.Drawing.Color.Red;
                            lblMesaj.Text = "Kayıt sırasında bir hata oluştu.";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMesaj.ForeColor = System.Drawing.Color.Red;
                        lblMesaj.Text = "Veritabanı Kayıt Hatası: " + ex.Message;
                    }
                }
            }
        }
        private void FormuTemizle()
        {
            ddlTalepEdilenBirim.SelectedIndex = 0;
            ddlArizaKodu.SelectedIndex = 0;
            ddlEkipmanSec.SelectedIndex = 0;
            txtAciklama.Text = "";
            txtKartlamaAciklamasi.Text = "";
            txtBeklenenBakimTarihi.Text = "";
            ddlOncelikDurumu.SelectedIndex = 0;
            txtArizaTarihi.Text = "";
            txtArizaSaati.Text = "";
            rblEkipmanDurduMu.ClearSelection();
            rblUniteDurduMu.ClearSelection();
        }
    }
}