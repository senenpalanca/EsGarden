# EsGarden Android App

La aplicación desarrollada en este repositorio forma parte del proyecto educativo  “eSchoolGarden: School Gardens for Future Citizens” (Erasmus+ 2018-ES01-KA201-050599), que trata de educar en valores de sostenibilidad, eficiencia y respeto por el medio ambiente a los estudiantes de distintas partes del mundo por medio de tecnologías aplicables en un jardín. Se pueden consultar todos los detalles del proyecto a través del siguiente link: https://esgarden.blogs.upv.es/

El sistema desarrollado permite visualizar en tiempo real el estado de los múltiples jardines, divididos en parcelas. Además, ofrece una serie de gráficas que facilitan el entendimiento de los cambios que se producen y que son detectados por los sensores. 

<img src="images/Capt5.png" width=200>     <img src="images/Capt6.png" width=200>       <img src="images/Capt7.png" width=200>       <img src="images/Capt8.png" width=200>

<img src="images/Capt9.png" width=200>     <img src="images/Capt10.png" width=200>       <img src="images/Capt11.png" width=200>      

<img src="images/qr.png" width=200>

## Requisitos

Esta aplicación se ha desarrollado en Flutter con Android Studio. Por ello, para poder trabajar con el proyecto, siga las instrucciones del siguiente Link para instalar Flutter en Android Studio: https://flutter.dev/docs/get-started/editor?tab=androidstudio.

La integración con Firebase es esencial para el correcto funcionamiento de la aplicación. Para ello será necesario crear un usuario y un proyecto de Base de datos en Firebase, como se describe en el siguiente tutorial: << Falta link >>. Después, habrá que importar el modelo funcional en formato .json a la base de datos, que simplemente se realizará desde la base de datos de Firebase recién creada, en la esquina superior derecha, en el menú de configuración de esta. Aquí aparecerá una opción llamada "Import Json". Seleccione el archivo .json correspondiente y habrá importado correctamente la base de datos.


# EsGarden Android App [ENGLISH]

The app developed in this repository is part of the educational project “eSchoolGarden: School Gardens for Future Citizens” (Erasmus+ 2018-ES01-KA201-050599), which aims to educate students around Europe in values of sustainability and respect for the environment through STI technologies applicable in a school or urban garden. More details of the project can be found at the following link: http://esgarden.webs.upv.es/

The system developed in Android Studio allows the state of multiple gardens, divided into spaces, to be viewed in real time. Each space includes various useful sensors and offers measurement graphs in the form of daily graphs. Maximum, minimum, and average values are highlighted on each graph. Login is offered to superusers who may add and delete spaces as well as add alerts. Non-privileged users start by just clicking the “Sign in” button to view the spaces and graphs without altering the data stored in the database.

<img src="images/Capt5.png" width=200>     <img src="images/Capt6.png" width=200>       <img src="images/Capt7.png" width=200>       <img src="images/Capt8.png" width=200>

<img src="images/Capt9.png" width=200>     <img src="images/Capt10.png" width=200>       <img src="images/Capt11.png" width=200>      

<img src="images/qr.png" width=200>

## Requeriments

Flutter, Google’s UI resource to enable the reading of data stored in the Google Firebase real-time database. Syncfusion library (https://www.syncfusion.com/) is provided for zoom and graphs options.

Send your data to Firebase from your IoT devices. Data must be uploaded into spaces: "General", "Nursery", "Compost", or "plot 1", … , "plot n". Use paths as "/Gardens/My_garden/sensorData/plot1/Data/".

Upload the app to Google Play with a package name according to your project settings in Firebase. Add a suitable google-service .json file in android > app file for security requests.
