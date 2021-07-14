Eklenti Komutlari Ve Ayarlanmasi Gereken Kisimlar 
Komutlar :
register_concmd("amx_x","@yazdirt",admin,"Yazi yaz");   Konsol Komutu ile mesaj gönderme Kullanimi : amx_x yazcağinizyazi
   
register_clcmd("say /x", "@okut",admin);             /x yazcağiniz yazi veya /x yazdiğiniz zaman chat kismi açılır ordan yazabilirsiniz.
register_clcmd("admin_chat", "@yazdirt",admin);


Okuyabilcek ve yazabilceklerin yetkisi :
static const admin = ADMIN_RESERVATION;