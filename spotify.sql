-- Section 6
-- Package implementing functionalities alike the ones provided by Spotify

CREATE OR REPLACE PACKAGE spotify AS
    PROCEDURE top5(utilizator user_log.username%TYPE);                  -- will print a user's top 5 musical genres, based on the songs found in his/her playlists
    
    PROCEDURE cantece_asemanatoare(utilizator user_log.username%TYPE);  -- will print a list of 10 songs which might be of interest to the user (also based
                                                                        -- on the already existent songs in his/her playlists)
                                                                        
    PROCEDURE hot_lastYear;                                             -- last year's most popular album (based on the number of appearences of the album's songs
                                                                        -- in every playlist from the database)
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