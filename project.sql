CREATE OR REPLACE PACKAGE tipuri_date AS
    TYPE v_certificari IS TABLE OF VARCHAR2(25) INDEX BY PLS_INTEGER;
    certificari v_certificari;
    
    PROCEDURE creare_certificari;
    PROCEDURE creare_obiect;
    PROCEDURE creare_tip_ex7;
    
    PROCEDURE tabel_artist;
    PROCEDURE tabel_album;
    PROCEDURE tabel_genre;
    PROCEDURE tabel_user;
    PROCEDURE tabel_playlist;
    PROCEDURE tabel_song;
    PROCEDURE tabel_song_playlist;
    END tipuri_date;
/

CREATE OR REPLACE PACKAGE BODY tipuri_date AS
    PROCEDURE creare_certificari
    IS
    BEGIN
        certificari(1) := 'Diamond';
        certificari(2) := 'Multi-Platinum';
        certificari(3) := 'Platinum';
        certificari(4) := 'Gold';
    END creare_certificari;
    
    PROCEDURE creare_obiect
    IS
    BEGIN
        EXECUTE IMMEDIATE(
        'CREATE OR REPLACE TYPE r_colaborator AS OBJECT(
            nume VARCHAR2(100),
            aparitii NUMBER(2))
        ');
        
        EXECUTE IMMEDIATE(
        'CREATE OR REPLACE TYPE t_colaborator IS TABLE OF r_colaborator'
        );  
    END creare_obiect;
    
    PROCEDURE creare_tip_ex7
    IS
    BEGIN 
        EXECUTE IMMEDIATE(
        'CREATE OR REPLACE TYPE cantec_aparitii AS OBJECT (
            cantec_id NUMBER(20),
            aparitii NUMBER,
            certificare VARCHAR2(25))
        ');
    END creare_tip_ex7;
    
    PROCEDURE tabel_artist
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE ARTIST (
            id_artist NUMBER(10) NOT NULL,
            artist_name VARCHAR2(100) NOT NULL,
            no_of_albums NUMBER(3),
            CONSTRAINT pk_id_artist PRIMARY KEY(id_artist)
            )
        ');
    END tabel_artist;
    
    PROCEDURE tabel_album
    IS
    BEGIN
        creare_obiect;
        EXECUTE IMMEDIATE('
        CREATE TABLE ALBUM (
            id_album NUMBER(10) NOT NULL,
            id_artist NUMBER(10) NOT NULL,
            release_date DATE,
            album_name VARCHAR2(100) NOT NULL,
            colaboratori t_colaborator,
            CONSTRAINT pk_id_album PRIMARY KEY(id_album),
       CONSTRAINT fk_id_artist FOREIGN KEY(id_artist) REFERENCES ARTIST(id_artist) ON DELETE CASCADE
            )
            NESTED TABLE colaboratori STORE AS colaboratori_mag
        ');
    END tabel_album;
    
    PROCEDURE tabel_genre
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE GENRE (
            id_genre NUMBER(10) NOT NULL,
            genre_name VARCHAR2(50) NOT NULL,
            CONSTRAINT pk_id_genre PRIMARY KEY(id_genre)
            )
        ');
    END tabel_genre;
    
    PROCEDURE tabel_user
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE USER_LOG (
            id_user NUMBER(10) NOT NULL,
            username VARCHAR2(100) NOT NULL,
            email VARCHAR2(50),
            account_type VARCHAR2(25),
            CONSTRAINT pk_id_user PRIMARY KEY(id_user)
            )
        ');
    END tabel_user;
    
    PROCEDURE tabel_playlist
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE PLAYLIST (
            id_playlist NUMBER(20) NOT NULL,
            id_user NUMBER(10) NOT NULL,
            playlist_name VARCHAR2(50) NOT NULL,
            is_favorite NUMBER(1) NOT NULL CHECK (is_favorite IN (0, 1)),
            CONSTRAINT pk_id_playlist PRIMARY KEY(id_playlist),
            CONSTRAINT fk_id_user FOREIGN KEY(id_user) REFERENCES USER_LOG(id_user) ON DELETE CASCADE
            )
        ');
    END tabel_playlist;
    
    PROCEDURE tabel_song_playlist
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE SONG_PLAYLIST (
            id_song NUMBER(20) NOT NULL,
            id_playlist NUMBER(20) NOT NULL,
            is_favorite NUMBER(1) NOT NULL CHECK (is_favorite IN (0, 1)),
            CONSTRAINT pk_id_song_playlist PRIMARY KEY(id_song, id_playlist)
            )
        ');
    END tabel_song_playlist;
    
    PROCEDURE tabel_song
    IS
    BEGIN
        EXECUTE IMMEDIATE('
        CREATE TABLE SONG (
            id_song NUMBER(20) NOT NULL,
            id_album NUMBER(10) NOT NULL,
            id_genre NUMBER(10) NOT NULL,
            song_name VARCHAR2(50),
            certification VARCHAR2(25),
            CONSTRAINT pk_id_song PRIMARY KEY(id_song),
            CONSTRAINT fk_id_album FOREIGN KEY(id_album) REFERENCES ALBUM(id_album) ON DELETE CASCADE,
            CONSTRAINT fk_id_genre FOREIGN KEY(id_genre) REFERENCES GENRE(id_genre) ON DELETE CASCADE
            )
        ');
    END tabel_song;
END tipuri_date;
/

EXECUTE tipuri_date.creare_certificari;

EXECUTE tipuri_date.creare_obiect;
DESC r_colaborator;
DESC t_colaborator;

DROP TYPE t_colaborator;
DROP TYPE r_colaborator;

EXECUTE tipuri_date.tabel_artist;
DESC artist;

EXECUTE tipuri_date.tabel_album;
DESC album;
DESC r_colaborator;
DESC t_colaborator;

EXECUTE tipuri_date.tabel_genre;
DESC genre;

EXECUTE tipuri_date.tabel_user;
DESC user_log;

EXECUTE tipuri_date.tabel_playlist;
DESC playlist;

EXECUTE tipuri_date.tabel_song;
DESC song;

EXECUTE tipuri_date.tabel_song_playlist;
DESC song_playlist;

CREATE SEQUENCE seq_album START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_artist START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_genre START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_playlist START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_song START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PACKAGE inserari AS
    PROCEDURE secventa_album;
    PROCEDURE inserare_album
              (artist_id artist.id_artist%TYPE,
               data_aparitie album.release_date%TYPE,
               nume_album album.album_name%TYPE);
    
    PROCEDURE secventa_artist;
    PROCEDURE inserare_artist
              (nume_artist artist.artist_name%TYPE,
               numar_albume artist.no_of_albums%TYPE);
    
    PROCEDURE secventa_genre;
    PROCEDURE inserare_genre
              (nume_gen genre.genre_name%TYPE);
    PROCEDURE inserare_song_playlist
              (cantec_id song.id_song%TYPE,
               playlist_id playlist.id_playlist%TYPE,
               favorit song_playlist.is_favorite%TYPE);            
    
    PROCEDURE secventa_playlist;
    PROCEDURE inserare_playlist
              (utilizator_id user_log.id_user%TYPE,
               nume_playlist playlist.playlist_name%TYPE,
               favorit playlist.is_favorite%TYPE);
               
    PROCEDURE secventa_song;
    PROCEDURE inserare_song
              (album_id album.id_album%TYPE,
               id_gen genre.id_genre%TYPE,
               nume_cantec song.song_name%TYPE,
               certificare song.certification%TYPE);
    
    PROCEDURE secventa_user;
    PROCEDURE inserare_user
              (nume_utilizator user_log.username%TYPE,
               email user_log.email%TYPE,
               cont user_log.account_type%TYPE);
END inserari;
/

CREATE OR REPLACE PACKAGE BODY inserari AS
    PROCEDURE secventa_album
    IS
        contor NUMBER := 0;
        cod_maxim_album album.id_album%TYPE;
    BEGIN
        SELECT MAX(id_album) + 1 INTO cod_maxim_album
        FROM album;
        IF cod_maxim_album IS NULL THEN
            cod_maxim_album := 1;
        END IF;
    
        SELECT COUNT(*)
        INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_album');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_album');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_album START WITH ' || cod_maxim_album || ' INCREMENT BY 1');
    END secventa_album;

    PROCEDURE inserare_album
              (artist_id artist.id_artist%TYPE,
               data_aparitie album.release_date%TYPE,
               nume_album album.album_name%TYPE)
    IS
    BEGIN
        secventa_album;
        INSERT INTO album VALUES (seq_album.NEXTVAL, artist_id, data_aparitie, nume_album, NULL);
    END inserare_album;
    
    ------------------------------------------------------------------
    
    PROCEDURE secventa_artist
    IS
        contor NUMBER := 0;
        cod_maxim_artist artist.id_artist%TYPE;
    BEGIN
        SELECT MAX(id_artist) + 1 INTO cod_maxim_artist
        FROM artist;
        IF cod_maxim_artist IS NULL THEN
            cod_maxim_artist := 1;
        END IF;
    
        SELECT COUNT(*)
        INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_artist');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_artist');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_artist START WITH ' || cod_maxim_artist || ' INCREMENT BY 1');
    END secventa_artist;
    
    PROCEDURE inserare_artist
              (nume_artist artist.artist_name%TYPE,
               numar_albume artist.no_of_albums%TYPE)
    IS
    BEGIN
        secventa_artist;
        INSERT INTO artist VALUES (seq_artist.NEXTVAL, nume_artist, numar_albume);
    END inserare_artist;
    
    ------------------------------------------------------------------
    
    PROCEDURE secventa_genre
    IS
        contor NUMBER := 0;
        cod_maxim_genre genre.id_genre%TYPE;
    BEGIN
        SELECT MAX(id_genre) + 1 INTO cod_maxim_genre
        FROM genre;
        IF cod_maxim_genre IS NULL THEN
            cod_maxim_genre := 1;
        END IF;
    
        SELECT COUNT(*)
        INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_genre');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_genre');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_genre START WITH ' || cod_maxim_genre || ' INCREMENT BY 1');
    END secventa_genre;
    
    PROCEDURE inserare_genre
              (nume_gen genre.genre_name%TYPE)
    IS
    BEGIN
        secventa_genre;
        INSERT INTO genre VALUES (seq_genre.NEXTVAL, nume_gen);
    END inserare_genre;
    
    ------------------------------------------------------------------
    
    PROCEDURE inserare_song_playlist
              (cantec_id song.id_song%TYPE,
               playlist_id playlist.id_playlist%TYPE,
               favorit song_playlist.is_favorite%TYPE)
    IS
    BEGIN
        INSERT INTO song_playlist VALUES (cantec_id, playlist_id, favorit);
    END inserare_song_playlist;
    
    ------------------------------------------------------------------
    
    PROCEDURE secventa_playlist
    IS
        contor NUMBER := 0;
        cod_maxim_playlist playlist.id_playlist%TYPE;
    BEGIN
        SELECT MAX(id_playlist) + 1 INTO cod_maxim_playlist
        FROM playlist;
        IF cod_maxim_playlist IS NULL THEN
            cod_maxim_playlist := 1;
        END IF;
    
        SELECT COUNT(*)
        INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_playlist');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_playlist');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_playlist START WITH ' || cod_maxim_playlist || ' INCREMENT BY 1');
    END secventa_playlist;
    
    PROCEDURE inserare_playlist
              (utilizator_id user_log.id_user%TYPE,
               nume_playlist playlist.playlist_name%TYPE,
               favorit playlist.is_favorite%TYPE)
    IS
    BEGIN
        secventa_playlist;
        INSERT INTO playlist VALUES (seq_playlist.NEXTVAL, utilizator_id, nume_playlist, favorit);
    END inserare_playlist;
    
    ------------------------------------------------------------------
    
    PROCEDURE secventa_song
    IS
        contor NUMBER := 0;
        cod_maxim_song song.id_song%TYPE;
    BEGIN
        SELECT MAX(id_song) + 1 INTO cod_maxim_song
        FROM song;
        IF cod_maxim_song IS NULL THEN
            cod_maxim_song := 1;
        END IF;
    
        SELECT COUNT(*) INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_song');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_song');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_song START WITH ' || cod_maxim_song || ' INCREMENT BY 1');
    END secventa_song;
    
    PROCEDURE inserare_song
              (album_id album.id_album%TYPE,
               id_gen genre.id_genre%TYPE,
               nume_cantec song.song_name%TYPE,
               certificare song.certification%TYPE)
    IS
    BEGIN
        secventa_song;
        INSERT INTO song VALUES (seq_song.NEXTVAL, album_id, id_gen, nume_cantec, certificare);
    END inserare_song;
    
    ------------------------------------------------------------------
    
    PROCEDURE secventa_user
    IS
        contor NUMBER := 0;
        cod_maxim_user user_log.id_user%TYPE;
    BEGIN
        SELECT MAX(id_user) + 1 INTO cod_maxim_user
        FROM user_log;
        IF cod_maxim_user IS NULL THEN
            cod_maxim_user := 1;
        END IF;
    
        SELECT COUNT(*) INTO contor
        FROM ALL_OBJECTS
        WHERE OBJECT_NAME = UPPER('seq_user');
        
        IF contor > 0 THEN
            EXECUTE IMMEDIATE('DROP SEQUENCE seq_user');
        END IF;
        EXECUTE IMMEDIATE('CREATE SEQUENCE seq_user START WITH ' || cod_maxim_user || ' INCREMENT BY 1');
    END secventa_user;

    PROCEDURE inserare_user
              (nume_utilizator user_log.username%TYPE,
               email user_log.email%TYPE,
               cont user_log.account_type%TYPE)
    IS
    BEGIN
        INSERT INTO user_log VALUES (seq_user.NEXTVAL, nume_utilizator, email, cont);
    END inserare_user;

