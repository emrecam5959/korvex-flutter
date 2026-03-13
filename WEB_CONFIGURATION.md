# Korvex File Manager - Web Sürümü Yapılandırması

## Sunucu Yapılandırması

Web sürümü, mevcut Korvex Sunucu ile uyumludur. Ancak, WebSocket desteği eklemek için sunucuyu güncellemek önerilir.

### Seçenek 1: Mevcut TCP Sunucusu Kullanma (Basit)

Mevcut TCP sunucusu, web uygulaması tarafından doğrudan kullanılamaz çünkü tarayıcılar güvenlik nedeniyle raw TCP bağlantılarına izin vermez.

### Seçenek 2: WebSocket Proxy Oluşturma (Önerilen)

WebSocket proxy, TCP sunucusu ile web uygulaması arasında köprü görevi görür.

#### Python WebSocket Proxy Örneği

```python
# websocket_proxy.py
import asyncio
import websockets
import json
import socket

async def proxy_handler(websocket, path):
    """WebSocket bağlantısını TCP sunucusuna yönlendir"""
    try:
        # TCP sunucusuna bağlan
        reader, writer = await asyncio.open_connection('localhost', 5555)
        
        async def forward_from_ws():
            """WebSocket'ten gelen mesajları TCP'ye gönder"""
            async for message in websocket:
                writer.write(message.encode() + b'\n')
                await writer.drain()
        
        async def forward_to_ws():
            """TCP'den gelen mesajları WebSocket'e gönder"""
            while True:
                data = await reader.read(4096)
                if not data:
                    break
                await websocket.send(data.decode())
        
        # Her iki yönü eşzamanlı olarak işle
        await asyncio.gather(forward_from_ws(), forward_to_ws())
    
    except Exception as e:
        print(f"Proxy hatası: {e}")
    finally:
        writer.close()
        await writer.wait_closed()

async def main():
    """WebSocket sunucusunu başlat"""
    async with websockets.serve(proxy_handler, "0.0.0.0", 5556):
        print("WebSocket Proxy başlatıldı. Port: 5556")
        await asyncio.Future()  # Sonsuza kadar çalış

if __name__ == "__main__":
    asyncio.run(main())
```

#### Proxy'yi Çalıştırma

```bash
pip install websockets
python websocket_proxy.py
```

### Seçenek 3: HTTP API Oluşturma (Gelişmiş)

HTTP API, REST endpoint'leri sağlayarak web uygulamasının sunucuyla iletişim kurmasını sağlar.

#### Java Spring Boot HTTP API Örneği

```java
// KorvexHttpServer.java
@RestController
@RequestMapping("/api")
public class KorvexHttpServer {
    
    private KorvexServer korvexServer;
    
    @PostMapping("/command")
    public ResponseEntity<?> executeCommand(@RequestBody Map<String, Object> request) {
        try {
            // TCP sunucusuna komut gönder
            String response = korvexServer.executeCommand(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
    }
}
```

## Web Uygulaması Yapılandırması

### 1. Sunucu Adresi Yapılandırması

Web uygulaması başladığında, sunucu adresi ve port bilgisini girmeniz istenecek.

**Varsayılan Değerler:**
- Host: `localhost` (yerel bilgisayar)
- Port: `5556` (WebSocket proxy portu)

### 2. Çapraz Kaynak Paylaşımı (CORS)

Web uygulaması farklı bir kaynaktan sunucuya erişiyorsa, CORS yapılandırması gerekebilir.

#### Sunucu Tarafında CORS Yapılandırması

```java
// Spring Boot örneği
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins("*")
                    .allowedMethods("GET", "POST", "PUT", "DELETE")
                    .allowedHeaders("*");
            }
        };
    }
}
```

## Dağıtım (Deployment)

### Yerel Geliştirme

```bash
# Terminal 1: Korvex Sunucusu
cd korvex-server
java -jar korvex-server-1.0.0.jar

# Terminal 2: WebSocket Proxy (isteğe bağlı)
python websocket_proxy.py

# Terminal 3: Flutter Web Uygulaması
cd korvex_flutter
flutter run -d chrome
```

### Production Dağıtımı

1. **Sunucu Dağıtımı**
   - Korvex Sunucusunu Windows hizmetine dönüştür
   - WebSocket Proxy'yi systemd hizmetine dönüştür

2. **Web Uygulaması Dağıtımı**
   ```bash
   flutter build web --release
   ```
   - `build/web/` klasörünü web sunucusuna yükle
   - Nginx, Apache veya IIS yapılandır

3. **Güvenlik**
   - HTTPS kullan
   - WSS (WebSocket Secure) kullan
   - Firewall kurallarını yapılandır

## Sorun Giderme

### WebSocket Bağlantısı Başarısız

1. WebSocket Proxy'nin çalışıp çalışmadığını kontrol edin
2. Port 5556'nın açık olduğunu kontrol edin
3. Firewall ayarlarını kontrol edin

### CORS Hatası

1. Sunucu CORS yapılandırmasını kontrol edin
2. İstemci kaynağını sunucu izin listesine ekleyin

### Bağlantı Zaman Aşımı

1. Sunucunun çalışıp çalışmadığını kontrol edin
2. Ağ bağlantısını kontrol edin
3. Timeout değerini artırın

## Notlar

- Web sürümü, masaüstü bilgisayardan dosya yönetimi için optimize edilmiştir
- WebSocket Proxy, TCP sunucusu ile web uygulaması arasında köprü görevi görür
- HTTP API, daha gelişmiş bir çözüm sağlar ancak daha fazla geliştirme gerektirir
