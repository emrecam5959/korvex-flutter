#!/usr/bin/env python3
"""
Korvex File Manager - WebSocket Proxy
TCP sunucusu ile web uygulaması arasında köprü görevi görür
"""

import asyncio
import websockets
import json
import sys
from datetime import datetime

# Yapılandırma
TCP_HOST = 'localhost'
TCP_PORT = 5555
WS_HOST = '0.0.0.0'
WS_PORT = 5556

def log(message):
    """Log mesajı yazdır"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")

async def proxy_handler(websocket, path):
    """WebSocket bağlantısını TCP sunucusuna yönlendir"""
    client_addr = websocket.remote_address
    log(f"Yeni WebSocket bağlantısı: {client_addr}")
    
    try:
        # TCP sunucusuna bağlan
        reader, writer = await asyncio.open_connection(TCP_HOST, TCP_PORT)
        log(f"TCP sunucusuna bağlandı: {TCP_HOST}:{TCP_PORT}")
        
        async def forward_from_ws():
            """WebSocket'ten gelen mesajları TCP'ye gönder"""
            try:
                async for message in websocket:
                    log(f"WebSocket'ten gelen mesaj: {message[:100]}...")
                    writer.write(message.encode() + b'\n')
                    await writer.drain()
            except Exception as e:
                log(f"WebSocket okuma hatası: {e}")
        
        async def forward_to_ws():
            """TCP'den gelen mesajları WebSocket'e gönder"""
            try:
                while True:
                    data = await reader.read(4096)
                    if not data:
                        log("TCP bağlantısı kapatıldı")
                        break
                    message = data.decode('utf-8', errors='ignore').strip()
                    if message:
                        log(f"TCP'den gelen mesaj: {message[:100]}...")
                        await websocket.send(message)
            except Exception as e:
                log(f"TCP okuma hatası: {e}")
        
        # Her iki yönü eşzamanlı olarak işle
        await asyncio.gather(forward_from_ws(), forward_to_ws())
    
    except ConnectionRefusedError:
        log(f"TCP sunucusuna bağlanılamadı: {TCP_HOST}:{TCP_PORT}")
        await websocket.send(json.dumps({
            "status": "error",
            "message": "Sunucuya bağlanılamadı"
        }))
    except Exception as e:
        log(f"Proxy hatası: {e}")
    finally:
        try:
            writer.close()
            await writer.wait_closed()
        except:
            pass
        log(f"WebSocket bağlantısı kapatıldı: {client_addr}")

async def main():
    """WebSocket sunucusunu başlat"""
    log(f"Korvex WebSocket Proxy başlatılıyor...")
    log(f"WebSocket dinleme adresi: {WS_HOST}:{WS_PORT}")
    log(f"TCP sunucusu adresi: {TCP_HOST}:{TCP_PORT}")
    
    try:
        async with websockets.serve(proxy_handler, WS_HOST, WS_PORT):
            log("WebSocket Proxy başlatıldı. Bağlantıları bekliyorum...")
            await asyncio.Future()  # Sonsuza kadar çalış
    except OSError as e:
        log(f"Port açılamadı: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        log("Proxy kapatılıyor...")
        sys.exit(0)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        log("Proxy kapatıldı")