END inserari;
/

INSERT INTO artist VALUES (1, 'Arctic Monkeys', 7);
INSERT INTO artist VALUES (2,'Miley Cyrus', 7);
INSERT INTO artist VALUES (3,'Halsey', 5);
EXECUTE inserari.inserare_artist('P!nk', 10);
EXECUTE inserari.inserare_artist('Nothing But Thieves', 4);
EXECUTE inserari.inserare_artist('AC/DC', 21);
EXECUTE inserari.inserare_artist('Queen', 44);
EXECUTE inserari.inserare_artist('The Weeknd', 44);
COMMIT;

INSERT INTO artist VALUES (28,'Manual', 1);
EXECUTE inserari.inserare_artist('Automat', 2);
SELECT * FROM artist;
DELETE FROM artist WHERE id_artist IN (28, 29);


INSERT INTO ALBUM VALUES (1,1,'09-SEP-13','AM', null);
INSERT INTO ALBUM VALUES (2,1,'18-APR-07','Favourite Worst Nightmare', null);
INSERT INTO ALBUM VALUES (3,2,'27-NOV-20','Plastic Hearts',t_colaborator(r_colaborator('Billy Idol', 6), r_colaborator('Joan Jett', 10)));
INSERT INTO ALBUM VALUES (4,3,'02-JUN-17','Hopeless Fountain Kingdom',t_colaborator(r_colaborator('Lauren Jauregui', 13)));
EXECUTE inserari.inserare_album(5, '08-SEP-17', 'Broken Machine');
EXECUTE inserari.inserare_album(5, '16-OCT-15', 'Nothing but Thieves');
EXECUTE inserari.inserare_album(6, '25-JUL-80', 'Back in Black');
EXECUTE inserari.inserare_album(6, '27-JUL-79', 'Highway To Hell');
EXECUTE inserari.inserare_album(6, '20-SEP-76', 'Dirty Deeds Done Dirt Cheap');
EXECUTE inserari.inserare_album(7, '21-NOV-75', 'A Night at the Opera');
EXECUTE inserari.inserare_album(7, '08-MAR-74', 'Queen II');
EXECUTE inserari.inserare_album(8, '20-Mar-20', 'After Hours');
EXECUTE inserari.inserare_album(8, '28-AUG-15', 'Beauty Behind the Madness');
EXECUTE inserari.inserare_album(8, '21-MAR-11', 'House of Balloons');
EXECUTE inserari.inserare_album(4, '24-OCT-08', 'Funhouse');
EXECUTE inserari.inserare_album(4, '12-SEP-12', 'The Truth About Love');
EXECUTE inserari.inserare_album(5, '23-OCT-20', 'Moral Panic');
EXECUTE inserari.inserare_album(3, '17-JAN-20', 'Manic');
SELECT * FROM album;


