using System;
using System.Configuration; // Web.config'den bağlantı dizesini okumak için şarttır
using System.Data.SqlClient; // SQL Server bağlantı sınıfları için şarttır

namespace BakimYonetimSistemi
{
    public partial class Giris : System.Web.UI.Page
    {
        // Web.config dosyasındaki "BakimBaglantisi" isimli connectionString'i buraya çekiyoruz
        private string connectionString = ConfigurationManager.ConnectionStrings["BakimBaglantisi"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblHata.Text = ""; // Sayfa ilk defa yüklendiğinde hata mesajını temizliyoruz
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            // Kullanıcı adı ve şifre alanlarının boş olup olmadığını kontrol edelim
            if (string.IsNullOrEmpty(txtKullanici.Text.Trim()) || string.IsNullOrEmpty(txtSifre.Text))
            {
                lblHata.Text = "Lütfen kullanıcı adı ve şifre alanlarını doldurun.";
                return;
            }

            // SQL Injection'ı engellemek için parametreli (@p1 ve @p2) sorgumuzu hazırlıyoruz
            string query = "SELECT COUNT(*) FROM KULLANICI WHERE KULLANICI_ADI = @p1 AND SIFRE = @p2";

            // Web.config'den çektiğimiz bağlantı dizesiyle SQL bağlantısını başlatıyoruz
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    // Parametreleri güvenli bir şekilde sorgumuza ekliyoruz
                    cmd.Parameters.AddWithValue("@p1", txtKullanici.Text.Trim());
                    cmd.Parameters.AddWithValue("@p2", txtSifre.Text); // Şifre alanını doğrudan gönderiyoruz

                    try
                    {
                        con.Open(); // Veritabanı bağlantısını açıyoruz

                        // ExecuteScalar ile sorgunun döneceği tek sonucu (COUNT değerini) alıyoruz
                        int sonuc = Convert.ToInt32(cmd.ExecuteScalar());

                        if (sonuc > 0)
                        {
                            // Giriş başarılı! Kullanıcı adını oturumda (Session) saklayalım
                            Session["KullaniciAdi"] = txtKullanici.Text.Trim();

                            // Kullanıcıyı sistemin ana sayfasına yönlendiriyoruz
                            Response.Redirect("Anasayfa.aspx");
                        }
                        else
                        {
                            // Kullanıcı adı veya şifre veritabanındakilerle eşleşmedi
                            lblHata.Text = "Hatalı kullanıcı adı veya şifre!";
                        }
                    }
                    catch (Exception ex)
                    {
                        // Veritabanı bağlantısında veya SQL tarafında bir hata oluşursa yakalıyoruz
                        lblHata.Text = "Veritabanı bağlantı hatası: " + ex.Message;
                    }
                }
            }
        }
    }
}