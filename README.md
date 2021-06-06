# DzikBook
## Spis treści
* [Technologie](#technologie)
* [Głowne informacje](#głowne-informacje)
* [Opis Aplikacji](#opis-aplikacji)

	

## Technologie
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Python.svg/768px-Python.svg.png" alt="drawing" height=80px/>
<img src="https://www.djangoproject.com/m/img/logos/django-logo-negative.png" alt="drawing" height=80px/>
<img src="https://miro.medium.com/proxy/1*N5Iep1wJY1iXgMzpHxzE8w.png" alt="drawing" height=80px/>
<img src="https://miro.medium.com/max/1024/1*xP2U5u21teQMEZ7NFzC-Hw.png" alt="drawing" height=80px/>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Cassandra_logo.svg/220px-Cassandra_logo.svg.png" alt="drawing" height=80px/>
<br/>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/220px-Google-flutter-logo.svg.png" alt="drawing" height=80px/> 
<br/>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Visual_Studio_Code_1.35_icon.svg/768px-Visual_Studio_Code_1.35_icon.svg.png" height=80px/> 
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/GitLab_Logo.svg/1108px-GitLab_Logo.svg.png" height=80px/> 



## Głowne informacje
Projekt studencki tworzony w ramach kursu Programowanie Zespołowe

Tworzony przez:
* [Igor Cichecki](https://github.com/regin123)
* [Michał Janik](https://github.com/mihal09)
* [Maciej Lewandowicz](https://github.com/sasuke5055)
* [Paweł Kubala](https://github.com/Kubciooo)
* [Aleksandra Romanowska]()
* [Piotr Szymański](https://github.com/PitiMonster)




## Opis Aplikacji
Celem projektu było stworzenie medium społecznościowego dla grupy identyfikującej się ze sportem.
Backend został stworzony z wykorzystaniem Django, frontend z wykorzystaniem Fluttera. 

W trakcie trwania kursu zaimplementowane zostało:
* Autentykacja użytkowników
* Profil użytkownika, tablica z jego postami
* Posty zawierające tekst, zdjęcia, plany treningowe itp
* System zaproszeń - wysyłanie, akceptowanie, odrzucanie zaproszeń do znajomych, relacje między użytkownikami
* Obsługa powiadomień push za pośrednictwem Firebase Cloud Messaging
* Obsługę rejestracji użytkowników, zmianę haseł, logowanie do systemu


Częśc backendowa stworzona została z myślą o rozbiciu systemu na mniejsze części. Architektura projektu umożliwa rozbicie backendu na niezależne aplikacje komunikujące się między sobą
gdy najdzie taka konieczność za pośrednictwem architektury REST. Umożliwia to przechowywanie danych konkretnych mikroserwisów na różnych bazach danych i w róznych miejscach. W ramach kursu udało nam się 
wykorzystac także rozproszoną bazę danych [Cassandra](https://gitlab.com/sasuke5055/dzikbook/-/tree/31-dzik-53-cassandra-integration/backend/dzikbook/dzikbook/settings).
