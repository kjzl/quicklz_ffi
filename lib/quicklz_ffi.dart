library quicklz_ffi;

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart';
import 'package:quicklz_ffi/src/generated_bindings.dart';

class QuickLZ {
  static String _getPath() {
    if (Platform.isWindows) {
      return join(Directory.current.absolute.path, 'native/quicklz.dll');
    } else {
      throw UnsupportedError("Currently only Windows is supported!");
    }
  }

  static final QuickLZBindings _quickLZBindings =
  QuickLZBindings(DynamicLibrary.open(_getPath()));

  /// Reads the header (first 9 bytes) of [compressed] and returns its decompressed size.
  ///
  /// The function can be used to allocate the correct amount of memory for decompression.
  static int sizeDecompressed(Uint8List compressed) {
    Pointer<Uint8> pCompressed = malloc<Uint8>(compressed.length);
    pCompressed.asTypedList(compressed.length).setAll(0, compressed);
    int size = _quickLZBindings.qlz_size_decompressed(pCompressed.cast<Char>());
    malloc.free(pCompressed);
    return size;
  }

  /// Reads the header (first 9 bytes) of [compressed] and returns its entire compressed size.
  ///
  /// The function can be used to read a block of compressed data from a file or storage device in cases where the size of the block is unknown.
  static int sizeCompressed(Uint8List compressed) {
    Pointer<Uint8> pCompressed = malloc<Uint8>(compressed.length);
    pCompressed.asTypedList(compressed.length).setAll(0, compressed);
    int size = _quickLZBindings.qlz_size_compressed(pCompressed.cast<Char>());
    malloc.free(pCompressed);
    return size;
  }

  static Uint8List compress(Uint8List original) {
    Pointer<qlz_state_compress> stateCompress =
    malloc<qlz_state_compress>(_quickLZBindings.qlz_get_setting(1));

    Pointer<Uint8> pOriginal = malloc<Uint8>(original.length);
    pOriginal.asTypedList(original.length).setAll(0, original);

    // Always allocate size + 400 bytes for the destination buffer when compressing.
    Pointer<Char> compressed = malloc<Char>(original.length + 400);

    int compressedSize = _quickLZBindings.qlz_compress(
        pOriginal.cast<Void>(), compressed, original.length, stateCompress);

    Uint8List dartCompressed = Uint8List.fromList(
        compressed.cast<Uint8>().asTypedList(compressedSize));

    malloc.free(stateCompress);
    malloc.free(pOriginal);
    malloc.free(compressed);
    return dartCompressed;
  }

  static Uint8List decompress(Uint8List compressed) {
    Pointer<qlz_state_decompress> stateDecompress =
    malloc<qlz_state_decompress>(_quickLZBindings.qlz_get_setting(2));

    Pointer<Char> pCompressed = malloc<Char>(compressed.length);
    pCompressed.cast<Uint8>().asTypedList(compressed.length).setAll(0, compressed);

    Pointer<Uint8> decompressed = malloc<Uint8>(_quickLZBindings.qlz_size_decompressed(pCompressed));

    int decompressedSize = _quickLZBindings.qlz_decompress(
        pCompressed, decompressed.cast<Void>(), stateDecompress);

    Uint8List dartDecompressed = Uint8List.fromList(
        decompressed.asTypedList(decompressedSize));

    malloc.free(stateDecompress);
    malloc.free(pCompressed);
    malloc.free(decompressed);
    return dartDecompressed;
  }
}

