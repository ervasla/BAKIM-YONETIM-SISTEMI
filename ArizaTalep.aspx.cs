using System;

namespace BakimYonetimSistemi
{
    public partial class ArizaTalep : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            // Alanların boş olup olmadığını kontrol edelim
            if (string.IsNullOrEmpty(txtAd.Text) || string.IsNullOrEmpty(txtBaslik.Text) || string.IsNullOrEmpty(txtAciklama.Text))
            {
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                lblMesaj.Text = "Lütfen tüm alanları doldurun!";
            }
            else
            {
                lblMesaj.ForeColor = System.Drawing.Color.Green;
                lblMesaj.Text = "Arıza talebiniz başarıyla kaydedildi! (SQL olmadan simüle edildi)";

                // Formu temizle
                txtAd.Text = "";
                txtBaslik.Text = "";
                txtAciklama.Text = "";
            }
        }
    }
}