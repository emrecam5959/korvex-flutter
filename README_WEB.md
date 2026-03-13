# Korvex File Manager - Web Sürümü

Flutter web sürümü, tarayıcıda Korvex File Manager uygulamasını çalıştırmanıza olanak sağlar.

## Hızlı Başlangıç

### 1. Sunucuyu Başlat
```bash
cd korvex-server
java -jar korvex-server-1.0.0.jar
```

### 2. WebSocket Proxy'yi Başlat
```bash
cd korvex_flutter
pip install websockets
python websocket_proxy.py
```

### 3. Web Uygulamasını Çalıştır
```bash
cd korvex_flutter
flutter run -d chrome
```

## Yapılandırma

- **Host**: localhost (veya bilgisayarınızın IP adresi)
- **Port**: 5556 (WebSocket proxy portu)
- **Şifre**: Sunucuda ayarladığınız şifre

## Dosyalar

- `WEB_SETUP.md` - Detaylı kurulum rehberi
- `WEB_QUICKSTART.md` - Hızlı başlangıç rehberi
- `WEB_CONFIGURATION.md` - Yapılandırma detayları
- `websocket_proxy.py` - WebSocket proxy sunucusu

## Notlar

- Web sürümü, masaüstü bilgisayardan dosya yönetimi için optimize edilmiştir
- WebSocket Proxy, TCP sunucusu ile web uygulaması arasında köprü görevi görür
- Aynı WiFi ağında olmanız gerekir
