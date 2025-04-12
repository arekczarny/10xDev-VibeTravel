# Dokument wymagań produktu (PRD) - VibeTravels

## 1. Przegląd produktu

VibeTravels to aplikacja webowa wykorzystująca sztuczną inteligencję do zamiany prostych notatek o podróżach w kompleksowe plany wycieczek. Aplikacja jest dedykowana osobom planującym wyjazdy urlopowe, wakacyjne, weekendowe i city breaks, którzy potrzebują pomocy w organizacji swoich podróży.

Aplikacja pozwala użytkownikom:
- Tworzyć i zarządzać notatkami o planowanych wycieczkach
- Zapisywać swoje preferencje turystyczne w profilu użytkownika
- Wykorzystywać sztuczną inteligencję do generowania szczegółowych planów podróży na podstawie notatek i preferencji
- Oceniać wygenerowane plany w celu doskonalenia przyszłych rekomendacji

VibeTravels w wersji MVP będzie dostępny jako aplikacja webowa z interfejsem w języku angielskim, koncentrująca się na dostarczeniu podstawowych funkcji planowania podróży bez zaawansowanych funkcji współdzielenia czy analizy multimediów.

## 2. Problem użytkownika

Planowanie angażujących i interesujących wycieczek jest procesem złożonym i czasochłonnym, wymagającym:
- Researchu miejsc wartych odwiedzenia
- Planowania logistyki transportu
- Uwzględnienia osobistych preferencji i ograniczeń
- Zbierania informacji o lokalnych atrakcjach

Użytkownicy często zapisują swoje pomysły na wycieczkę w formie nieustrukturyzowanych notatek, które trudno przekształcić w konkretny plan działania. Brakuje im narzędzia, które pozwoliłoby przetworzyć te luźne myśli w szczegółowy plan podróży.

VibeTravels rozwiązuje ten problem, wykorzystując potencjał AI do przekształcania prostych notatek w kompleksowe plany podróży, dostosowane do indywidualnych preferencji użytkownika, dostępnego czasu, liczby osób oraz potencjalnych miejsc i atrakcji.

## 3. Wymagania funkcjonalne

### 3.1. System kont użytkowników
- Rejestracja i logowanie użytkowników
- Obowiązkowe tworzenie profilu preferencji turystycznych po rejestracji
- Zapisywanie preferencji dotyczących poziomu aktywności, ulubionych sportów, typu wczasowicza oraz miejsca zamieszkania

### 3.2. Profil użytkownika
- Możliwość wprowadzenia i edycji preferencji turystycznych
- Przechowywanie informacji o poziomie aktywności, ulubionych sportach, typie wczasowicza oraz miejscu zamieszkania
- Historia zaakceptowanych planów podróży

### 3.3. System notatek
- Tworzenie, przeglądanie, edycja i usuwanie notatek o planowanych wycieczkach
- Kategoryzowanie notatek (Letnie wakacje, Wyjazd zimowy, Przygoda, Zwiedzanie, Leniuchowanie, Na Sportowo)
- Możliwość tworzenia notatek w formie dowolnej (sticky note) lub z wykorzystaniem szablonów ze strukturą
- Szablony zawierające pola: kontynent, kraj, pora roku, data, typ zakwaterowania, rodzaj transportu, planowane aktywności, liczba osób

### 3.4. Integracja z AI
- Generowanie szczegółowych planów podróży na podstawie notatek i preferencji użytkownika
- Uruchamianie generowania na żądanie użytkownika lub automatycznie po zebraniu odpowiedniej liczby notatek
- Zapisywanie wygenerowanych planów i udostępnianie ich użytkownikowi do akceptacji lub odrzucenia
- Uwzględnianie historii zaakceptowanych planów przy tworzeniu nowych propozycji

### 3.5. Wygenerowane plany
- Zawieranie kompleksowych informacji: możliwe firmy transportowe linie lotnicze, pociągi, autokary, listę znalezionych miejsc na zakwaterowanie, listę dobranych do preferencji użytkownika wycieczek
- Integracja z Google Maps w formie linków do lokalizacji zawartych w planie
- System oceny planów za pomocą skali gwiazdkowej (1-5)

