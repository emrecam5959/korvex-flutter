# Korvex File Manager - Web Sürümü Kurulumu

## Genel Bakış

Flutter web sürümü, tarayıcıda Korvex File Manager uygulamasını çalıştırmanıza olanak sağlar. Web sürümü, masaüstü bilgisayardan WiFi ağı üzerinden dosya yönetimi yapmanızı sağlar.

## Sistem Gereksinimleri

- Flutter SDK (3.10.0 veya üzeri)
- Chrome, Firefox, Safari veya Edge tarayıcı
- Korvex Sunucu (Windows'ta çalışan)
- Aynı WiFi ağında bağlantı

## Web Sürümü Kurulumu

### 1. Bağımlılıkları Yükle

```bash
cd korvex_flutter
flutter pub get
```

### 2. Web Sürümünü Çalıştır

```bash
flutter run -d chrome
```

Veya Firefox kullanmak için:

```bash
flutter run -d firefox
```

### 3. Tarayıcıda Açılacak

Uygulama otomatik olarak tarayıcıda açılacak. Eğer açılmazsa, tarayıcıda şu adresi açın:

```
http://localhost:5000
```

## Kullanım

### Sunucu Bağlantısı

1. Uygulamayı açtığınızda, sunucu IP adresi ve port bilgisini girmeniz istenecek
2. Sunucu IP adresi: Windows bilgisayarınızın IP adresi (örn: 192.168.1.100)
3. Port: 5555 (varsayılan)
4. Şifre: Sunucuda ayarladığınız şifre

### Dosya İşlemleri

- **Klasör Oluşturma**: "Yeni Klasör" butonuna tıklayın
- **Dosya Yükleme**: "Dosya Yükle" butonuna tıklayın
- **Dosya Silme**: Dosyaya sağ tıklayın ve "Sil" seçeneğini seçin
- **Dosya Taşıma**: Dosyaya sağ tıklayın ve "Taşı" seçeneğini seçin
- **Dosya Yeniden Adlandırma**: Dosyaya sağ tıklayın ve "Yeniden Adlandır" seçeneğini seçin

## Sorun Giderme

### "Sunucuya bağlanılamadı" Hatası

1. Sunucunun çalışıp çalışmadığını kontrol edin
2. IP adresi ve port bilgisinin doğru olduğunu kontrol edin
3. Firewall ayarlarını kontrol edin
4. Aynı WiFi ağında olduğunuzu kontrol edin

### "Şifre yanlış" Hatası

1. Şifrenin doğru olduğunu kontrol edin
2. Sunucuyu yeniden başlatın
3. Uygulamayı yeniden başlatın

### Dosya Yükleme Sorunu

1. Hedef klasörün yazılabilir olduğunu kontrol edin
2. Disk alanının yeterli olduğunu kontrol edin
3. Dosya boyutunun 2 GB'dan küçük olduğunu kontrol edin

## Web Sürümü Sınırlamaları

- **Dosya Seçimi**: Web tarayıcısı güvenlik nedeniyle dosya sistemi erişimini sınırlar
- **Kamera**: Web sürümünde kamera desteği tarayıcı tarafından sınırlanır
- **Galeri**: Web sürümünde galeri erişimi tarayıcı tarafından sınırlanır
- **Dosya Boyutu**: Tarayıcı bellek sınırlaması nedeniyle büyük dosyalar sorun yaşayabilir

## Derleme (Production)

Web sürümünü production için derlemek için:

```bash
flutter build web --release
```

Derlenen dosyalar `build/web/` klasöründe bulunur.

## Deployment

Web sürümünü bir web sunucusunda yayınlamak için:

1. `build/web/` klasörünün içeriğini web sunucusuna yükleyin
2. Web sunucusunu yapılandırın
3. Tarayıcıda erişin

Örnek: Nginx, Apache, IIS vb.

## Notlar

- Web sürümü, masaüstü bilgisayardan dosya yönetimi için optimize edilmiştir
- Mobil tarayıcılarda da çalışır ancak masaüstü deneyimi daha iyidir
- Web sürümü, Android ve iOS sürümleriyle aynı özellikleri sağlar
