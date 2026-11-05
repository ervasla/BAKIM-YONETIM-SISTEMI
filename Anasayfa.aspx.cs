using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace BakimYonetimSistemi
{
    public partial class Anasayfa : System.Web.UI.Page
    {
        // SSMS ekranındaki sunucu ve veritabanı bilgilerinize tam uyumlu bağlantı dizesi
        string connectionString = @"Server=localhost\SQLEXPRESS;Database=BAKIM_YONETIM;Trusted_Connection=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AcilArizalariGetir();
            }
        }

        private void AcilArizalariGetir()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // T.KAYIT_DURUMU = 1 eklenerek silinen (pasif) kayıtlar elendi
                string query = @"SELECT T.IS_TALEP_NO, T.ACIKLAMA, B.birim_adi AS BIRIM_ADI 
                        FROM dbo.TALEPLER T 
                        LEFT JOIN dbo.BIRIMLER B ON T.TALEP_EDILEN_BIRIM_ID = B.birim_id 
                        WHERE T.ONCELIK_DURUMU = 'Acil' AND T.KAYIT_DURUMU = 1
                        ORDER BY T.IS_TALEBI_ID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        con.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptAcilArizalar.DataSource = dt;
                            rptAcilArizalar.DataBind();
                            rptAcilArizalar.Visible = true;
                            pnlAcilYok.Visible = false;
                        }
                        else
                        {
                            rptAcilArizalar.Visible = false;
                            pnlAcilYok.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Hata: " + ex.Message.Replace("'", "\\'") + "');</script>");
                    }
                }
            }
        }
        protected void btnEkle_Click(object sender, EventArgs e)
        {
            string query = @"INSERT INTO KULLANICI 
                    (KULLANICI_ADI, SIFRE, KAYIT_DURUM, ADI, SOYADI, TC, ADMIN_MI) 
                    VALUES 
                    (@kullaniciAdi, @sifre, 1, @adi, @soyadi, @tc, @adminMi)";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@kullaniciAdi", txtKullaniciAdi.Text.Trim());
                    cmd.Parameters.AddWithValue("@sifre", txtSifre.Text.Trim());
                    cmd.Parameters.AddWithValue("@adi", txtAdi.Text.Trim());
                    cmd.Parameters.AddWithValue("@soyadi", txtSoyadi.Text.Trim());
                    cmd.Parameters.AddWithValue("@tc", txtTc.Text.Trim());
                    cmd.Parameters.AddWithValue("@adminMi", Convert.ToInt32(ddlAdminMi.SelectedValue));

                    try
                    {
                        con.Open();
                        int sonuc = cmd.ExecuteNonQuery();

                        if (sonuc > 0)
                        {
                            FormuTemizle();

                            // Alert mesajı gösterip TAMAM'a basılınca Kullanıcı Listesi sayfasına yönlendirir
                            string script = "alert('Kullanıcı başarıyla kaydedildi!'); window.location.href='Anasayfa.aspx';";
                            ClientScript.RegisterStartupScript(this.GetType(), "AddSuccess", script, true);
                        }
                    }
                    catch (Exception ex)
                    {
                        string errorScript = "alert('Hata oluştu: " + ex.Message.Replace("'", "\\'") + "');";
                        ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert", errorScript, true);
                    }
                }
            }
        }

        private void FormuTemizle()
        {
            txtAdi.Text = "";
            txtSoyadi.Text = "";
            txtTc.Text = "";
            txtKullaniciAdi.Text = "";
            txtSifre.Text = "";
            ddlAdminMi.SelectedIndex = 0;
        }
        protected void btnCikis_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("Giris.aspx");
        }
    } // Class Kapanışı
} // Namespace Kapanışı