### 3.6. Dashboard
- Prosty dashboard z podziałem na "Notatki", "Wygenerowane plany" i "Zaakceptowane plany"
- Mechanizm informowania użytkownika o nowo wygenerowanych planach

## 4. Granice produktu

### 4.1. W zakresie MVP:
- Aplikacja webowa z interfejsem w języku angielskim
- System kont użytkowników z profilem preferencji turystycznych
- Tworzenie i zarządzanie notatkami o podróżach
- Generowanie planów podróży przez AI na podstawie notatek i preferencji
- Ocenianie wygenerowanych planów
- Integracja z Google Maps w formie linków

### 4.2. Poza zakresem MVP:
- Wersje mobilne aplikacji
- Współdzielenie planów wycieczkowych między kontami
- Obsługa i analiza multimediów (np. zdjęć miejsc do odwiedzenia)
- Zaawansowane planowanie czasu i logistyki
- Modyfikacja wygenerowanych planów przez użytkownika
- Integracje z zewnętrznymi systemami rezerwacyjnymi
- Tłumaczenie interfejsu na inne języki

## 5. Historyjki użytkowników

### US-001
- ID: US-001
- Tytuł: Rejestracja nowego użytkownika
- Opis: Jako nowy użytkownik, chcę utworzyć konto w aplikacji VibeTravels, aby móc korzystać z funkcji planowania podróży.
- Kryteria akceptacji:
    1. Użytkownik może wypełnić formularz rejestracyjny z polami: email, hasło, potwierdzenie hasła.
    2. System waliduje unikalność adresu email.
    3. System wymaga hasła o odpowiedniej sile (min. 8 znaków, zawierające wielkie i małe litery, cyfry oraz minimum jeden znak specjalny).
    4. Po rejestracji użytkownik otrzymuje email z linkiem aktywacyjnym.
    5. Po aktywacji konta użytkownik jest przekierowywany do formularza profilu preferencji turystycznych.

### US-002
- ID: US-002
- Tytuł: Logowanie do aplikacji
- Opis: Jako zarejestrowany użytkownik, chcę zalogować się do aplikacji, aby uzyskać dostęp do moich notatek i planów podróży.
- Kryteria akceptacji:
    1. Użytkownik może zalogować się przy użyciu adresu email i hasła.
    2. System weryfikuje poprawność wprowadzonych danych.
    3. Po poprawnym zalogowaniu użytkownik jest przekierowywany do dashboardu.
    4. W przypadku niepoprawnych danych system wyświetla odpowiedni komunikat.
    5. Istnieje opcja "Zapomniałem hasła" umożliwiająca zresetowanie hasła.

### US-003
- ID: US-003
- Tytuł: Tworzenie profilu preferencji turystycznych
- Opis: Jako nowy użytkownik, chcę utworzyć profil moich preferencji turystycznych, aby otrzymywać spersonalizowane plany podróży.
- Kryteria akceptacji:
    1. Użytkownik może wypełnić formularz z preferencjami zawierający: poziom aktywności, ulubione sporty, typ wczasowicza oraz miejsce zamieszkania.
    2. Wypełnienie profilu jest obowiązkowe po utworzeniu konta.
    3. System zapisuje preferencje w profilu użytkownika.
    4. Użytkownik może przejść do dashboardu po wypełnieniu wszystkich wymaganych pól.

### US-004
- ID: US-004
- Tytuł: Edycja profilu preferencji turystycznych
- Opis: Jako zarejestrowany użytkownik, chcę edytować moje preferencje turystyczne, aby aktualizować moje upodobania podróżnicze.
- Kryteria akceptacji:
    1. Użytkownik może przejść do sekcji profilu z poziomu dashboardu.
    2. System wyświetla aktualnie zapisane preferencje.
    3. Użytkownik może edytować wszystkie pola profilu.
    4. System zapisuje zaktualizowane preferencje po zatwierdzeniu przez użytkownika.

