import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';

class Memory {
  Memory._() {
    initialize();
  }
  static final singleton = Memory._();

  final int instrWordAddressBegin = 0x00;
  final int instrWordAddressLimit = 0x3f;
  final int dynamicWordAddressBegin = 0x40;
  final int dynamicWordAddressLimit = 0x6f;
  bool memAddressOnInstrSpace(Data memAddress) {
    final wordAddress = memAddress.asSignedInt() >> 2;
    return (wordAddress.toUnsigned(32) >= instrWordAddressBegin &&
        wordAddress.toUnsigned(32) <= instrWordAddressLimit);
  }

  List<List<Data>> byteMemory = [];

  void initialize() {
    byteMemory = List.generate(
      0x70,
      (_) => List.generate(4, (_) => (Data.byteZero())),
    );
  }

  void reset() {
    initialize();
  }

  void _setByte(Data newByte, Data storeAddress) {
    int getMemoryWordAddress = storeAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress = storeAddress.asUnsignedInt() & 0x3;

    byteMemory[getMemoryWordAddress][getMemoryByteAddress] = newByte;
  }

  void storeByte(Data newByte, Data memoryAddress) {
    final byte = newByte.byteList[0];
    _setByte(byte, memoryAddress);
  }

  void storeHalf(Data newHalf, Data memoryAddress) {
    bool addressNotDivBy2 = (memoryAddress.asUnsignedInt() & 0x1) != 0;
    if (addressNotDivBy2) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asUnsignedHexString(8)}).",
      );
    }

    final halfWordByteLength = 2;
    for (int i = 0; i < halfWordByteLength; i++) {
      final byte = newHalf.byteList[i];
      final iterAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      _setByte(byte, iterAddress);
    }
  }

  void storeWord(Data newWord, Data memoryAddress) {
    bool addressNotDivBy4 = (memoryAddress.asUnsignedInt() & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asUnsignedHexString(6)}).",
      );
    }

    final wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final byte = newWord.byteList[i];
      final iterAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      _setByte(byte, iterAddress);
    }
  }

  void storeInstruction(Data newWord, Data address) {
    if (!memAddressOnInstrSpace(address)) {
      debugPrint(
        "  --> INSTRUCTION STORE ON ADDRESS: 0x${address.asUnsignedHexString(6)} IS INVALID!"
        "\n      --> InstrSpace ends at 0x${instrWordAddressLimit}00",
      );
      return;
    }

    storeWord(newWord, address);
  }

  Data loadWord(Data memoryAddress) {
    int getMemoryWordAddress(Data memAddress) =>
        memAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress(Data memAddress) =>
        memAddress.asUnsignedInt() & 0x3;

    late final Data newWord;
    List<Data> bytes = [];
    final int wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final iterMemoryAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      final iterWordAddress = getMemoryWordAddress(iterMemoryAddress);
      final iterByteAddress = getMemoryByteAddress(iterMemoryAddress);
      final byte = byteMemory[iterWordAddress][iterByteAddress];
      bytes.add(byte);
    }
    newWord = Data.wordFromBytes(bytes);

    return newWord;
  }

  Data _loadHalf(Data memoryAddress) {
    int getMemoryWordAddress(Data memAddress) =>
        memAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress(Data memAddress) =>
        memAddress.asUnsignedInt() & 0x3;

    late final Data newWord;
    List<Data> bytes = [];
    final int halfByteLength = 2;
    for (int i = 0; i < halfByteLength; i++) {
      final iterMemoryAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      final iterWordAddress = getMemoryWordAddress(iterMemoryAddress);
      final iterByteAddress = getMemoryByteAddress(iterMemoryAddress);
      final byte = byteMemory[iterWordAddress][iterByteAddress];
      bytes.add(byte);
    }
    bytes.add(Data.byteZero());
    bytes.add(Data.byteZero());
    newWord = Data.wordFromBytes(bytes);

    return newWord;
  }

  Data loadHalfSigned(Data memoryAddress) {
    final half = _loadHalf(memoryAddress);
    return Data.halfWord(half.asSignedInt());
  }

  Data loadHalfUnsigned(Data memoryAddress) {
    final half = _loadHalf(memoryAddress);
    return Data.halfWord(half.asSignedInt());
  }

  Data _loadByte(Data memoryAddress) {
    int getMemoryWordAddress(Data memAddress) =>
        memAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress(Data memAddress) =>
        memAddress.asUnsignedInt() & 0x3;

    late final Data newByte;

    final iterWordAddress = getMemoryWordAddress(memoryAddress);
    final iterByteAddress = getMemoryByteAddress(memoryAddress);
    final byte = byteMemory[iterWordAddress][iterByteAddress];
    newByte = Data(signedInt: byte.signedInt, dataType: DataType.byte);

    return newByte;
  }

  Data loadByteSigned(Data memoryAddress) {
    final byte = _loadByte(memoryAddress);
    return Data.byte(byte.asSignedInt());
  }

  Data loadByteUnsigned(Data memoryAddress) {
    final byte = _loadByte(memoryAddress);
    return Data.byte(byte.asUnsignedInt());
  }
}
