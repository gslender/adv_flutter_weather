class AdvWeatherData {
  final String countryCode;
  final String cityName;
  final double lon;
  final double lat;
  final int humidity;
  final int pressure;
  final double tempMax;
  final double tempMin;
  final double feelsLike;
  final double currentTemperature;
  final int weatherID;
  final String weatherLongDescription;
  final String weatherShortDescription;

  AdvWeatherData({
    this.countryCode = 'GB',
    this.cityName = '',
    this.lon = 0,
    this.lat = 0,
    this.humidity = 0,
    this.pressure = 0,
    this.tempMax = 0,
    this.tempMin = 0,
    this.feelsLike = 0,
    this.currentTemperature = 0,
    this.weatherID = 0,
    this.weatherLongDescription = '',
    this.weatherShortDescription = '',
  });
}

enum TempScale { kelvin, celsius, fahrenheit }