EXECUTE inserari.inserare_genre('Indie Rock');
EXECUTE inserari.inserare_genre('Psychedelic rock');
EXECUTE inserari.inserare_genre('Alternative rock');
EXECUTE inserari.inserare_genre('Pop-rock');
EXECUTE inserari.inserare_genre('Rock-ballad');
EXECUTE inserari.inserare_genre('Alternative RB');
EXECUTE inserari.inserare_genre('Synth-Pop');
EXECUTE inserari.inserare_genre('Nu Disco');
EXECUTE inserari.inserare_genre('Electro-Pop');
EXECUTE inserari.inserare_genre('Dark-Pop');
EXECUTE inserari.inserare_genre('Punk-rock');
EXECUTE inserari.inserare_genre('Pop-punk');
EXECUTE inserari.inserare_genre('Alternative-pop');
EXECUTE inserari.inserare_genre('Electronic');
EXECUTE inserari.inserare_genre('Electro-pop');
EXECUTE inserari.inserare_genre('Synth-pop');
EXECUTE inserari.inserare_genre('Ballad');
EXECUTE inserari.inserare_genre('Baroque-pop');
EXECUTE inserari.inserare_genre('Pop-country');
EXECUTE inserari.inserare_genre('K-Pop');
EXECUTE inserari.inserare_genre('Electronic-rock');
EXECUTE inserari.inserare_genre('Experimental-rock');
EXECUTE inserari.inserare_genre('Heavy-metal');
SELECT * FROM GENRE order by id_genre;