### US-005
- ID: US-005
- Tytuł: Tworzenie notatki o podróży
- Opis: Jako użytkownik, chcę stworzyć notatkę o planowanej podróży, aby zapisać moje pomysły i preferencje dotyczące wyjazdu.
- Kryteria akceptacji:
    1. Użytkownik może utworzyć nową notatkę z poziomu dashboardu.
    2. System oferuje wybór między notatką w formie dowolnej a szablonami ze strukturą.
    3. Użytkownik może przypisać notatkę do jednej z kategorii: Letnie wakacje, Wyjazd zimowy, Przygoda, Zwiedzanie, Leniuchowanie, Na Sportowo.
    4. W przypadku wyboru szablonu, system wyświetla formularz z polami: kontynent, kraj, pora roku, data, typ zakwaterowania, rodzaj transportu, planowane aktywności, liczba osób.
    5. System zapisuje notatkę i przypisuje ją do konta użytkownika.

### US-006
- ID: US-006
- Tytuł: Przeglądanie notatek o podróżach
- Opis: Jako użytkownik, chcę przeglądać moje zapisane notatki o podróżach, aby mieć dostęp do wcześniej zapisanych pomysłów.
- Kryteria akceptacji:
    1. Użytkownik może przejść do sekcji "Notatki" z poziomu dashboardu.
    2. System wyświetla listę wszystkich notatek użytkownika posortowanych chronologicznie, od najnowszej.
    3. Użytkownik może filtrować notatki według kategorii.
    4. Użytkownik może wyszukiwać notatki po słowach kluczowych.
    5. System wyświetla podstawowe informacje o każdej notatce na liście (tytuł, kategoria, data utworzenia).

### US-007
- ID: US-007
- Tytuł: Edycja notatki o podróży
- Opis: Jako użytkownik, chcę edytować moje notatki o podróżach, aby aktualizować moje pomysły i preferencje.
- Kryteria akceptacji:
    1. Użytkownik może wybrać notatkę z listy i przejść do trybu edycji.
    2. System wyświetla treść notatki w formie edytowalnej.
    3. Użytkownik może modyfikować wszystkie pola notatki.
    4. System zapisuje zaktualizowaną notatkę po zatwierdzeniu przez użytkownika.
    5. System aktualizuje datę modyfikacji notatki.

### US-008
- ID: US-008
- Tytuł: Usuwanie notatki o podróży
- Opis: Jako użytkownik, chcę usuwać moje notatki o podróżach, aby pozbyć się nieaktualnych lub niepotrzebnych informacji.
- Kryteria akceptacji:
    1. Użytkownik może wybrać opcję usunięcia notatki z listy lub z widoku szczegółowego notatki.
    2. System wyświetla komunikat potwierdzający chęć usunięcia notatki.
    3. Po potwierdzeniu system usuwa notatkę z konta użytkownika.
    4. System wyświetla potwierdzenie usunięcia notatki.

### US-009
- ID: US-009
- Tytuł: Generowanie planu podróży na żądanie
- Opis: Jako użytkownik, chcę wygenerować plan podróży na podstawie mojej notatki, aby otrzymać szczegółową propozycję wyjazdu.
- Kryteria akceptacji:
    1. Użytkownik może wybrać opcję generowania planu z widoku notatki.
    2. System przekazuje treść notatki oraz preferencje użytkownika do silnika AI.
    3. System informuje użytkownika o rozpoczęciu procesu generowania planu.
    4. Po zakończeniu generowania system zapisuje plan i powiadamia użytkownika.
    5. Wygenerowany plan zawiera: możliwe firmy transportowe linie lotnicze, pociągi, autokary, listę znalezionych miejsc na zakwaterowanie, listę dobranych do preferencji użytkownika wycieczek.
    6. Plan zawiera linki do Google Maps z lokalizacjami, które użytkownik będzie odwiedzał.

