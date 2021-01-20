-- Section 2
-- Package used to insert automatically data into
-- the tables
-- Package also includes dynamic and automatic
-- update of sequences to prevent data loss,
-- skipping of indexes or overlapping

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