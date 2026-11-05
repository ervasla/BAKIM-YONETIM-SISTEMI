using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BakimYonetimSistemi
{
    public partial class ArizaTakipListesi : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["BakimBaglantisi"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                TalepleriGetir();
            }
        }

        private void TalepleriGetir(string aramaMetni = "")
        {
            string query = @"
                SELECT 
                    T.IS_TALEBI_ID,
                    T.IS_TALEP_NO,
                    B.Birim_adi,
                    E.Ekipman_adi,
                    T.ACIKLAMA,
                    T.BEKLENEN_BAKIM_TARIHI,
                    T.ONCELIK_DURUMU
                FROM TALEPLER T
                LEFT JOIN BIRIMLER B ON T.TALEP_EDILEN_BIRIM_ID = B.Birim_id
                LEFT JOIN EKIPMANLAR E ON T.EKIPMAN_ID = E.Ekipman_id
                WHERE T.KAYIT_DURUMU = 1 ";

            // Sadece IS_TALEP_NO üzerinden arama
            if (!string.IsNullOrEmpty(aramaMetni))
            {
                query += " AND T.IS_TALEP_NO LIKE @ara";
            }

            query += " ORDER BY T.IS_TALEBI_ID DESC";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(aramaMetni))
                    {
                        cmd.Parameters.AddWithValue("@ara", "%" + aramaMetni.Trim() + "%");
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        con.Open();
                        da.Fill(dt);

                        gvTalepler.DataSource = dt;
                        gvTalepler.DataBind();
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Veri çekme hatası: " + ex.Message + "');</script>");
                    }
                }
            }
        }

        protected void txtAra_TextChanged(object sender, EventArgs e)
        {
            TalepleriGetir(txtAra.Text);
        }

        protected void gvTalepler_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DetayGoster")
            {
                string talepId = e.CommandArgument.ToString();
                Response.Redirect("ArizaTalepDetay.aspx?id=" + talepId);
            }
            else if (e.CommandName == "TalepSil")
            {
                int talepId = Convert.ToInt32(e.CommandArgument);
                TalepSil(talepId);
            }
        }

        private void TalepSil(int talepId)
        {
            string query = "UPDATE TALEPLER SET KAYIT_DURUMU = 0 WHERE IS_TALEBI_ID = @id";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", talepId);

                    try
                    {
                        con.Open();
                        int sonuc = cmd.ExecuteNonQuery();

                        if (sonuc > 0)
                        {
                            TalepleriGetir(txtAra.Text);
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Silme hatası: " + ex.Message + "');</script>");
                    }
                }
            }
        }

        // SAYFALAMA METODU
        protected void gvTalepler_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTalepler.PageIndex = e.NewPageIndex;
            TalepleriGetir(txtAra.Text);
        }
    }
}