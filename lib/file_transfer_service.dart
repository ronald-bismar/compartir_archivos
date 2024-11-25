import 'dart:async';

import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:nearby_connections/nearby_connections.dart';

class FileTransferService {
  final Nearby _nearby = Nearby();
  
  Future<void> startFileTransfer(String receiverId, String filePath) async {
    try {
      await _nearby.startAdvertising(
        'deviceId',
        Strategy.P2P_CLUSTER,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Manejar la conexión iniciada
        },
        onConnectionResult: (String id, Status status) {
          if (status == Status.CONNECTED) {
            // Conexión establecida, iniciar transferencia de archivo
            _sendFile(id, filePath);
          }
        },
        onDisconnected: (String id) {
          // Manejar desconexión
        },
      );
    } catch (e) {
      print('Error al iniciar la transferencia: $e');
    }
  }

  Future<void> _sendFile(String receiverId, String filePath) async {
    try {
      await _nearby.sendFilePayload(receiverId, filePath);
    } catch (e) {
      print('Error al enviar el archivo: $e');
    }
  }
}