### US-010
- ID: US-010
- Tytuł: Automatyczne generowanie planu podróży
- Opis: Jako użytkownik, chcę aby system automatycznie generował plany podróży na podstawie moich notatek, abym nie musiał ręcznie inicjować procesu.
- Kryteria akceptacji:
    1. System automatycznie inicjuje generowanie planu po utworzeniu nowej notatki.
    2. System uwzględnia wszystkie notatki użytkownika i jego preferencje w procesie generowania.
    3. Po zakończeniu generowania system zapisuje plan i powiadamia użytkownika.
    4. Użytkownik może wyłączyć funkcję automatycznego generowania w ustawieniach.

### US-011
- ID: US-011
- Tytuł: Przeglądanie wygenerowanych planów podróży
- Opis: Jako użytkownik, chcę przeglądać wygenerowane przez AI plany podróży, aby zapoznać się z propozycjami.
- Kryteria akceptacji:
    1. Użytkownik może przejść do sekcji "Wygenerowane plany" z poziomu dashboardu.
    2. System wyświetla listę wszystkich wygenerowanych planów posortowanych chronologicznie, od najnowszego.
    3. Użytkownik może filtrować plany według kategorii odpowiadających kategoriom notatek.
    4. System wyświetla podstawowe informacje o każdym planie na liście (tytuł, kategoria, data wygenerowania).
    5. Użytkownik może wybrać plan z listy, aby zobaczyć jego szczegóły.

### US-012
- ID: US-012
- Tytuł: Akceptacja lub odrzucenie wygenerowanego planu
- Opis: Jako użytkownik, chcę akceptować lub odrzucać wygenerowane plany podróży, aby zarządzać moimi preferencjami podróżniczymi.
- Kryteria akceptacji:
    1. Użytkownik może zaakceptować lub odrzucić plan z widoku szczegółowego planu.
    2. W przypadku akceptacji system przenosi plan do sekcji "Zaakceptowane plany".
    3. W przypadku odrzucenia system pyta o powód odrzucenia (opcjonalnie) i usuwa plan z listy "Wygenerowane plany".
    4. System uwzględnia decyzje użytkownika przy generowaniu przyszłych planów.

### US-013
- ID: US-013
- Tytuł: Ocenianie wygenerowanego planu
- Opis: Jako użytkownik, chcę oceniać wygenerowane plany podróży, aby dostarczać feedback dla systemu AI.
- Kryteria akceptacji:
    1. Użytkownik może ocenić plan w skali od 1 do 5 gwiazdek.
    2. System zapisuje ocenę i uwzględnia ją przy generowaniu przyszłych planów.
    3. Użytkownik może ocenić plan zarówno przed jak i po jego akceptacji.
    4. System wyświetla średnią ocenę planów w profilu użytkownika.

### US-014
- ID: US-014
- Tytuł: Przeglądanie zaakceptowanych planów
- Opis: Jako użytkownik, chcę przeglądać zaakceptowane przeze mnie plany podróży, aby mieć do nich łatwy dostęp.
- Kryteria akceptacji:
    1. Użytkownik może przejść do sekcji "Zaakceptowane plany" z poziomu dashboardu.
    2. System wyświetla listę wszystkich zaakceptowanych planów posortowanych chronologicznie, od najnowszego.
    3. Użytkownik może filtrować plany według kategorii.
    4. System wyświetla podstawowe informacje o każdym planie na liście (tytuł, kategoria, data akceptacji).
    5. Użytkownik może wybrać plan z listy, aby zobaczyć jego szczegóły.

### US-015
- ID: US-015
- Tytuł: Wylogowanie z aplikacji
- Opis: Jako zalogowany użytkownik, chcę wylogować się z aplikacji, aby zabezpieczyć moje dane przed niepowołanym dostępem.
- Kryteria akceptacji:
    1. Użytkownik może wybrać opcję wylogowania z menu głównego.
    2. System kończy sesję użytkownika i przekierowuje go do strony logowania.
    3. Po wylogowaniu dostęp do danych użytkownika wymaga ponownego zalogowania.

