-- Section 5

CREATE OR REPLACE TRIGGER upgrade_account   -- trigger doesn't allow upgrading accounts (from free to premium)
                                            -- between the 3rd and 10th day of a month
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

CREATE OR REPLACE TRIGGER nr_playlisturi    -- trigger doesn't allow a user with a free account to
                                            -- create more than 3 playlists
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


CREATE TABLE col_debug (
    id_bug NUMBER(6) NOT NULL,
    ts TIMESTAMP,
    col_name VARCHAR2(50),
    table_name VARCHAR2(50)
);
CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER audit_trigger_update  -- trigger keeps track of all modifications made to the tables
AFTER ALTER OR CREATE OR DROP ON SCHEMA
DECLARE
	j int;
BEGIN
	IF ORA_DICT_OBJ_TYPE = 'TABLE' THEN
		dbms_job.submit(j,'create_audit_trigger('''||ORA_DICT_OBJ_NAME||''');');
	END IF;
END;
/