EXECUTE inserari.inserare_song(1, 3, 'Do I Wanna Know', 'Diamond');
EXECUTE inserari.inserare_song(1, 2, 'R U Mine?', 'Multi-platinum');
EXECUTE inserari.inserare_song(1, 3, 'One for the Road', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Arabella', 'Multi-platinum');
EXECUTE inserari.inserare_song(1, 3, 'I Want It All', 'Gold');
EXECUTE inserari.inserare_song(1, 1, 'No. 1 Party Anthem', 'Platinum');
EXECUTE inserari.inserare_song(1, 1, 'Mad Sounds', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Fireside', 'Gold');
EXECUTE inserari.inserare_song(1, 3, 'Why''d You Only Call Me When You''re High', 'Platinum');
EXECUTE inserari.inserare_song(1, 4, 'Snap Out of It', 'Platinum');
EXECUTE inserari.inserare_song(1, 3, 'Knee Socks', 'Platinum');
EXECUTE inserari.inserare_song(1, 2, 'I Wanna Be Yours', 'Multi-platinum');

EXECUTE inserari.inserare_song(2, 2, 'Balaclava', 'Gold');

EXECUTE inserari.inserare_song(3, 4, 'WTF Do I Know', 'Platinum');
EXECUTE inserari.inserare_song(3, 3, 'Plastic Hearts', 'Platinum');
EXECUTE inserari.inserare_song(3, 5, 'Angels like you', 'Gold');
EXECUTE inserari.inserare_song(3, 10, 'Prisoner', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 11, 'Gimme What I Want', 'Gold');
EXECUTE inserari.inserare_song(3, 10, 'Night Crawling', 'Platinum');
EXECUTE inserari.inserare_song(3, 3, 'Midnight Sky', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 4, 'High', 'Platinum');
EXECUTE inserari.inserare_song(3, 12, 'Hate Me', 'Gold');
EXECUTE inserari.inserare_song(3, 3, 'Bad Karma', 'Multi-platinum');
EXECUTE inserari.inserare_song(3, 3, 'Never Be Me', 'Gold');
EXECUTE inserari.inserare_song(3, 3, 'Golden G String', 'Gold');

EXECUTE inserari.inserare_song(4, 13, '100 Letters', 'Gold');
EXECUTE inserari.inserare_song(4, 14, 'Eyes Closed', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Heaven in Hiding', 'Platinum');
EXECUTE inserari.inserare_song(4, 15, 'Alone', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 16, 'Now or Never', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 17, 'Sorry', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Lie', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Walls Could Talk', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Bad at Love', 'Diamond');
EXECUTE inserari.inserare_song(4, 13, 'Don''t Play', 'Gold');
EXECUTE inserari.inserare_song(4, 16, 'Strangers', 'Multi-platinum');
EXECUTE inserari.inserare_song(4, 13, 'Angel on Fire', 'Gold');
EXECUTE inserari.inserare_song(4, 13, 'Devil in Me', 'Gold');
EXECUTE inserari.inserare_song(4, 14, 'Hopeless', 'Gold');

EXECUTE inserari.inserare_song(5, 3, 'I Was Just A Kid', 'Gold');
EXECUTE inserari.inserare_song(5, 1, 'Amsterdam', 'Multi-platinum');
EXECUTE inserari.inserare_song(5, 3, 'Sorry', 'Platinum');
EXECUTE inserari.inserare_song(5, 1, 'Broken Machine', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Live Like Animals', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Soda', 'Gold');
EXECUTE inserari.inserare_song(5, 4, 'I''m Not Made By Design', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Particles', 'Platinum');
EXECUTE inserari.inserare_song(5, 21, 'Get Better', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Hell, Yeah', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Afterlife', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Reset Me', 'Gold');
EXECUTE inserari.inserare_song(5, 21, 'Number 13', 'Gold');

EXECUTE inserari.inserare_song(6, 3, 'Excuse Me', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Ban All The Music', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Wake Up Call', 'Gold');
EXECUTE inserari.inserare_song(6, 22, 'Itch', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'If I Get High', 'Platinum');
EXECUTE inserari.inserare_song(6, 3, 'Graveyard Whistling', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Hostage', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Trip Switch', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Lover, Please Stay', 'Platinum');
EXECUTE inserari.inserare_song(6, 1, 'Drawing Pins', 'Platinum');
EXECUTE inserari.inserare_song(6, 3, 'Painkiller', 'Gold');
EXECUTE inserari.inserare_song(6, 1, 'Tempt You (Evocatio)', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Honey Whiskey', 'Gold');
EXECUTE inserari.inserare_song(6, 1, 'Hanging', 'Gold');
EXECUTE inserari.inserare_song(6, 3, 'Neon Brother', 'Gold');
EXECUTE inserari.inserare_song(6, 22, 'Six Billion', 'Gold');

EXECUTE inserari.inserare_song(7, 23, 'Back in Black', 'Diamond');

EXECUTE inserari.inserare_song(14, 6, 'High for This', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'What You Need', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'Wicked Games', 'Platinum');
EXECUTE inserari.inserare_song(14, 6, 'The Morning', 'Gold');
EXECUTE inserari.inserare_song(14, 6, 'Coming Down', 'Gold');

EXECUTE inserari.inserare_song(12, 7, 'Alone Again', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Too Late', 'Platinum');
EXECUTE inserari.inserare_song(12, 8, 'Hardest to Love', 'Platinum');
EXECUTE inserari.inserare_song(12, 7, 'Scared To Live', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Snowchild', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Escape From LA', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'Heartless', 'Diamond');
EXECUTE inserari.inserare_song(12, 8, 'Faith', 'Gold');
EXECUTE inserari.inserare_song(12, 8, 'Blinding Lights', 'Diamond');
EXECUTE inserari.inserare_song(12, 7, 'In Your Eyes', 'Multi-Platinum');
EXECUTE inserari.inserare_song(12, 8, 'Save Your Tears', 'Gold');
EXECUTE inserari.inserare_song(12, 10, 'Repeat After Me', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'After Hours', 'Gold');
EXECUTE inserari.inserare_song(12, 9, 'Until I Bleed Out', 'Gold');
EXECUTE inserari.inserare_song(12, 8, 'Nothing Compares', 'Gold');
EXECUTE inserari.inserare_song(12, 7, 'Missed You', 'Gold');
EXECUTE inserari.inserare_song(12, 6, 'Final Lullaby', 'Gold');

EXECUTE inserari.inserare_song(17, 3, 'Unperson', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Is Everybody Going Crazy', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Moral Panic', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Real Love Song', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'Phobia', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'This Feels Like the End', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Free If We Want It', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Impossible', 'Platinum');
EXECUTE inserari.inserare_song(17, 3, 'There Was Sun', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Can You Afford to Be an Individual', 'Gold');
EXECUTE inserari.inserare_song(17, 3, 'Before We Drift Away', 'Gold');


EXECUTE inserari.inserare_song(18, 13, 'Ashley', 'Gold');
EXECUTE inserari.inserare_song(18, 18, 'clementine', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Graveyard', 'Platinum');
EXECUTE inserari.inserare_song(18, 19, 'You should be sad', 'Multi-platinum');
EXECUTE inserari.inserare_song(18, 13, 'Forever... (is a long time)', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Dominic''s Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'I HATE EVERYBODY', 'Gold');
EXECUTE inserari.inserare_song(18, 12, '3 am', 'Gold');
EXECUTE inserari.inserare_song(18, 16, 'Without Me', 'Diamond');
EXECUTE inserari.inserare_song(18, 17, 'Finally // beautiful stranger', 'Platinum');
EXECUTE inserari.inserare_song(18, 1, 'Alanis'' Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'killing boys', 'Gold');
EXECUTE inserari.inserare_song(18, 20, 'SUGA''s Interlude', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'More', 'Gold');
EXECUTE inserari.inserare_song(18, 13, 'Still Learning', 'Gold');
EXECUTE inserari.inserare_song(18, 13, '929', 'Gold');
SELECT * FROM song;


EXECUTE inserari.inserare_user('user1', 'user1@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user2', 'user2@gmail.com', 'Premium');
EXECUTE inserari.inserare_user('user3', 'user3@gmail.com', 'Premium');
EXECUTE inserari.inserare_user('user4', 'user4@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user5', 'user5@gmail.com', 'Free');
EXECUTE inserari.inserare_user('user6', 'user6@gmail.com', 'Free');
SELECT * FROM user_log;


EXECUTE inserari.inserare_playlist(1, 'edgy', 1);
EXECUTE inserari.inserare_playlist(1, 'love', 1);
EXECUTE inserari.inserare_playlist(1, 'BEST OF NBT', 1);
EXECUTE inserari.inserare_playlist(2, 'guitar', 0);
EXECUTE inserari.inserare_playlist(3, 'Girl Power', 0);
EXECUTE inserari.inserare_playlist(3, 'Dark', 1);
EXECUTE inserari.inserare_playlist(4, 'Cultural Reset', 0);
EXECUTE inserari.inserare_playlist(4, 'rockkkk', 1);
EXECUTE inserari.inserare_playlist(5, 'Chill', 0);
SELECT * FROM playlist;


EXECUTE inserari.inserare_song_playlist(1, 1, 1);
EXECUTE inserari.inserare_song_playlist(14, 1, 1);
EXECUTE inserari.inserare_song_playlist(40, 1, 1);
EXECUTE inserari.inserare_song_playlist(51, 1, 1);

EXECUTE inserari.inserare_song_playlist(66, 7, 0);
EXECUTE inserari.inserare_song_playlist(60, 7, 1);
EXECUTE inserari.inserare_song_playlist(114, 7, 0);
EXECUTE inserari.inserare_song_playlist(12, 7, 1);

EXECUTE inserari.inserare_song_playlist(100, 8, 1);
EXECUTE inserari.inserare_song_playlist(107, 8, 0);
EXECUTE inserari.inserare_song_playlist(108, 8, 0);
EXECUTE inserari.inserare_song_playlist(114, 8, 0);

EXECUTE inserari.inserare_song_playlist(2, 2, 1)
EXECUTE inserari.inserare_song_playlist(19, 2, 0);
EXECUTE inserari.inserare_song_playlist(14, 2, 1);
EXECUTE inserari.inserare_song_playlist(16, 2, 0);

EXECUTE inserari.inserare_song_playlist(20, 3, 1);
EXECUTE inserari.inserare_song_playlist(13, 3, 1);
EXECUTE inserari.inserare_song_playlist(14, 3, 1);
EXECUTE inserari.inserare_song_playlist(42, 3, 1);
EXECUTE inserari.inserare_song_playlist(23, 3, 1);

EXECUTE inserari.inserare_song_playlist(19, 4, 1);
EXECUTE inserari.inserare_song_playlist(47, 4, 1);
EXECUTE inserari.inserare_song_playlist(9, 4, 1);

EXECUTE inserari.inserare_song_playlist(79, 9, 0);
EXECUTE inserari.inserare_song_playlist(91, 9, 1);
EXECUTE inserari.inserare_song_playlist(118, 9, 0);
EXECUTE inserari.inserare_song_playlist(13, 9, 1);

EXECUTE inserari.inserare_song_playlist(14, 5, 1);
EXECUTE inserari.inserare_song_playlist(23, 5, 0);
EXECUTE inserari.inserare_song_playlist(30, 5, 0);
EXECUTE inserari.inserare_song_playlist(6, 5, 0);

EXECUTE inserari.inserare_song_playlist(16, 6, 1);
EXECUTE inserari.inserare_song_playlist(12, 6, 0);
EXECUTE inserari.inserare_song_playlist(31, 6, 0);
EXECUTE inserari.inserare_song_playlist(41, 6, 0);
SELECT * FROM song_playlist;


CREATE OR REPLACE FUNCTION maxim_colaborari
	RETURN artist.artist_name%TYPE IS
	maxim NUMBER := 0;
	TYPE tablou_indexat IS TABLE OF artist.artist_name%TYPE INDEX BY PLS_INTEGER;
	nume tablou_indexat;
	mai_multi EXCEPTION;
	niciunul EXCEPTION;
BEGIN
	SELECT MAX(COUNT(c.nume)) INTO maxim
	FROM album a, TABLE (a.colaboratori) c
	GROUP BY a.id_artist;
	SELECT artist_name
	BULK COLLECT INTO nume
	FROM artist
	WHERE id_artist IN (SELECT a.id_artist FROM album a, TABLE (a.colaboratori) c
                    	GROUP BY a.id_artist
                    	HAVING COUNT(c.nume) = maxim);
                   	
	IF nume.COUNT > 1 THEN
    	RAISE mai_multi;
	ELSIF nume.COUNT = 0 THEN
    	RAISE niciunul;
	ELSE
    	RETURN nume(1);
	END IF;
	
	EXCEPTION
    	WHEN mai_multi THEN
        	DBMS_OUTPUT.PUT_LINE('Exista mai multi artisti cu numar maxim de colaborari. Acestia sunt: ');
        	
        	FOR i IN nume.FIRST..nume.LAST LOOP
            	DBMS_OUTPUT.PUT_LINE(i || '. ' || nume(i));
        	END LOOP;
        	RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi artisti cu numar maxim de colaborari');
    	WHEN niciunul THEN
        	DBMS_OUTPUT.PUT_LINE('Niciun artist nu a avut vreo colaborare');
        	RAISE_APPLICATION_ERROR(-20002, 'Niciun artist nu a avut vreo colaborare');
END;
/


UPDATE album SET colaboratori = NULL;
SET SERVEROUTPUT ON
SELECT maxim_colaborari FROM DUAL;
SET SERVEROUTPUT OFF

UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Billy Idol', 6), r_colaborator('Joan Jett', 10))
WHERE id_album = 3;
UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Quavo', 7), r_colaborator('Lauren Jauregui', 11), r_colaborator('Cashmere Cat', 14))
WHERE id_album = 4;          
UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Labrinth', 2), r_colaborator('Ed Sheeran', 12), r_colaborator('Lana Del Rey', 13))
WHERE id_album = 13; 
SET SERVEROUTPUT ON
SELECT maxim_colaborari FROM DUAL;
SET SERVEROUTPUT OFF


UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Dominic Fike', 6), r_colaborator('Alanis Morissette', 11), r_colaborator('SUGA', 13))
WHERE id_album = 18;

SET SERVEROUTPUT ON
SELECT maxim_colaborari FROM DUAL;
SET SERVEROUTPUT OFF


EXECUTE tipuri_date.creare_tip_ex7;
EXECUTE tipuri_date.creare_certificari;
CREATE OR REPLACE FUNCTION cantec_popular(nume_artist artist.artist_name%TYPE)
    RETURN song.song_name%TYPE IS
    artist_ok artist.artist_name%TYPE;
    nr_cantece NUMBER := 0;
    cantec song.song_name%TYPE;
    gasit BOOLEAN := FALSE;
    maxim NUMBER := 0;
    
    query_string VARCHAR(2000) := 'SELECT cantec_aparitii(sp.id_song, COUNT(sp.id_song),(SELECT certification FROM song WHERE id_song = sp.id_song))'
                                  || chr(10) ||
                                  'FROM song_playlist sp' || chr(10) ||
                                  'WHERE sp.is_favorite = 1 AND id_song in (SELECT id_song FROM song s JOIN album al USING (id_album)' || chr(10) ||
                                                                                                      'JOIN artist ar USING (id_artist)' || chr(10) ||
                                                                           'WHERE UPPER(artist_name) = UPPER(:n))' || chr(10) ||
                                  'GROUP BY id_song';
    
    TYPE c_tip IS REF CURSOR;
    c_obiect c_tip;
    TYPE tablou_indexat IS TABLE OF cantec_aparitii INDEX BY PLS_INTEGER;
    v_obiecte tablou_indexat;
BEGIN    
    BEGIN
        SELECT artist_name INTO artist_ok FROM artist
        WHERE UPPER(artist_name) = UPPER(nume_artist);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Artistul dat nu se afla in baza de date');
                RAISE_APPLICATION_ERROR(-20003, 'Artistul dat nu se afla in baza de date');
    END;
    
    BEGIN
        SELECT COUNT(id_song) INTO nr_cantece FROM song
        WHERE id_album IN (SELECT id_album FROM artist ar JOIN album al USING (id_artist)
                           WHERE UPPER(artist_name) = UPPER(nume_artist));
                           
        IF nr_cantece = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Artistul dat nu are niciun cantec inregistrat in baza de date');
            RAISE_APPLICATION_ERROR(-20004, 'Artistul dat nu are niciun cantec inregistrat in baza de date');
        END IF;
    END;
    
    BEGIN
        SELECT artist_name INTO artist_ok FROM artist
        WHERE id_artist IN (SELECT DISTINCT id_artist FROM artist ar JOIN album al USING (id_artist)
                                                                     JOIN song s USING (id_album)
                                                                     JOIN song_playlist sp USING (id_song)
                            WHERE is_favorite = 1) AND UPPER(artist_name) = UPPER(nume_artist);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Niciun cantec al acestui artist nu a primit vreun like');
                RAISE_APPLICATION_ERROR(-20005, 'Niciun cantec al acestui artist nu a primit vreun like');
    END;

    OPEN c_obiect FOR query_string USING nume_artist;                  
    LOOP
        FETCH c_obiect
        BULK COLLECT INTO v_obiecte;
        EXIT WHEN c_obiect%NOTFOUND;
    END LOOP;
    CLOSE c_obiect;
    
    FOR i IN v_obiecte.FIRST..v_obiecte.LAST LOOP
        IF v_obiecte(i).aparitii > maxim THEN
            maxim := v_obiecte(i).aparitii;
        END IF;
    END LOOP;
    
    FOR i IN v_obiecte.FIRST..v_obiecte.LAST LOOP
        IF v_obiecte(i).aparitii > maxim THEN
            maxim := v_obiecte(i).aparitii;
        END IF;
    END LOOP;
    
    FOR i IN tipuri_date.certificari.FIRST..tipuri_date.certificari.LAST LOOP
        FOR j IN v_obiecte.FIRST..v_obiecte.LAST LOOP
            IF UPPER(v_obiecte(j).certificare) = UPPER(tipuri_date.certificari(i))
            AND v_obiecte(j).aparitii = maxim
            THEN
                SELECT song_name INTO cantec FROM song 
                WHERE id_song = v_obiecte(j).cantec_id;
                gasit := TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        IF gasit = TRUE THEN
            EXIT;
        END IF;
    END LOOP;
RETURN cantec;
END;
/

SET SERVEROUTPUT ON
SELECT cantec_popular('queen') AS "Cel mai popular cantec de la un artist dat" FROM dual;         
SELECT cantec_popular('halsey') AS "Cel mai popular cantec de la un artist dat" FROM dual;          
SELECT cantec_popular('arctic monkeys') AS "Cel mai popular cantec de la un artist dat" FROM dual; 
SET SERVEROUTPUT OFF


CREATE OR REPLACE PROCEDURE cantece_artist
IS
    TYPE refcursor IS REF CURSOR;
    CURSOR c_artist IS
        SELECT artist_name,
        CURSOR (SELECT DISTINCT song_name
                FROM song s JOIN album al USING (id_album)
                            JOIN song_playlist sp USING (id_song)
                WHERE id_artist = a.id_artist
                AND sp.is_favorite = 1)
        FROM artist a;
            
    v_nume_artist artist.artist_name%TYPE;
    v_cursor refcursor;
    v_nume_cantec song.song_name%TYPE;
    verif_cantec NUMBER := 0;
    ok BOOLEAN := FALSE;
    
    fara_cantece EXCEPTION;
    fara_like EXCEPTION;
    
    BEGIN
    OPEN c_artist;
    LOOP
        FETCH c_artist INTO v_nume_artist, v_cursor;
        EXIT WHEN c_artist%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('ARTIST '||v_nume_artist);
        ok := FALSE;
        LOOP
            FETCH v_cursor INTO v_nume_cantec;
            IF v_cursor%NOTFOUND THEN
                IF ok = FALSE THEN
                    BEGIN
                        SELECT COUNT(id_song) INTO verif_cantec
                        FROM song s JOIN album al USING (id_album)
                                    JOIN artist ar USING (id_artist)
                        WHERE UPPER(ar.artist_name) = UPPER(v_nume_artist);
                        
                        IF verif_cantec = 0 THEN
                            RAISE fara_cantece;
                        ELSE
                            RAISE fara_like;
                        END IF;
                        
                        EXCEPTION
                            WHEN fara_like THEN
                                DBMS_OUTPUT.PUT_LINE('Nu exista cantece care sa fi fost apreciate');
                            WHEN fara_cantece THEN
                                DBMS_OUTPUT.PUT_LINE('Nu exista cantece inregistrate pentru acest artist');
                    END;
                END IF;
                EXIT WHEN v_cursor%NOTFOUND;
            ELSE
                ok := TRUE;
                DBMS_OUTPUT.PUT_LINE (v_nume_cantec);
            END IF;
        END LOOP;
    END LOOP;
    CLOSE c_artist;
    END;
    /

EXECUTE cantece_artist;


CREATE OR REPLACE PROCEDURE artist_favorit(nume_user user_log.username%TYPE)
IS
    TYPE tablou_indexat IS TABLE OF artist.artist_name%TYPE INDEX BY PLS_INTEGER;
    nume_artist tablou_indexat;
    user_gasit user_log.username%TYPE;
    nr_playlisturi NUMBER := 0;
    fara_playlist EXCEPTION;
BEGIN
    BEGIN
        SELECT id_user INTO user_gasit FROM user_log
        WHERE UPPER(username) = UPPER(nume_user);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Utilizatorul dat nu se afla in baza de date');
                RAISE_APPLICATION_ERROR(-20006, 'Utilizatorul dat nu se afla in baza de date');
    END;
    
    BEGIN
        SELECT COUNT(id_playlist) INTO nr_playlisturi
        FROM playlist
        WHERE id_user = user_gasit;
        IF nr_playlisturi = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul dat nu si-a facut niciun playlist');
            RAISE_APPLICATION_ERROR(-20007, 'Utilizatorul dat nu si-a facut niciun playlist');
        END IF;
        
    END;
                
    WITH ARTISTI AS(
        SELECT artist_name AS nume FROM artist ar INNER JOIN album al ON ar.id_artist = al.id_artist
                                                  INNER JOIN song s ON al.id_album  = s.id_album 
                                                  INNER JOIN song_playlist sp ON sp.id_song  = s.id_song 
                                                  INNER JOIN playlist p ON sp.id_playlist  = p.id_playlist 
                                                  INNER JOIN user_log u ON p.id_user  = u.id_user
        WHERE UPPER(username) = UPPER(nume_user))
    SELECT nume BULK COLLECT INTO nume_artist
    FROM artisti
    GROUP BY nume
    HAVING COUNT(*) = ( SELECT MAX(artist_favorit)
                        FROM (SELECT nume, COUNT(*) AS artist_favorit
                              FROM artisti GROUP BY nume) artisti);
    
    IF nume_artist.COUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE(nume_artist(1));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Utilizatorul are mai multi artisti favoriti');      
        FOR i IN nume_artist.FIRST..nume_artist.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(i || '. ' || nume_artist(i));
        END LOOP;
    END IF;
         
END artist_favorit;
/

EXECUTE artist_favorit('user3');  
EXECUTE artist_favorit('user2');  
EXECUTE artist_favorit('user6');
EXECUTE artist_favorit('user7');    


CREATE OR REPLACE TRIGGER upgrade_account
    BEFORE UPDATE OF account_type  
    ON user_log
DECLARE
    l_day_of_month NUMBER;
BEGIN
    l_day_of_month := EXTRACT(DAY FROM sysdate);

    IF l_day_of_month BETWEEN 3 AND 10 THEN
        RAISE_APPLICATION_ERROR(-20010,'Nu puteti efectua transferul intre zilele 3 si 10');
    END IF;
END;
/

SELECT SYSDATE FROM DUAL;
UPDATE user_log SET account_type = 'Premium' WHERE id_user = 1;
ALTER TRIGGER upgrade_account DISABLE;
UPDATE user_log SET account_type = 'Premium' WHERE id_user = 1;
ROLLBACK;

CREATE OR REPLACE TRIGGER nr_playlisturi
BEFORE INSERT ON playlist
FOR EACH ROW
DECLARE
	nr NUMBER(3) := 0;
    cont user_log.account_type%TYPE;
    utilizator user_log.id_user%TYPE;
BEGIN             
    SELECT account_type, id_user INTO cont, utilizator
    FROM user_log
    WHERE id_user = :NEW.id_user;
    
    SELECT COUNT(id_playlist)
    INTO nr
	FROM playlist
	WHERE id_user = :NEW.id_user;
        
    IF nr = 3 AND UPPER(cont) = 'FREE' THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul a depasit limita de playlisturi create');
        RAISE_APPLICATION_ERROR(-20008, 'Utilizatorul a depasit limita de playlisturi create');
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul nu este inregistrat, deci nu poate crea playlisturi');
            RAISE_APPLICATION_ERROR(-20009, 'Utilizatorul nu este inregistrat, deci nu poate crea playlisturi');

END;
/
select * from playlist;
INSERT INTO PLAYLIST VALUES (10, 1, 'ceva', 1); 
INSERT INTO PLAYLIST VALUES (10, 3, 'ceva', 1); 
INSERT INTO PLAYLIST VALUES (11, 3, 'ceva', 1); 
INSERT INTO PLAYLIST VALUES (12, 4, 'ceva', 1); 
INSERT INTO PLAYLIST VALUES (13, 4, 'ceva', 1); 
INSERT INTO PLAYLIST VALUES (13, 7, 'ceva', 1); 


CREATE TABLE col_debug (
    id_bug NUMBER(6) NOT NULL,
    ts TIMESTAMP,
    col_name VARCHAR2(50),
    table_name VARCHAR2(50)
);
CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE create_audit_trigger(p_tab VARCHAR2)
IS
    l_now TIMESTAMP := systimestamp;
BEGIN
	FOR i IN (SELECT column_name FROM all_tab_columns
		  WHERE UPPER(table_name) = UPPER(p_tab)
		  AND owner = 'C##MARA')
	LOOP
        INSERT INTO col_debug VALUES (seq_audit.NEXTVAL, l_now, i.column_name, p_tab);
		DBMS_OUTPUT.PUT_LINE(i.column_name);
	END LOOP;
END;
/
EXECUTE create_audit_trigger('artist');
CREATE OR REPLACE TRIGGER audit_trigger_update
AFTER ALTER OR CREATE OR DROP ON SCHEMA
DECLARE
	j int;
BEGIN
	IF ORA_DICT_OBJ_TYPE = 'TABLE' THEN
		dbms_job.submit(j,'create_audit_trigger('''||ORA_DICT_OBJ_NAME||''');');
	END IF;
END;
/

create table t1(
    x number,
    y number
);
ALTER TABLE t1 ADD numar NUMBER(3);
ALTER TABLE t1 MODIFY numar VARCHAR2(50);

SELECT * FROM col_debug;
DROP TABLE t1;


CREATE OR REPLACE PACKAGE cerinte AS
    FUNCTION maxim_colaborari
        RETURN artist.artist_name%TYPE;                         
    FUNCTION cantec_popular(nume_artist artist.artist_name%TYPE)
        RETURN song.song_name%TYPE;                             
    PROCEDURE cantece_artist;                                   
    PROCEDURE artist_favorit(nume_user user_log.username%TYPE); 
    PROCEDURE create_audit_trigger(p_tab VARCHAR2);             
END cerinte;
/

CREATE OR REPLACE PACKAGE BODY cerinte AS
    FUNCTION maxim_colaborari
        RETURN artist.artist_name%TYPE IS
        maxim NUMBER := 0;
        TYPE tablou_indexat IS TABLE OF artist.artist_name%TYPE INDEX BY PLS_INTEGER;
        nume tablou_indexat;
        mai_multi EXCEPTION;
        niciunul EXCEPTION;

    BEGIN
        SELECT MAX(COUNT(c.nume)) INTO maxim
        FROM album a, TABLE (a.colaboratori) c
        GROUP BY a.id_artist;
     
        SELECT artist_name
        BULK COLLECT INTO nume
        FROM artist
        WHERE id_artist IN (SELECT a.id_artist FROM album a, TABLE (a.colaboratori) c
                            GROUP BY a.id_artist
                            HAVING COUNT(c.nume) = maxim);
                        
        IF nume.COUNT > 1 THEN
            RAISE mai_multi;
        ELSIF nume.COUNT = 0 THEN
            RAISE niciunul;
        ELSE
            RETURN nume(1);
        END IF;
        
        EXCEPTION
            WHEN mai_multi THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multi artisti cu numar maxim de colaborari. Acestia sunt: ');
                
                FOR i IN nume.FIRST..nume.LAST LOOP
                    DBMS_OUTPUT.PUT_LINE(i || '. ' || nume(i));
                END LOOP;
                RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi artisti cu numar maxim de colaborari');
            WHEN niciunul THEN
                DBMS_OUTPUT.PUT_LINE('Niciun artist nu a avut vreo colaborare');
                RAISE_APPLICATION_ERROR(-20002, 'Niciun artist nu a avut vreo colaborare');
    END maxim_colaborari;
    
    FUNCTION cantec_popular(nume_artist artist.artist_name%TYPE)
        RETURN song.song_name%TYPE IS
        artist_ok artist.artist_name%TYPE;
        nr_cantece NUMBER := 0;
        cantec song.song_name%TYPE;
        gasit BOOLEAN := FALSE;
        maxim NUMBER := 0;
        query_string VARCHAR(2000) := 'SELECT cantec_aparitii(sp.id_song, COUNT(sp.id_song),(SELECT certification FROM song WHERE id_song = sp.id_song))'
                                      || chr(10) ||
                                      'FROM song_playlist sp' || chr(10) ||
                                      'WHERE sp.is_favorite = 1 AND id_song in (SELECT id_song FROM song s JOIN album al USING (id_album)' || chr(10) ||
                                                                                                          'JOIN artist ar USING (id_artist)' || chr(10) ||
                                                                               'WHERE UPPER(artist_name) = UPPER(:n))' || chr(10) ||
                                      'GROUP BY id_song';
        
        TYPE c_tip IS REF CURSOR;
        c_obiect c_tip;
        TYPE tablou_indexat IS TABLE OF cantec_aparitii INDEX BY PLS_INTEGER;
        v_obiecte tablou_indexat;
    BEGIN    
        BEGIN
            SELECT artist_name INTO artist_ok FROM artist
            WHERE UPPER(artist_name) = UPPER(nume_artist);
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Artistul dat nu se afla in baza de date');
                    RAISE_APPLICATION_ERROR(-20003, 'Artistul dat nu se afla in baza de date');
        END;
        
        BEGIN
            SELECT COUNT(id_song) INTO nr_cantece FROM song
            WHERE id_album IN (SELECT id_album FROM artist ar JOIN album al USING (id_artist)
                               WHERE UPPER(artist_name) = UPPER(nume_artist));
                               
            IF nr_cantece = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Artistul dat nu are niciun cantec inregistrat in baza de date');
                RAISE_APPLICATION_ERROR(-20004, 'Artistul dat nu are niciun cantec inregistrat in baza de date');
            END IF;
        END;
        
        BEGIN
            SELECT artist_name INTO artist_ok FROM artist
            WHERE id_artist IN (SELECT DISTINCT id_artist FROM artist ar JOIN album al USING (id_artist)
                                                                         JOIN song s USING (id_album)
                                                                         JOIN song_playlist sp USING (id_song)
                                WHERE is_favorite = 1) AND UPPER(artist_name) = UPPER(nume_artist);
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Niciun cantec al acestui artist nu a primit vreun like');
                    RAISE_APPLICATION_ERROR(-20005, 'Niciun cantec al acestui artist nu a primit vreun like');
        END;
    
        OPEN c_obiect FOR query_string USING nume_artist;                  
        LOOP
            FETCH c_obiect
            BULK COLLECT INTO v_obiecte;
            EXIT WHEN c_obiect%NOTFOUND;
        END LOOP;
        CLOSE c_obiect;
        
        FOR i IN v_obiecte.FIRST..v_obiecte.LAST LOOP
            IF v_obiecte(i).aparitii > maxim THEN
                maxim := v_obiecte(i).aparitii;
            END IF;
        END LOOP;
        
        FOR i IN v_obiecte.FIRST..v_obiecte.LAST LOOP
            IF v_obiecte(i).aparitii > maxim THEN
                maxim := v_obiecte(i).aparitii;
            END IF;
        END LOOP;
        
        FOR i IN tipuri_date.certificari.FIRST..tipuri_date.certificari.LAST LOOP
            FOR j IN v_obiecte.FIRST..v_obiecte.LAST LOOP
                IF UPPER(v_obiecte(j).certificare) = UPPER(tipuri_date.certificari(i))
                AND v_obiecte(j).aparitii = maxim
                THEN
                    SELECT song_name INTO cantec FROM song 
                    WHERE id_song = v_obiecte(j).cantec_id;
                    gasit := TRUE;
                    EXIT;
                END IF;
            END LOOP;
            
            IF gasit = TRUE THEN
                EXIT;
            END IF;
        END LOOP;
    RETURN cantec;
    END cantec_popular;

    PROCEDURE cantece_artist
    IS
        TYPE refcursor IS REF CURSOR;
        CURSOR c_artist IS
            SELECT artist_name,
            CURSOR (SELECT DISTINCT song_name
                    FROM song s JOIN album al USING (id_album)
                                JOIN song_playlist sp USING (id_song)
                    WHERE id_artist = a.id_artist
                    AND sp.is_favorite = 1)
            FROM artist a;
                
        v_nume_artist artist.artist_name%TYPE;
        v_cursor refcursor;
        v_nume_cantec song.song_name%TYPE;
        verif_cantec NUMBER := 0;
        ok BOOLEAN := FALSE;
        
        fara_cantece EXCEPTION;
        fara_like EXCEPTION;
        
        BEGIN
        OPEN c_artist;
        LOOP
            FETCH c_artist INTO v_nume_artist, v_cursor;
            EXIT WHEN c_artist%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('ARTIST '||v_nume_artist);
            ok := FALSE;
            LOOP
                FETCH v_cursor INTO v_nume_cantec;
                IF v_cursor%NOTFOUND THEN
                    IF ok = FALSE THEN
                        BEGIN
                            SELECT COUNT(id_song) INTO verif_cantec
                            FROM song s JOIN album al USING (id_album)
                                        JOIN artist ar USING (id_artist)
                            WHERE UPPER(ar.artist_name) = UPPER(v_nume_artist);
                            
                            IF verif_cantec = 0 THEN
                                RAISE fara_cantece;
                            ELSE
                                RAISE fara_like;
                            END IF;
                            
                            EXCEPTION
                                WHEN fara_like THEN
                                    DBMS_OUTPUT.PUT_LINE('Nu exista cantece care sa fi fost apreciate');
                                WHEN fara_cantece THEN
                                    DBMS_OUTPUT.PUT_LINE('Nu exista cantece inregistrate pentru acest artist');
                        END;
                    END IF;
                    EXIT WHEN v_cursor%NOTFOUND;
                ELSE
                    ok := TRUE;
                    DBMS_OUTPUT.PUT_LINE (v_nume_cantec);
                END IF;
            END LOOP;
        END LOOP;
        CLOSE c_artist;
    END cantece_artist;
    
    PROCEDURE artist_favorit(nume_user user_log.username%TYPE)
    IS
        TYPE tablou_indexat IS TABLE OF artist.artist_name%TYPE INDEX BY PLS_INTEGER;
        nume_artist tablou_indexat;
        user_gasit user_log.username%TYPE;
        nr_playlisturi NUMBER := 0;
        fara_playlist EXCEPTION;
    BEGIN
        BEGIN
            SELECT id_user INTO user_gasit FROM user_log
            WHERE UPPER(username) = UPPER(nume_user);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Utilizatorul dat nu se afla in baza de date');
                    RAISE_APPLICATION_ERROR(-20006, 'Utilizatorul dat nu se afla in baza de date');
        END;
        
        BEGIN
            SELECT COUNT(id_playlist) INTO nr_playlisturi
            FROM playlist
            WHERE id_user = user_gasit;
            IF nr_playlisturi = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Utilizatorul dat nu si-a facut niciun playlist');
                RAISE_APPLICATION_ERROR(-20007, 'Utilizatorul dat nu si-a facut niciun playlist');
            END IF;
            
        END;
                    
        WITH ARTISTI AS(
            SELECT artist_name AS nume FROM artist ar INNER JOIN album al ON ar.id_artist = al.id_artist
                                                      INNER JOIN song s ON al.id_album  = s.id_album 
                                                      INNER JOIN song_playlist sp ON sp.id_song  = s.id_song 
                                                      INNER JOIN playlist p ON sp.id_playlist  = p.id_playlist 
                                                      INNER JOIN user_log u ON p.id_user  = u.id_user
            WHERE UPPER(username) = UPPER(nume_user))
        SELECT nume BULK COLLECT INTO nume_artist
        FROM artisti
        GROUP BY nume
        HAVING COUNT(*) = ( SELECT MAX(artist_favorit)
                            FROM (SELECT nume, COUNT(*) AS artist_favorit
                                  FROM artisti GROUP BY nume) artisti);
        
        IF nume_artist.COUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE(nume_artist(1));
        ELSE
            DBMS_OUTPUT.PUT_LINE('Utilizatorul are mai multi artisti favoriti');      
            FOR i IN nume_artist.FIRST..nume_artist.LAST LOOP
                DBMS_OUTPUT.PUT_LINE(i || '. ' || nume_artist(i));
            END LOOP;
        END IF;
             
    END artist_favorit;

    PROCEDURE create_audit_trigger(p_tab VARCHAR2)
    IS
        l_now TIMESTAMP := systimestamp;
    BEGIN
        FOR i IN (SELECT column_name FROM all_tab_columns
              WHERE UPPER(table_name) = UPPER(p_tab)
              AND owner = 'C##MARA')
        LOOP
            INSERT INTO col_debug VALUES (seq_audit.NEXTVAL, l_now, i.column_name, p_tab);
            DBMS_OUTPUT.PUT_LINE(i.column_name);
        END LOOP;
    END create_audit_trigger;

END cerinte;
/


UPDATE album SET colaboratori = NULL;
SET SERVEROUTPUT ON
SELECT cerinte.maxim_colaborari FROM DUAL;

UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Billy Idol', 6), r_colaborator('Joan Jett', 10))
WHERE id_album = 3;
UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Quavo', 7), r_colaborator('Lauren Jauregui', 11), r_colaborator('Cashmere Cat', 14))
WHERE id_album = 4;            
UPDATE album
SET colaboratori = t_colaborator(r_colaborator('Labrinth', 2), r_colaborator('Ed Sheeran', 12), r_colaborator('Lana Del Rey', 13))
WHERE id_album = 13;
SELECT cerinte.maxim_colaborari FROM DUAL;

UPDATE album SET colaboratori = t_colaborator(r_colaborator('Dominic Fike', 6), r_colaborator('Alanis Morissette', 11), r_colaborator('SUGA', 13))
WHERE id_album = 18;

SELECT cerinte.maxim_colaborari FROM DUAL;
SET SERVEROUTPUT OFF


EXECUTE tipuri_date.creare_certificari;

SET SERVEROUTPUT ON
SELECT cerinte.cantec_popular('queen') AS "Cel mai popular cantec de la un artist dat" FROM dual;          
SELECT cerinte.cantec_popular('halsey') AS "Cel mai popular cantec de la un artist dat" FROM dual;          
SELECT cerinte.cantec_popular('arctic monkeys') AS "Cel mai popular cantec de la un artist dat" FROM dual;
SET SERVEROUTPUT OFF

EXECUTE cerinte.cantece_artist;

EXECUTE cerinte.artist_favorit('user3');   
EXECUTE cerinte.artist_favorit('user2');    
EXECUTE cerinte.artist_favorit('user6');   
EXECUTE cerinte.artist_favorit('user7');   


CREATE OR REPLACE PACKAGE spotify AS
    PROCEDURE top5(utilizator user_log.username%TYPE); 
    PROCEDURE cantece_asemanatoare(utilizator user_log.username%TYPE);
    PROCEDURE hot_lastYear;
END spotify;
/

CREATE OR REPLACE PACKAGE BODY spotify AS
    PROCEDURE top5(utilizator user_log.username%TYPE)
    IS
        TYPE proc_gen IS RECORD
            (nume_gen genre.genre_name%TYPE,
             procent FLOAT);
        TYPE vector IS VARRAY(5) OF proc_gen;
        v vector:= vector();
        nr_gen NUMBER;
        poz NUMBER := 1;
    BEGIN
        SELECT COUNT(g.genre_name)
        INTO nr_gen
        FROM playlist p JOIN song_playlist sp ON p.id_playlist = sp.id_playlist
                        JOIN song s ON sp.id_song = s.id_song
                        JOIN genre g ON s.id_genre = g.id_genre
        WHERE p.id_user = (SELECT id_user FROM user_log WHERE UPPER(username) = UPPER(utilizator));
        FOR c_proc IN (SELECT DISTINCT g.genre_name, count(s.id_song)/nr_gen procent FROM playlist p JOIN song_playlist sp ON p.id_playlist = sp.id_playlist
                                                                                                     JOIN song s ON sp.id_song = s.id_song
                                                                                                     JOIN genre g ON s.id_genre = g.id_genre
                       WHERE p.id_user = (SELECT id_user FROM user_log WHERE UPPER(username) = UPPER(utilizator))
                       GROUP BY g.genre_name
                       ORDER BY procent DESC, g.genre_name) LOOP
            IF poz = 6 THEN
                EXIT;
            END IF;
            v.EXTEND;
            v(poz).nume_gen := c_proc.genre_name;
            v(poz).procent := c_proc.procent;
            poz := poz + 1;
        END LOOP;
        
        FOR i IN v.FIRST..v.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(v(i).nume_gen || ' ' || v(i).procent*100 || '%');
        END LOOP;
    END top5;

    
    PROCEDURE cantece_asemanatoare(utilizator user_log.username%TYPE)
    IS
        TYPE tablou_indexat IS TABLE OF song.id_song%TYPE INDEX BY PLS_INTEGER;
        v tablou_indexat;
        poz NUMBER := 1;
        contor NUMBER := 1;
        gasit BOOLEAN := FALSE;
        v_cantec song.song_name%TYPE;
    BEGIN
        FOR gen IN (SELECT DISTINCT g.id_genre, g.genre_name FROM playlist p JOIN song_playlist sp ON p.id_playlist = sp.id_playlist
                                                                             JOIN song s ON sp.id_song = s.id_song
                                                                             JOIN genre g ON s.id_genre = g.id_genre
                    WHERE p.id_user = (SELECT id_user FROM user_log WHERE UPPER(username) = UPPER(utilizator))) LOOP
            FOR cantec IN (SELECT DISTINCT id_song, song_name FROM song JOIN song_playlist USING (id_song)
                           WHERE id_playlist IN (SELECT id_playlist FROM playlist
                                                 WHERE id_user = (SELECT id_user FROM user_log WHERE UPPER(username) = UPPER(utilizator)))
                           AND song.id_genre = (SELECT id_genre FROM genre
                                                WHERE genre_name = gen.genre_name)
                           AND song_playlist.is_favorite = 1) LOOP
                v(poz) := cantec.id_song;
                poz := poz + 1;
            END LOOP;
        END LOOP;
            
        DBMS_OUTPUT.PUT_LINE('Songs you might like');
            
        FOR id_cantec IN (SELECT id_song FROM song WHERE certification IN ('Multi-platinum', 'Platinum', 'Diamond')) LOOP
            IF contor = 11 THEN
                EXIT;
            END IF;
            gasit := FALSE;
            FOR i IN v.FIRST..v.LAST LOOP
                IF v(i) = id_cantec.id_song THEN
                    gasit := TRUE;
                    EXIT;
                END IF;
            END LOOP;
            
            IF gasit = FALSE THEN
                SELECT song_name
                INTO v_cantec
                FROM song
                WHERE id_song = id_cantec.id_song;
                DBMS_OUTPUT.PUT_LINE(contor || '. ' || v_cantec);
                contor := contor + 1;
            END IF;
        END LOOP;    
    END cantece_asemanatoare;
    
    PROCEDURE hot_lastYear IS
        obiect rank_album;
        nr_album album.id_album%TYPE;
        TYPE tip_album IS RECORD(titlu_album album.album_name%TYPE, aparitii NUMBER);
        TYPE tablou_indexat IS TABLE OF tip_album INDEX BY PLS_INTEGER;
        vector tablou_indexat;
        poz NUMBER := 1;
        maxim NUMBER := 0;
        nume_album album.album_name%TYPE;
        CURSOR c IS
            SELECT id_album FROM album WHERE EXTRACT(YEAR FROM release_date) = EXTRACT(YEAR FROM SYSDATE)-1;
    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO nr_album;
            EXIT WHEN c%NOTFOUND;
            SELECT album_name INTO vector(poz).titlu_album
            FROM album
            WHERE id_album = nr_album;
            obiect := rank_album(nr_album);
            vector(poz).aparitii := obiect.aparitii_albume(obiect.album_id);
            poz := poz + 1;
        END LOOP;
        CLOSE c;
        
        FOR i IN vector.FIRST..vector.LAST LOOP
            IF vector(i).aparitii > maxim THEN
                maxim := vector(i).aparitii;
                nume_album := vector(i).titlu_album;
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(nume_album);
    END hot_lastYear;
END spotify;
/

EXECUTE spotify.cantece_asemanatoare('user3');
EXECUTE spotify.top5('user3');
EXECUTE spotify.hot_lastYear;
