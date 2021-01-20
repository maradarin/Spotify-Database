-- Section 4

CREATE OR REPLACE PACKAGE cerinte AS
    FUNCTION maxim_colaborari
        RETURN artist.artist_name%TYPE;                             -- will return the name of the artist who has collaborated with the greatest number of artists
    FUNCTION cantec_popular(nume_artist artist.artist_name%TYPE)
        RETURN song.song_name%TYPE;                                 -- will return a given artist's most popular song (has to be included on users' playlists and
                                                                    -- has to be marked as favorite)
                                                                    -- tie-breaking criteria in case too many results have been found: the song's certification
                                                                    
    PROCEDURE cantece_artist;                                       -- print for each artist a list of songs which have been appreciated by the users
    
    PROCEDURE artist_favorit(nume_user user_log.username%TYPE);     -- given a username, show the user's most played artists (the artist that has appeared the most
                                                                    -- on his/her playlists)
                                                                    
    PROCEDURE create_audit_trigger(p_tab VARCHAR2);                 -- procedure used to insert data into an audit table used for an DDL trigger
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