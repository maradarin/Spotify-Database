-- Section 1
-- Package used to dynamically create the data structures needed
-- for the project, such as:
-- Tabels and user-defined objects

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