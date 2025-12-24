// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 0;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      id: fields[0] as int,
      stationName: fields[1] as String?,
      geolocationName: fields[25] as String?,
      country: fields[26] as String?,
      temperature: (fields[3] as num?)?.toDouble(),
      feelsLike: (fields[4] as num?)?.toDouble(),
      minTemp: (fields[5] as num?)?.toDouble(),
      maxTemp: (fields[6] as num?)?.toDouble(),
      condition: fields[7] as String?,
      description: fields[8] as String?,
      iconCode: fields[9] as String?,
      humidity: fields[10] as int?,
      windSpeed: (fields[11] as num?)?.toDouble(),
      windDeg: (fields[12] as num?)?.toDouble(),
      visibility: fields[13] as int?,
      pressure: fields[14] as int?,
      sunrise: fields[15] as int?,
      sunset: fields[16] as int?,
      timestamp: fields[17] as int?,
      latitude: (fields[18] as num?)?.toDouble(),
      longitude: (fields[19] as num?)?.toDouble(),
      cloudiness: fields[20] as int?,
      seaLevel: fields[21] as int?,
      grndLevel: fields[22] as int?,
      lastFetched: fields[23] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stationName)
      ..writeByte(25)
      ..write(obj.geolocationName)
      ..writeByte(26)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.feelsLike)
      ..writeByte(5)
      ..write(obj.minTemp)
      ..writeByte(6)
      ..write(obj.maxTemp)
      ..writeByte(7)
      ..write(obj.condition)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.iconCode)
      ..writeByte(10)
      ..write(obj.humidity)
      ..writeByte(11)
      ..write(obj.windSpeed)
      ..writeByte(12)
      ..write(obj.windDeg)
      ..writeByte(13)
      ..write(obj.visibility)
      ..writeByte(14)
      ..write(obj.pressure)
      ..writeByte(15)
      ..write(obj.sunrise)
      ..writeByte(16)
      ..write(obj.sunset)
      ..writeByte(17)
      ..write(obj.timestamp)
      ..writeByte(18)
      ..write(obj.latitude)
      ..writeByte(19)
      ..write(obj.longitude)
      ..writeByte(20)
      ..write(obj.cloudiness)
      ..writeByte(21)
      ..write(obj.seaLevel)
      ..writeByte(22)
      ..write(obj.grndLevel)
      ..writeByte(23)
      ..write(obj.lastFetched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
