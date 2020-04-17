library globals;

import "package:esgarden/Structure/CatalogItem.dart";
import "package:esgarden/Structure/Orchard.dart";

bool isLogged = false;
bool isAdmin;

List<Orchard> orchards = new List();
List<CatalogItem> catalog = new List();
List months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

const Map<String, String> CATALOG_TYPES = const {
  "luminosity": "00",
  "ambienttemperature": "01",
  "ambienthumidity": "02",
  "ph": "03",
  "relativenoise": "04",
  "co2": "05",
  "rainfall": "06",
  "wind": "07",
  "soiltemperature": "08",
  "soilhumidity": "09",
};

const Map<String, String> CATALOG_NAMES = const {
  //AMBIENTE2
  "00": "Luminosity", //Luminosidad
  "01": "Ambient Temperature", //Temp ambiente
  "02": "Ambient Humidity", //Hum. ambiente
  "03": "PH", //PH
  "04": "Relative Noise", //Ruido relativo
  "05": "Air Quality", //Calidad del aire
  "06": "Rainfall", //Pluviometría
  "07": "Wind", //Viento
  //PLOTS
  "08": "Soil Temperature", // Temp suelo, hum suelo,
  "09": "Soil Humidity" // Temp suelo, hum suelo,
};

const Map<String, String> MEASURING_UNITS = const {
  "upperhumidity": "%",
  "lowerhumidity": "%",
  "co2": "PPM",
  "ph": "",
  "soiltemperature": "º C",
  "soilhumidity": "%",
  "luminosity": "Lux",
  "ambienttemperature": "º C",
  "ambienthumidity": "%",
  "relativenoise": " units"
};

const Map<String, List<String>> VALUE_RELATION = const {
  "soilhumidity": [
    "upperhumidity",
    "middleupperhumidity",
    "middlelowerhumidity",
    "lowerhumidity"
  ],
  "soiltemperature": [
    "uppertemperature",
    "middleuppertemperature",
    "middlelowertemperature",
    "lowertemperature"
  ],
};

/*
const Map<String, String> CATALOG_TYPES = const {
  "soilhumidity": "00",
  "upperhumidity": "01",
  "lowerhumidity": "02",
  "co2": "03",
  "rainfall": "04",
  "luminosity": "05",
  "ambienttemperature": "06",
  "relativenoise": "07",
  "ambienthumidity": "08",
};

const Map<String, String> CATALOG_NAMES_OLD = const {
  "00": "Soil Humidity",
  "01": "Upper Humidity",
  "02": "Lower Humidity",
  "03": "Air Quality",
  "04": "Soil Temperature",
  "05": "Luminosity",
  "06": "Ambient Temperature",
  "07": "Relative Noise",
  "08": "Ambient Humidity"
};
*/