### US-016
- ID: US-016
- Tytuł: Zabezpieczenie dostępu do konta
- Opis: Jako użytkownik, chcę mieć pewność, że moje konto jest zabezpieczone przed niepowołanym dostępem, aby chronić moje dane osobiste i plany podróży.
- Kryteria akceptacji:
    1. System wymusza używanie silnych haseł (min. 8 znaków, zawierające wielkie i małe litery, cyfry oraz minimum jeden znak specjalny).
    2. System blokuje konto po 5 nieudanych próbach logowania.
    3. System oferuje mechanizm odblokowania konta przez email.
    4. Sesja użytkownika wygasa automatycznie po 30 minutach nieaktywności.
    5. System szyfruje dane użytkownika przechowywane w bazie danych.

### US-017
- ID: US-017
- Tytuł: Przeglądanie dashboardu
- Opis: Jako zalogowany użytkownik, chcę mieć dostęp do dashboardu z podsumowaniem moich aktywności w aplikacji, aby szybko zarządzać moimi notatkami i planami.
- Kryteria akceptacji:
    1. System wyświetla dashboard po zalogowaniu użytkownika.
    2. Dashboard zawiera sekcje: "Notatki", "Wygenerowane plany" i "Zaakceptowane plany".
    3. Dashboard wyświetla liczniki dla każdej sekcji (liczba notatek, liczba wygenerowanych planów, liczba zaakceptowanych planów).
    4. Dashboard zawiera przyciski szybkiego dostępu do najczęściej używanych funkcji (tworzenie notatki, generowanie planu).
    5. System wyświetla powiadomienia o nowych wygenerowanych planach na dashboardzie.

### US-018
- ID: US-018
- Tytuł: Usuwanie konta
- Opis: Jako użytkownik, chcę mieć możliwość usunięcia mojego konta, aby pozbyć się moich danych z systemu.
- Kryteria akceptacji:
    1. Użytkownik może wybrać opcję usunięcia konta z sekcji ustawień profilu.
    2. System wymaga potwierdzenia decyzji o usunięciu konta przez wprowadzenie hasła.
    3. System informuje użytkownika o konsekwencjach usunięcia konta (utrata wszystkich danych).
    4. Po potwierdzeniu system usuwa wszystkie dane użytkownika, w tym notatki i plany podróży.
    5. System wyświetla potwierdzenie usunięcia konta.

## 6. Metryki sukcesu

### 6.1. Kluczowe wskaźniki wydajności (KPI)
- 90% użytkowników posiada wypełnione preferencje turystyczne w swoim profilu
- 75% użytkowników generuje 3 lub więcej planów wycieczek na rok

### 6.2. Dodatkowe metryki
- Procent zaakceptowanych planów generowanych przez AI (cel: >60%)
- Średnia ocena gwiazdkowa wygenerowanych planów (cel: >3.0 w skali 1-5)
- Średnia liczba notatek na użytkownika (cel: >5 rocznie)
- Średni czas spędzony w aplikacji (cel: >10 minut na sesję)
- Procent użytkowników, którzy wracają do aplikacji w ciągu 30 dni od pierwszego użycia (cel: >50%)
- Liczba potrzebnych generacji przed akceptacją planu przez użytkownika (cel: <2)

### 6.3. Monitorowanie i raportowanie
- Cotygodniowe raporty dotyczące aktywności użytkowników i generowania planów
- Miesięczna analiza spełnienia KPI
- Kwartalna ocena jakości generowanych planów na podstawie ocen użytkowników
- System alertów w przypadku spadku kluczowych metryk poniżej określonych progów

### 6.4. Plan poprawy
- Regularne aktualizacje silnika AI na podstawie feedbacku użytkowników
- Rozszerzanie bazy szablonów notatek na podstawie popularności używanych kategorii
- Wprowadzanie ulepszeń interfejsu użytkownika na podstawie analizy zachowań użytkowników
- Dostosowywanie procesu onboardingu w celu zwiększenia wypełnienia profili preferencji turystycznych
