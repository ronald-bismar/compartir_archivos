import 'dart:async';

import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class FileTransferService {
  final FlutterP2pConnection _p2pConnection = FlutterP2pConnection();
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  Future<void> initialize() async {
    await _p2pConnection.initialize();
    await _p2pConnection.register();
    _streamWifiInfo = _p2pConnection.streamWifiP2PInfo().listen((event) {
      // Manejar cambios en la conexión
    });
    _streamPeers = _p2pConnection.streamPeers().listen((event) {
      // Manejar dispositivos descubiertos
    });
  }

  void dispose() {
    _p2pConnection.unregister();
    _streamWifiInfo?.cancel();
    _streamPeers?.cancel();
  }

  void discoverDevices() {
    _p2pConnection.discover();
  }

  Future<void> connectToDevice(String deviceAddress) async {
    await _p2pConnection.connect(deviceAddress);
  }

  Future<void> startSocket() async {
    WifiP2PGroupInfo? wifiP2PInfo = await _p2pConnection.groupInfo();
    if (wifiP2PInfo != null) {
      await _p2pConnection.startSocket(
        groupOwnerAddress: wifiP2PInfo.groupOwnerAddress!,
        downloadPath: "/storage/emulated/0/Download/",
        receiveString: (dynamic value) {
          // Handle the received value here
          print("Received: $value");
        },
        onConnect: (name, address) {
          print("$name conectado al socket con dirección: $address");
        },
        transferUpdate: (transfer) {
          print(
              "Transferencia: ${transfer.filename}, Progreso: ${transfer.count}/${transfer.total}");
        },
      );
    }
  }

  Future<void> sendFile(String filePath) async {
    List<TransferUpdate>? updates =
        await _p2pConnection.sendFiletoSocket([filePath]);
    if (updates != null) {
      print("Archivo enviado exitosamente");
    } else {
      print("Error al enviar el archivo");
    }
  }

  void closeSocket() {
    _p2pConnection.closeSocket();
  }
}
