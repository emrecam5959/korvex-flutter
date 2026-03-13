# Korvex File Manager - Web Sürümü Hızlı Başlangıç

## 5 Dakikada Web Sürümünü Çalıştırın

### Adım 1: Sunucuyu Başlat (Windows)

```bash
cd korvex-server
java -jar korvex-server-1.0.0.jar
```

Çıktı:
```
Korvex Sunucu başlatıldı. Port: 5555
Maksimum bağlantı sayısı: 5
```

### Adım 2: WebSocket Proxy'yi Başlat (Yeni Terminal)

```bash
cd korvex_flutter
pip install websockets
python websocket_proxy.py
```

Çıktı:
```
[2024-01-15 10:30:00] Korvex WebSocket Proxy başlatılıyor...
[2024-01-15 10:30:00] WebSocket dinleme adresi: 0.0.0.0:5556
[2024-01-15 10:30:00] TCP sunucusu adresi: localhost:5555
[2024-01-15 10:30:00] WebSocket Proxy başlatıldı. Bağlantıları bekliyorum...
```

### Adım 3: Flutter Web Uygulamasını Çalıştır (Yeni Terminal)

```bash
cd korvex_flutter
flutter run -d chrome
```

Uygulama otomatik olarak tarayıcıda açılacak.

### Adım 4: Uygulamayı Kullan

1. **Sunucu Bağlantısı**
   - Host: `localhost` (veya bilgisayarınızın IP adresi)
   - Port: `5556`
   - Şifre: Sunucuda ayarladığınız şifre

2. **Dosya İşlemleri**
   - Klasör oluştur
   - Dosya yükle
   - Dosya sil
   - Dosya taşı
   - Dosya yeniden adlandır

## Farklı Bilgisayardan Bağlanma

Eğer web uygulamasını farklı bir bilgisayardan çalıştırıyorsanız:

1. **Sunucu IP Adresini Bulun**
   ```bash
   # Windows
   ipconfig
   
   # Linux/Mac
   ifconfig
   ```

2. **Web Uygulamasında Girin**
   - Host: `192.168.1.100` (örnek IP adresi)
   - Port: `5556`

## Sorun Giderme

### "Sunucuya bağlanılamadı" Hatası

**Çözüm:**
1. Sunucunun çalışıp çalışmadığını kontrol edin
2. WebSocket Proxy'nin çalışıp çalışmadığını kontrol edin
3. Firewall ayarlarını kontrol edin

### "Şifre yanlış" Hatası

**Çözüm:**
1. Şifrenin doğru olduğunu kontrol edin
2. Sunucuyu yeniden başlatın

### Dosya Yükleme Sorunu

**Çözüm:**
1. Hedef klasörün yazılabilir olduğunu kontrol edin
2. Disk alanının yeterli olduğunu kontrol edin

## Komut Satırı Seçenekleri

### Chrome Yerine Firefox Kullan

```bash
flutter run -d firefox
```

### Belirli Bir Port Kullan

```bash
flutter run -d chrome --web-port 8080
```

### Release Modu

```bash
flutter run -d chrome --release
```

## Production Dağıtımı

### Web Uygulamasını Derle

```bash
flutter build web --release
```

Derlenen dosyalar `build/web/` klasöründe bulunur.

### Nginx'te Yayınla

```nginx
server {
    listen 80;
    server_name example.com;
    
    root /var/www/korvex;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Docker'da Çalıştır

```dockerfile
FROM nginx:latest
COPY build/web /usr/share/nginx/html
EXPOSE 80
```

## Notlar

- Web sürümü, masaüstü bilgisayardan dosya yönetimi için optimize edilmiştir
- WebSocket Proxy, TCP sunucusu ile web uygulaması arasında köprü görevi görür
- Aynı WiFi ağında olmanız gerekir
- Sunucu ve proxy'nin çalışıyor olması gerekir
