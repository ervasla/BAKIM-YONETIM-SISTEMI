using System;
using System.Data;
using System.Data.SqlClient;

namespace BakimYonetimSistemi
{
    public partial class KullaniciListesi : System.Web.UI.Page
    {
        string connectionString = @"Server=localhost\SQLEXPRESS;Database=BAKIM_YONETIM;Trusted_Connection=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KullanicilariGetir();
            }
        }

        private void KullanicilariGetir()
        {
            string query = @"SELECT 
                                KULLANICI_ADI, 
                                ISNULL(ADI, '-') AS ADI, 
                                ISNULL(SOYADI, '-') AS SOYADI, 
                                CASE 
                                    WHEN ADMIN_MI = 1 THEN 'Admin' 
                                    ELSE 'Kullanıcı' 
                                END AS ROL_ADI 
                             FROM dbo.KULLANICI 
                             WHERE KAYIT_DURUM = 1";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        con.Open();
                        da.Fill(dt);

                        gvKullanicilar.DataSource = dt;
                        gvKullanicilar.DataBind();
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Veri çekme hatası: " + ex.Message + "');</script>");
                    }
                }
            }
        }

        // MAVİ GÜNCELLE BUTONUNA BASTIĞINDA VERİLERİ VERİTABANINDAN DOLU OLARAK GETİREN METOD
        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            System.Web.UI.WebControls.LinkButton btn = (System.Web.UI.WebControls.LinkButton)sender;
            string kullaniciAdi = btn.CommandArgument;

            string query = "SELECT KULLANICI_ADI, SIFRE, ADI, SOYADI, TC, ADMIN_MI FROM dbo.KULLANICI WHERE KULLANICI_ADI = @kullaniciAdi";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@kullaniciAdi", kullaniciAdi);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        txtKullaniciAdi.Text = dr["KULLANICI_ADI"] != DBNull.Value ? dr["KULLANICI_ADI"].ToString() : "";
                        txtSifre.Text = dr["SIFRE"] != DBNull.Value ? dr["SIFRE"].ToString() : "";

                        // Veritabanında boş olsa dahi güvenli bir şekilde aktarıyoruz:
                        txtAdi.Text = dr["ADI"] != DBNull.Value ? dr["ADI"].ToString() : "";
                        txtSoyadi.Text = dr["SOYADI"] != DBNull.Value ? dr["SOYADI"].ToString() : "";
                        txtTc.Text = dr["TC"] != DBNull.Value ? dr["TC"].ToString() : "";

                        if (dr["ADMIN_MI"] != DBNull.Value)
                            ddlAdminMi.SelectedValue = Convert.ToInt32(dr["ADMIN_MI"]).ToString();
                        else
                            ddlAdminMi.SelectedValue = "0";

                        // Form doldurulduktan sonra pop-up açılır
                        ClientScript.RegisterStartupScript(this.GetType(), "PopUp", "openModal();", true);
                    }
                }
            }
        }

        // POP-UP İÇİNDEKİ YEŞİL GÜNCELLE BUTONUNA BASINCA VERİTABANINA YAZAN METOD
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            string query = @"UPDATE dbo.KULLANICI 
                            SET SIFRE = @sifre, ADI = @adi, SOYADI = @soyadi, TC = @tc, ADMIN_MI = @adminMi 
                            WHERE KULLANICI_ADI = @kullaniciAdi";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@sifre", txtSifre.Text.Trim());
                    cmd.Parameters.AddWithValue("@adi", txtAdi.Text.Trim());
                    cmd.Parameters.AddWithValue("@soyadi", txtSoyadi.Text.Trim());
                    cmd.Parameters.AddWithValue("@tc", txtTc.Text.Trim());
                    cmd.Parameters.AddWithValue("@adminMi", Convert.ToInt32(ddlAdminMi.SelectedValue));
                    cmd.Parameters.AddWithValue("@kullaniciAdi", txtKullaniciAdi.Text.Trim());

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();

                        string script = "alert('Kullanıcı bilgileri başarıyla güncellendi!'); window.location.href='KullaniciListesi.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "UpdateSuccess", script, true);
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Hata: " + ex.Message + "');</script>");
                    }
                }
            }
        }
    }
}