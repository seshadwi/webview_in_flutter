# Flutter Webview

## Langkah Praktikum 

### Getting Started

1. Membuat project baru

   `flutter create webview_in_flutter`

2. Menambahkan plugin pada dependency

   `flutter pub add webview_flutter`
   
### Menambahkan Widget Webview 

Pada langkah praktikum ini ditambahkan plugin `WebView` agar aplikasi dapat memuat halaman website. 

![screenshot](images/01.png)  

### Listening for page load events

Pada langkah praktikum ini menambahkan loading bar pada aplikasi, untuk mengetahuinya pada saat aplikaksi di load, maka akan muncul loading yang berbentuk garis lurus. 

### Accessing the WebViewController from the WebView Widget

Praktikum ini dilakukan akses WebViewController melalui widget Webview yang didalamnya terdapat beberapa control navigasi yang terletak pada AppBar.

![screenshot](images/02.png) 

### Keeping track of navigation with NavigationDelegate

NavigationDelegate digunakan untuk melakukan control navigasi yang terdapat pada webview, sebagai contoh ketika user melakukan klik pada sebuah link, maka NavigationDelegate dipanggil, ada beberapa perintah seperti `prevent` digunakan untuk melakukan blocking, dan `navigate` digunakan untuk melanjutkan navigasi. 

| <!-- -->                      | <!-- -->                     |
| -------------                 | -------------                |
| ![screenshot](images/03.png)  | ![screenshot](images/04.png) |

### Evaluating Javascript

`WebViewController` dapat melakukan pengecekan pada Javascript expressions didalam konteks pada halaman terkini. Ada dua cara unutk melakukan evaluasi pada JavaScript, yang pertama `runJavaScript` jika terdapat return value dan `runJavaScriptReturningResult` jika tidak memiliki return value.  

| <!-- -->                      | <!-- -->                     |
| -------------                 | -------------                |
| ![screenshot](images/05.png)  | ![screenshot](images/06.png) |

### Working With JavaScript Channel 

`JavaScriptChannel` digunakan untuk melakukan komunikasi dari kode JavaScript ke Flutter. Pada langkah praktikum ini dilakukan request ke Public IP Address API, dan me-return alamat IP Address perangkat. Hasilnya adalah menampilkan IP Address berupa `snackbar` dengan meng-invoke `postMessage` pada `snacbar` `JavaScriptChannel`.













