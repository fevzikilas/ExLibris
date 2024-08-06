--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_admin(character varying, character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_admin(IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_password character varying, IN p_phone_number character varying, OUT p_admin_id integer)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	INSERT INTO admin(firstname, last_name, email, username, password, phone_number)
 	VALUES (p_first_name, p_last_name, p_email, p_username, p_password,p_phone_number)
 	RETURNING admin_id INTO p_admin_id;
 END;
 $$;


ALTER PROCEDURE public.add_admin(IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_password character varying, IN p_phone_number character varying, OUT p_admin_id integer) OWNER TO postgres;

--
-- Name: add_author(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_author(IN p_first_name character varying, IN p_last_name character varying, IN p_nationality character varying, OUT p_author_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO author(first_name, last_name, nationality)
    VALUES (p_first_name, p_last_name, p_nationality)
    RETURNING author_id INTO p_author_id;
END;

$$;


ALTER PROCEDURE public.add_author(IN p_first_name character varying, IN p_last_name character varying, IN p_nationality character varying, OUT p_author_id integer) OWNER TO postgres;

--
-- Name: add_banned_user(integer, integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_banned_user(IN p_user_id integer, IN p_admin_id integer, IN p_report text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO banned_user(user_id, admin_id, report)
    VALUES (p_user_id, p_admin_id, p_report);
END;
$$;


ALTER PROCEDURE public.add_banned_user(IN p_user_id integer, IN p_admin_id integer, IN p_report text) OWNER TO postgres;

--
-- Name: add_branch(character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_branch(IN p_branch_code character varying, IN p_shelf_id integer, OUT p_branch_id integer)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	INSERT INTO branch(branch_code, shelf_id)
 	VALUES (p_branch_code, p_shelf_id)
 	RETURNING branch_id INTO p_branch_id;
 END;
 $$;


ALTER PROCEDURE public.add_branch(IN p_branch_code character varying, IN p_shelf_id integer, OUT p_branch_id integer) OWNER TO postgres;

--
-- Name: add_genre(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_genre(IN p_genre_name character varying, OUT p_genre_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO genre(genre_name)
    VALUES (p_genre_name)
    RETURNING genre_id INTO p_genre_id;
END;
$$;


ALTER PROCEDURE public.add_genre(IN p_genre_name character varying, OUT p_genre_id integer) OWNER TO postgres;

--
-- Name: add_heading(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_heading(IN p_heading character varying, OUT p_heading_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO heading(heading)
    VALUES (p_heading)
    RETURNING heading_id INTO p_heading_id;
END;
$$;


ALTER PROCEDURE public.add_heading(IN p_heading character varying, OUT p_heading_id integer) OWNER TO postgres;

--
-- Name: add_item_format(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_item_format(IN p_format_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

    INSERT INTO item_format(format_name)
    VALUES (p_format_name);
END;
$$;


ALTER PROCEDURE public.add_item_format(IN p_format_name character varying) OWNER TO postgres;

--
-- Name: add_item_heading(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_item_heading(IN p_item_id integer, IN p_heading_name character varying, OUT p_heading_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_heading_id INTEGER;
BEGIN
    SELECT heading_id FROM heading WHERE heading = p_heading_name INTO p_heading_id;
    IF p_heading_id is null THEN
        CALL add_heading(p_heading_name, p_heading_id);
    END IF;

    INSERT INTO item_heading(heading_id ,item_id)
    VALUES (p_heading_id ,p_item_id);
END;

$$;


ALTER PROCEDURE public.add_item_heading(IN p_item_id integer, IN p_heading_name character varying, OUT p_heading_id integer) OWNER TO postgres;

--
-- Name: add_item_list(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_item_list(IN p_list_id integer, IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_on_conflict integer;
BEGIN
    select 1 from item_list where item_id = p_item_id and list_id = p_list_id into p_on_conflict;
    IF p_on_conflict IS NULL THEN
        INSERT INTO item_list(list_id, item_id)
        VALUES (p_list_id, p_item_id);
    ELSE
        RAISE NOTICE 'Item is already in the list!!';
    END IF;
end;
$$;


ALTER PROCEDURE public.add_item_list(IN p_list_id integer, IN p_item_id integer) OWNER TO postgres;

--
-- Name: add_language(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_language(IN p_language_name character varying, OUT p_language_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO language(language_name)
    VALUES (p_language_name)
    RETURNING language_id INTO p_language_id;
END;
$$;


ALTER PROCEDURE public.add_language(IN p_language_name character varying, OUT p_language_id integer) OWNER TO postgres;

--
-- Name: add_lost_item(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_lost_item(IN p_item_id integer, IN p_admin_id integer)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	INSERT INTO lost_item (item_id, admin_id, report_date)
 	VALUES (p_item_id, p_admin_id, NOW())
 	ON CONFLICT (item_id) DO NOTHING;
 END;
 $$;


ALTER PROCEDURE public.add_lost_item(IN p_item_id integer, IN p_admin_id integer) OWNER TO postgres;

--
-- Name: add_maintenance_history(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_maintenance_history(IN p_item_id integer, IN p_admin_id integer)
    LANGUAGE plpgsql
    AS $$
    DECLARE
        p_maintenance_date DATE;
        p_description text;
        p_is_exist BOOLEAN;
    BEGIN
          SELECT 1 FROM maintenance_log WHERE item_id = p_item_id INTO p_is_exist;
          IF p_is_exist THEN
                SELECT maintenance_date FROM maintenance_log WHERE item_id = p_item_id INTO p_maintenance_date;
                SELECT description FROM maintenance_log WHERE item_id = p_item_id INTO p_description;

                INSERT INTO maintenance_history (item_id, admin_id, maintenance_date, description, maintenance_end_date)
                VALUES (p_item_id, p_admin_id, p_maintenance_date::DATE, p_description::text , now());
          ELSE
              RAISE EXCEPTION 'Record does not exist.';
          END IF;
    END;
$$;


ALTER PROCEDURE public.add_maintenance_history(IN p_item_id integer, IN p_admin_id integer) OWNER TO postgres;

--
-- Name: add_maintenance_log(integer, integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_maintenance_log(IN p_item_id integer, IN p_admin_id integer, IN p_description text)
    LANGUAGE plpgsql
    AS $$
 	DECLARE
     	p_item_status varchar;
 	BEGIN
     	SELECT status FROM item WHERE item_id = p_item_id INTO p_item_status;
     	IF p_item_status = 'available' THEN
         	INSERT INTO maintenance_log (item_id, admin_id, maintenance_date, description)
         	VALUES (p_item_id, p_admin_id, NOW(), p_description);
     	ELSE
         	RAISE EXCEPTION 'Item is not available. Update item status first to start maintenance process.';
     	END IF;
 	END
 $$;


ALTER PROCEDURE public.add_maintenance_log(IN p_item_id integer, IN p_admin_id integer, IN p_description text) OWNER TO postgres;

--
-- Name: add_multimedia_item(character varying, date, character varying, character varying, integer, integer, character varying, integer, character varying, integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_multimedia_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_size integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_status character varying, OUT p_item_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
 BEGIN
 	SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;


 	INSERT INTO item(name, publication_date, format_id, publisher_id, language_id,
         	serie_id, branch_id, admin_id, status, barcode, register_date, rate, rated_user_number, genre_id)
         	VALUES (p_name, p_publication_date, 1::integer, p_publisher_id, p_language_id,
         	p_serie_id, p_branch_id, p_admin_id, p_status, p_barcode, NOW(),
         	0, 0, p_genre_id)
 	RETURNING item_id INTO p_item_id;

 	INSERT INTO multimedia_item(item_id, size)
 	VALUES (p_item_id, p_size);

 	COMMIT;
 END;

 $$;


ALTER PROCEDURE public.add_multimedia_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_size integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_status character varying, OUT p_item_id integer) OWNER TO postgres;

--
-- Name: add_nonperiodical_item(character varying, date, character varying, character varying, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_nonperiodical_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_status character varying, IN p_author_first_name character varying, IN p_author_last_name character varying, IN p_author_nationality character varying, IN p_isbn integer, IN p_edition integer, IN p_page_number integer, OUT p_item_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
 	p_author_id INTEGER;
 BEGIN
 	SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;
 	SELECT author_id FROM author WHERE first_name = p_author_first_name and last_name = p_author_last_name and
                                    	nationality = p_author_nationality INTO p_author_id;
 	IF p_author_id is null THEN
     	CALL add_author(p_author_first_name, p_author_last_name, p_author_nationality, p_author_id);
 	END IF;

 	INSERT INTO item(name, publication_date, format_id, publisher_id, language_id,
         	serie_id, branch_id, admin_id, status, barcode, register_date, rate, rated_user_number, genre_id)
         	VALUES (p_name, p_publication_date, 2::integer, p_publisher_id, p_language_id,
         	p_serie_id, p_branch_id, p_admin_id, p_status, p_barcode, NOW(),
         	0, 0, p_genre_id)
 	RETURNING item_id INTO p_item_id;

 	INSERT INTO nonperiodical_item(item_id, author_id, isbn, edition, page_number )
 	VALUES (p_item_id, p_author_id, p_isbn, p_edition, p_page_number);

 	COMMIT;
 END;
 $$;


ALTER PROCEDURE public.add_nonperiodical_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_status character varying, IN p_author_first_name character varying, IN p_author_last_name character varying, IN p_author_nationality character varying, IN p_isbn integer, IN p_edition integer, IN p_page_number integer, OUT p_item_id integer) OWNER TO postgres;

--
-- Name: add_periodical_item(character varying, date, character varying, character varying, integer, integer, character varying, character varying, integer, character varying, integer, boolean, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_periodical_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_frequency character varying, IN p_volume_number integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_living boolean, IN p_status character varying, OUT p_item_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
 BEGIN
 	SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;


 	INSERT INTO item(name, publication_date, format_id, publisher_id, language_id,
         	serie_id, branch_id, admin_id, status, barcode, register_date, rate, rated_user_number, genre_id)
         	VALUES (p_name, p_publication_date, 3::integer, p_publisher_id, p_language_id,
         	p_serie_id, p_branch_id, p_admin_id, p_status, p_barcode, NOW(),
         	0, 0, p_genre_id)
 	RETURNING item_id INTO p_item_id;

 	INSERT INTO periodical_item (item_id, frequency, volume_number, living)
 	VALUES (p_item_id, p_frequency, p_volume_number, p_living);

 	COMMIT;
 END;

 $$;


ALTER PROCEDURE public.add_periodical_item(IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_admin_id integer, IN p_barcode character varying, IN p_frequency character varying, IN p_volume_number integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_living boolean, IN p_status character varying, OUT p_item_id integer) OWNER TO postgres;

--
-- Name: add_publisher(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_publisher(IN p_publisher_name character varying, OUT p_publisher_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO publisher(publisher_name)
    VALUES (p_publisher_name)
    RETURNING publisher_id INTO p_publisher_id;
END;

$$;


ALTER PROCEDURE public.add_publisher(IN p_publisher_name character varying, OUT p_publisher_id integer) OWNER TO postgres;

--
-- Name: add_rate(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_rate(IN p_item_id integer, IN p_user_id integer, IN p_rate integer)
    LANGUAGE plpgsql
    AS $$
    DECLARE
        is_rated BOOLEAN;
        p_old_rate INTEGER;
        p_rated_user_number INTEGER;
        p_new_rate numeric(4, 2);
        is_rented_x BOOLEAN;
        is_rented_y BOOLEAN;
    BEGIN
        SELECT TRUE FROM return_history WHERE item_id = p_item_id AND user_id = p_user_id INTO is_rented_x;
        SELECT TRUE FROM rental_log WHERE item_id = p_item_id AND user_id = p_user_id INTO is_rented_y;

        IF is_rented_x or is_rented_y THEN
            SELECT 1 FROM rating WHERE user_id = p_user_id AND item_id = p_item_id INTO is_rated;
            SELECT rate, rated_user_number FROM item WHERE item.item_id = p_item_id INTO p_old_rate, p_rated_user_number;

            IF is_rated is NULL THEN
                INSERT INTO rating(user_id, item_id, rate)
                VALUES (p_user_id, p_item_id, p_rate);
                p_new_rate = ((p_rated_user_number::numeric(4, 2) * p_old_rate::numeric(4, 2) + p_rate::numeric(4, 2)) / (p_rated_user_number + 1))::numeric(4, 2);

                UPDATE item
                SET rate = p_new_rate, rated_user_number = rated_user_number + 1
                WHERE item_id = p_item_id;
            ELSE
                RAISE EXCEPTION 'Item was already rated by the user.';
            END IF;
        ELSE
            RAISE EXCEPTION 'Item has never been rented before by the user.';
        END IF;
    END;
$$;


ALTER PROCEDURE public.add_rate(IN p_item_id integer, IN p_user_id integer, IN p_rate integer) OWNER TO postgres;

--
-- Name: add_rental(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_rental(IN p_item_id integer, IN p_user_id integer, IN p_admin_id integer)
    LANGUAGE plpgsql
    AS $$
   DECLARE
       p_rental_counter SMALLINT;
       p_user_type_id SMALLINT;
       p_max_rental SMALLINT;
       p_rental_time SMALLINT;
       p_item_status varchar;
       p_reservation_state varchar;
   BEGIN


       SELECT user_account.rental_counter, user_account.user_type_id, ut.max_rental, ut.rental_time
       FROM user_account LEFT JOIN user_type ut on user_account.user_type_id = ut.user_type_id
       WHERE user_id = p_user_id INTO p_rental_counter, p_user_type_id, p_max_rental, p_rental_time;


       SELECT status FROM item WHERE item_id = p_item_id INTO p_item_status;


       SELECT state FROM reservation WHERE item_id = p_item_id AND user_id = p_user_id INTO p_reservation_state;


       IF p_rental_counter < p_max_rental AND p_item_status = 'available' THEN
           INSERT INTO rental_log (item_id, user_id, rent_date, due_date, admin_id, extratime_counter)
           VALUES (p_item_id, p_user_id, NOW(), (NOW() + (p_rental_time || ' day')::interval)::DATE, p_admin_id, 0);
       ELSIF p_reservation_state = 'valid' THEN
           CALL delete_reservation(p_item_id, p_user_id);
           INSERT INTO rental_log (item_id, user_id, rent_date, due_date, admin_id, extratime_counter)
           VALUES (p_item_id, p_user_id, NOW(), (NOW() + (p_rental_time || ' day')::interval)::DATE, p_admin_id, 0);
       ELSE
           RAISE EXCEPTION 'Item is not available or user has max item.';
       END IF;
   END
$$;


ALTER PROCEDURE public.add_rental(IN p_item_id integer, IN p_user_id integer, IN p_admin_id integer) OWNER TO postgres;

--
-- Name: add_reservation(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_reservation(IN p_item_id integer, IN p_user_id integer)
    LANGUAGE plpgsql
    AS $$
    DECLARE
        p_rental_counter SMALLINT;
        p_user_type_id SMALLINT;
        p_max_rental SMALLINT;
        p_item_status varchar;
    BEGIN
        SELECT rental_counter, user_type_id FROM user_account WHERE user_id = p_user_id INTO p_rental_counter, p_user_type_id;
        SELECT max_rental FROM user_type WHERE user_type_id = p_user_type_id INTO p_max_rental;
        SELECT status FROM item WHERE item_id = p_item_id INTO p_item_status;

        IF p_rental_counter < p_max_rental AND p_item_status != 'available' AND p_item_status != 'reserved' AND p_item_status != 'lost' THEN
            INSERT INTO reservation(user_id, item_id, state)
            VALUES (p_user_id, p_item_id, 'invalid');
        ELSE
            RAISE EXCEPTION 'Item is available to rent or already reserved or user has max item.';
        END IF;
    END;
$$;


ALTER PROCEDURE public.add_reservation(IN p_item_id integer, IN p_user_id integer) OWNER TO postgres;

--
-- Name: add_return_history(integer, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_return_history(IN p_item_id integer, IN p_description text)
    LANGUAGE plpgsql
    AS $$
    DECLARE
        p_user_id integer;
        p_due_date DATE;
        p_admin_id INTEGER;
        p_rent_date DATE;
        p_penalty_fee INTEGER;
        p_user_type_id INTEGER;
        p_penalty INTEGER;
        p_is_late BOOLEAN;
        p_is_exist BOOLEAN;
    BEGIN
          SELECT 1 FROM rental_log WHERE item_id = p_item_id INTO p_is_exist;
          IF p_is_exist THEN
                SELECT due_date, admin_id, rent_date, user_id FROM rental_log WHERE item_id = p_item_id INTO p_due_date, p_admin_id, p_rent_date, p_user_id;
                SELECT user_type_id FROM user_account WHERE user_id = p_user_id INTO p_user_type_id;
                SELECT penalty_fee FROM user_type WHERE user_type_id = p_user_type_id INTO p_penalty_fee;
                p_is_late = NOW()::DATE > p_due_date;
                IF p_is_late THEN
                    p_penalty = p_penalty_fee * (NOW()::DATE - p_due_date::DATE);
                ELSE
                    p_penalty = 0;
                end if;
                INSERT INTO return_history (item_id, admin_id, user_id, description, return_date, due_date, is_late, received_fee, rent_date)
                VALUES (p_item_id, p_admin_id, p_user_id, p_description , NOW()::DATE, p_due_date, p_is_late, p_penalty, p_rent_date);
          ELSE
              RAISE EXCEPTION 'Record does not exist!!';
          END IF;
    END;
$$;


ALTER PROCEDURE public.add_return_history(IN p_item_id integer, IN p_description text) OWNER TO postgres;

--
-- Name: add_serie(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_serie(IN p_serie_name character varying, OUT p_serie_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO serie(serie_name)
    VALUES (p_serie_name)
    RETURNING serie_id INTO p_serie_id;
END;

$$;


ALTER PROCEDURE public.add_serie(IN p_serie_name character varying, OUT p_serie_id integer) OWNER TO postgres;

--
-- Name: add_shelf(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_shelf(IN p_shelf_code character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO shelf(shelf_code)
    VALUES (p_shelf_code);
END;

$$;


ALTER PROCEDURE public.add_shelf(IN p_shelf_code character varying) OWNER TO postgres;

--
-- Name: add_user_account(character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, boolean, smallint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_user_account(IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_password character varying, IN p_phone_number character varying, IN p_admin_id integer, IN p_id_number character varying, IN p_banned boolean, IN p_user_type_id smallint, OUT p_user_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO user_account(
    first_name, last_name, user_type_id, email, username, password,
    phone_number, rental_counter, admin_id, id_number, banned)
VALUES (
    p_first_name, p_last_name, p_user_type_id, p_email, p_username,
    p_password, p_phone_number, 0, p_admin_id, p_id_number,
    p_banned)
RETURNING user_id INTO p_user_id;
END
$$;


ALTER PROCEDURE public.add_user_account(IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_password character varying, IN p_phone_number character varying, IN p_admin_id integer, IN p_id_number character varying, IN p_banned boolean, IN p_user_type_id smallint, OUT p_user_id integer) OWNER TO postgres;

--
-- Name: add_user_to_list(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_user_to_list(IN p_user_id integer, IN p_list_name character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO list(user_id, list_name)
        VALUES (p_user_id, p_list_name);
    end;
$$;


ALTER PROCEDURE public.add_user_to_list(IN p_user_id integer, IN p_list_name character varying) OWNER TO postgres;

--
-- Name: add_user_type(character varying, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_user_type(IN p_type_name character varying, IN p_max_extratime integer, IN p_max_rental integer, IN p_max_reservation_day integer, IN p_penalty_fee integer, IN p_rental_time integer, OUT p_user_type_id integer)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	INSERT INTO user_type(type_name, max_extratime, max_rental, max_reservation_day, rental_time, penalty_fee)
 	VALUES (p_type_name, p_max_extratime, p_max_rental, p_max_reservation_day, p_rental_time, p_penalty_fee)
 	RETURNING user_type_id INTO p_user_type_id;
 END;
 $$;


ALTER PROCEDURE public.add_user_type(IN p_type_name character varying, IN p_max_extratime integer, IN p_max_rental integer, IN p_max_reservation_day integer, IN p_penalty_fee integer, IN p_rental_time integer, OUT p_user_type_id integer) OWNER TO postgres;

--
-- Name: delete_ban(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_ban(IN p_user_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM banned_user
    WHERE user_id = p_user_id;
END;
$$;


ALTER PROCEDURE public.delete_ban(IN p_user_id integer) OWNER TO postgres;

--
-- Name: delete_branch(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_branch(IN p_branch_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_branch_counter INTEGER := 0;
BEGIN
    select count(item_id) from item where branch_id = p_branch_id into p_branch_counter;
    IF p_branch_counter = 0 THEN
        DELETE FROM branch
        WHERE branch_id = p_branch_id;
    ELSE
        RAISE EXCEPTION 'Cannot delete branch, branch has item.';
    end if;
END;
$$;


ALTER PROCEDURE public.delete_branch(IN p_branch_id integer) OWNER TO postgres;

--
-- Name: delete_item(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_item(IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_item_status varchar;
 	p_item_format varchar;
 	p_item_counter INTEGER := 0;
 BEGIN
 	select status from item where item_id = p_item_id into p_item_status;

 	SELECT item_format.format_name
 	FROM item JOIN item_format ON item.format_id = item_format.format_id
 	WHERE item.item_id = p_item_id
 	into p_item_format;

 	select count(item_id) from item where item_id = p_item_id into p_item_counter;
 	CASE
     	WHEN p_item_status = 'maintenance' AND p_item_counter <> 0 THEN
         	DELETE FROM item WHERE item_id = p_item_id;
         	DELETE FROM maintenance_log WHERE item_id = p_item_id;
     	WHEN p_item_status = 'lost' AND p_item_counter <> 0 THEN
         	DELETE FROM item WHERE item_id = p_item_id;
    	     DELETE FROM lost_item WHERE item_id = p_item_id;
     	WHEN p_item_status = 'rented' AND p_item_counter <> 0 THEN
         	DELETE FROM item WHERE item_id = p_item_id;
         	DELETE FROM rental_log WHERE item_id = p_item_id;
     	WHEN p_item_status = 'reserved' AND p_item_counter <> 0 THEN
         	DELETE FROM item WHERE item_id = p_item_id;
         	DELETE FROM reservation WHERE item_id = p_item_id;
         	
     	WHEN p_item_format = 'multimedia_item' THEN
             DELETE FROM multimedia_item WHERE item_id = p_item_id;

     	WHEN p_item_format = 'nonperiodical_item' THEN
         	DELETE FROM nonperiodical_item WHERE item_id = p_item_id;

     	WHEN p_item_format = 'periodical_item' THEN
         	DELETE FROM periodical_item WHERE item_id = p_item_id;

     	WHEN p_item_counter <> 0 THEN
         	DELETE FROM item_heading WHERE item_id = p_item_id;
         	DELETE FROM rating WHERE item_id = p_item_id;
         	DELETE FROM item_list WHERE item_id = p_item_id;
         	DELETE FROM return_history WHERE item_id = p_item_id;
         	DELETE FROM maintenance_history WHERE item_id = p_item_id;
         	DELETE FROM access_item_history WHERE item_id = p_item_id;
     	WHEN p_item_counter <> 0 THEN
         	DELETE FROM item WHERE item_id = p_item_id;

 	END CASE;


 END;
 $$;


ALTER PROCEDURE public.delete_item(IN p_item_id integer) OWNER TO postgres;

--
-- Name: delete_item_list(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_item_list(IN p_list_id integer, IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_item_list_counter INTEGER := 0;
BEGIN
    select count(*) from item_list where list_id = p_list_id and item_id = p_item_id into p_item_list_counter;


    IF p_item_list_counter <> 0 THEN
        DELETE FROM item_list
        WHERE list_id = p_list_id and item_id = p_item_id;
    end if;
END;
$$;


ALTER PROCEDURE public.delete_item_list(IN p_list_id integer, IN p_item_id integer) OWNER TO postgres;

--
-- Name: delete_list(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_list(IN p_list_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_list_id_counter INTEGER := 0;
BEGIN
    select list_id from list where list_id = p_list_id into p_list_id_counter;

    IF p_list_id_counter = 0 THEN
        DELETE FROM list
        WHERE list_id = p_list_id;
    end if;
END;
$$;


ALTER PROCEDURE public.delete_list(IN p_list_id integer) OWNER TO postgres;

--
-- Name: delete_lost_item(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_lost_item(IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
       DELETE FROM lost_item
       WHERE item_id = p_item_id;
END;
$$;


ALTER PROCEDURE public.delete_lost_item(IN p_item_id integer) OWNER TO postgres;

--
-- Name: delete_rating(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_rating(IN p_user_id integer, IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM rating
    WHERE user_id = p_user_id AND item_id = p_item_id;
END;
$$;


ALTER PROCEDURE public.delete_rating(IN p_user_id integer, IN p_item_id integer) OWNER TO postgres;

--
-- Name: delete_reservation(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_reservation(IN p_item_id integer, IN p_user_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_reservation_counter INTEGER;
BEGIN
    select 1 from reservation where item_id = p_item_id and user_id = p_user_id  into p_reservation_counter;
    IF p_reservation_counter = 1 THEN
        DELETE FROM reservation
        WHERE item_id = p_item_id and user_id = p_user_id;
    ELSE
       RAISE EXCEPTION 'Item is not reserved.';
    end if;
END;
$$;


ALTER PROCEDURE public.delete_reservation(IN p_item_id integer, IN p_user_id integer) OWNER TO postgres;

--
-- Name: delete_shelf(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_shelf(IN p_shelf_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_shelf_counter INTEGER := 0;
BEGIN

    select count(item_id)
    from item left join branch b on item.branch_id = b.branch_id
    where b.shelf_id = p_shelf_id into p_shelf_counter;

    IF p_shelf_counter = 0 THEN
        DELETE FROM branch
        WHERE shelf_id = p_shelf_id;

        DELETE FROM shelf
        WHERE shelf_id = p_shelf_id;
    else
        raise exception 'Cannot delete shelf!!!';
    end if;
END;
$$;


ALTER PROCEDURE public.delete_shelf(IN p_shelf_id integer) OWNER TO postgres;

--
-- Name: delete_user_account(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_user_account(IN p_user_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_is_rental INTEGER;
 BEGIN
 	select 1 from rental_log where user_id = p_user_id into p_is_rental;
 	IF p_is_rental IS NULL THEN
     	DELETE FROM reservation
     	WHERE user_id = p_user_id;

     	DELETE FROM item_list
     	WHERE list_id IN (select list_id
                      	from list where user_id = p_user_id);

     	DELETE FROM rating
     	WHERE user_id = p_user_id;
     	DELETE FROM list
     	WHERE user_id = p_user_id;
     	DELETE FROM banned_user
     	WHERE user_id = p_user_id;
     	DELETE FROM return_history
     	WHERE user_id = p_user_id;
     	DELETE FROM user_account
     	WHERE user_id = p_user_id;
 	ELSE
     	RAISE EXCEPTION 'User has book to return.';
 	END IF;
 END;

 $$;


ALTER PROCEDURE public.delete_user_account(IN p_user_id integer) OWNER TO postgres;

--
-- Name: delete_user_type(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_user_type(IN p_user_type_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_user_type INTEGER;
BEGIN
    select 1 from user_account where user_type_id = p_user_type_id into p_user_type;
    IF p_user_type THEN
        RAISE EXCEPTION 'Cannot delete user_type.';
    ELSE
        DELETE FROM user_type
        WHERE user_type_id = p_user_type_id;
    END IF;
END;
$$;


ALTER PROCEDURE public.delete_user_type(IN p_user_type_id integer) OWNER TO postgres;

--
-- Name: trg_update_item_list_on_delete_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_list_on_delete_list() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    delete from item_list
    WHERE list_id = OLD.list_id;
    return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_list_on_delete_list() OWNER TO postgres;

--
-- Name: trg_update_item_on_delete_rating(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_on_delete_rating() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    p_rated_user INT;
BEGIN
    SELECT rated_user_number FROM item WHERE item_id = OLD.item_id into p_rated_user;
    IF p_rated_user = 1 THEN
        UPDATE item
        SET rate = 0, rated_user_number = 0
        WHERE item.item_id = OLD.item_id;
    ELSE
        UPDATE item
        SET rate = ((rate * rated_user_number) - OLD.rate) / (rated_user_number - 1),
            rated_user_number = rated_user_number - 1
        WHERE item.item_id = OLD.item_id;
    END IF;
    return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_on_delete_rating() OWNER TO postgres;

--
-- Name: trg_update_item_on_lost_item(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_on_lost_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    status_checker VARCHAR;
BEGIN
    SELECT status FROM item WHERE item_id = NEW.item_id into status_checker;

    IF status_checker = 'lost' OR  status_checker is null THEN
        RAISE NOTICE 'ITEM ALREADY LOST OR NOT EXIST.';
    ELSE
        UPDATE item
        SET status = 'lost'
        WHERE item.item_id = NEW.item_id;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.trg_update_item_on_lost_item() OWNER TO postgres;

--
-- Name: trg_update_item_on_maintenance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_on_maintenance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE item
    SET status = 'maintenance'
    WHERE item.item_id = NEW.item_id;

    return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_on_maintenance() OWNER TO postgres;

--
-- Name: trg_update_item_on_reservation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_on_reservation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE item SET status = 'reserved' WHERE item.item_id = NEW.item_id;

    UPDATE user_account SET rental_counter = rental_counter + 1 WHERE user_account.user_id = NEW.user_id;
    return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_on_reservation() OWNER TO postgres;

--
-- Name: trg_update_item_user_on_delete_reservation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_user_on_delete_reservation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  old_status varchar;
BEGIN
  SELECT 'rented' from rental_log where item_id = OLD.item_id into old_status;
  IF old_status IS NULL THEN
     SELECT 'maintenance' from maintenance_log where item_id = OLD.item_id into old_status;
  END IF;
  IF old_status IS NULL THEN
     SELECT 'lost' from lost_item where item_id = OLD.item_id into old_status;
  END IF;
  IF old_status IS NULL THEN
     old_status = 'available';
  end if;
 
  UPDATE item
  SET status = old_status
  WHERE item.item_id = old.item_id;

  UPDATE user_account
  SET rental_counter  = rental_counter - 1
  WHERE user_account.user_id = old.user_id;
  return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_user_on_delete_reservation() OWNER TO postgres;

--
-- Name: trg_update_item_user_on_rental(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_item_user_on_rental() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 message_text TEXT;
 item_name TEXT;
BEGIN
   UPDATE item
   SET status = 'rented'
   WHERE item.item_id = NEW.item_id;


   UPDATE user_account
   SET rental_counter = rental_counter + 1
   WHERE user_account.user_id = NEW.user_id;


   SELECT name INTO item_name
   FROM item
   WHERE item_id = NEW.item_id;


   message_text := 'You have rented ' || item_name;


   INSERT INTO notifications (message, user_id) VALUES (message_text, NEW.user_id);
   return null;
END;
$$;


ALTER FUNCTION public.trg_update_item_user_on_rental() OWNER TO postgres;

--
-- Name: trg_update_notification_on_update_reservation_state(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_notification_on_update_reservation_state() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   item_name TEXT;
   p_user_type_id INTEGER;
   p_max_reservation_day INTEGER;
   p_reservation_end_date DATE;
   message_text_reservation TEXT;
BEGIN
       SELECT name INTO item_name
       FROM item
       WHERE item_id = NEW.item_id;


       SELECT user_type_id FROM user_account WHERE user_id = NEW.user_id INTO p_user_type_id;
       SELECT max_reservation_day FROM user_type WHERE user_type_id = p_max_reservation_day;


       p_reservation_end_date := CURRENT_DATE + p_max_reservation_day;


       message_text_reservation := item_name || 'you have reserved is now available. It will be reserved for you until ' || p_reservation_end_date;
       INSERT INTO notifications (message, user_id) VALUES (message_text_reservation, NEW.user_id);


       UPDATE reservation
       SET reservation_end_date = p_reservation_end_date
       WHERE item_id = new.item_id;


   RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_update_notification_on_update_reservation_state() OWNER TO postgres;

--
-- Name: trg_update_on_delete_lost_item(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_on_delete_lost_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE item
   SET status = 'available'
   WHERE item_id = OLD.item_id;

   UPDATE reservation
   SET state = 'valid'
   WHERE item_id = new.item_id;

   return null;
END;
$$;


ALTER FUNCTION public.trg_update_on_delete_lost_item() OWNER TO postgres;

--
-- Name: trg_update_on_maintenance_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_on_maintenance_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 old_status varchar;
BEGIN
   DELETE FROM maintenance_log WHERE maintenance_log.item_id = NEW.item_id;


   SELECT 'reserved' from reservation where item_id = OLD.item_id into old_status;
   IF old_status IS NULL THEN
       old_status = 'available';
   end if;
   UPDATE item SET status = old_status WHERE item.item_id = NEW.item_id;
  
   UPDATE reservation
   SET state = 'valid'
   WHERE item_id = new.item_id;


   return null;
END;
$$;


ALTER FUNCTION public.trg_update_on_maintenance_history() OWNER TO postgres;

--
-- Name: trg_update_on_return_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_on_return_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   old_status varchar;
   message_text TEXT;
   item_name TEXT;
BEGIN
   DELETE FROM rental_log WHERE rental_log.item_id = NEW.item_id;


   SELECT 'reserved' from reservation where item_id = NEW.item_id into old_status;
   IF old_status IS NULL THEN
       old_status = 'available';
   end if;
   UPDATE item SET status = old_status WHERE item.item_id = NEW.item_id;


   UPDATE user_account SET rental_counter = rental_counter - 1 WHERE user_account.user_id = NEW.user_id;


   SELECT name INTO item_name
   FROM item
   WHERE item_id = NEW.item_id;


   message_text := 'You have returned ' || item_name;


   INSERT INTO notifications (message, user_id) VALUES (message_text, NEW.user_id);


   UPDATE reservation
   SET state = 'valid'
   WHERE item_id = new.item_id;


   return null;
END;
$$;


ALTER FUNCTION public.trg_update_on_return_history() OWNER TO postgres;

--
-- Name: trg_update_reservation_rating_list_on_delete_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_reservation_rating_list_on_delete_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM reservation
    WHERE user_id = old.user_id;
    DELETE FROM rating
    WHERE user_id = old.user_id;
    DELETE FROM list
    WHERE user_id = old.user_id;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.trg_update_reservation_rating_list_on_delete_user() OWNER TO postgres;

--
-- Name: trg_update_user_ban(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_user_ban() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   banned_checker boolean;
BEGIN
   SELECT banned FROM user_account WHERE user_id = NEW.user_id into banned_checker;


   IF banned_checker THEN
       RAISE NOTICE 'USER ALREADY BANNED OR NOT EXIST.';
   ELSE
       UPDATE user_account
       SET banned = true
       WHERE user_id = NEW.user_id;


       DELETE FROM refresh_tokens WHERE id = NEW.user_id AND admin = false;
   END IF;


   RETURN NULL;
   END;
$$;


ALTER FUNCTION public.trg_update_user_ban() OWNER TO postgres;

--
-- Name: trg_update_user_unban(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_update_user_unban() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE user_account
        SET banned = false
    WHERE user_id = OLD.user_id;
    return null;
END;
$$;


ALTER FUNCTION public.trg_update_user_unban() OWNER TO postgres;

--
-- Name: update_admin_information(integer, character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_admin_information(IN p_admin_id integer, IN p_firstname character varying, IN p_lastname character varying, IN p_email character varying, IN p_username character varying, IN p_phone_number character varying)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	UPDATE admin
 	SET firstname = p_firstname,
     	last_name = p_lastname,
     	email = p_email,
     	username = p_username,
     	phone_number = p_phone_number
 	WHERE admin.admin_id = p_admin_id;

 	RAISE NOTICE 'Admin information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_admin_information(IN p_admin_id integer, IN p_firstname character varying, IN p_lastname character varying, IN p_email character varying, IN p_username character varying, IN p_phone_number character varying) OWNER TO postgres;

--
-- Name: update_admin_password(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_admin_password(IN p_admin_id integer, IN p_password character varying)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	UPDATE admin
 	SET password = p_password
 	WHERE admin.admin_id = p_admin_id;

 	RAISE NOTICE 'Admin information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_admin_password(IN p_admin_id integer, IN p_password character varying) OWNER TO postgres;

--
-- Name: update_author(integer, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_author(IN p_author_id integer, IN p_first_name character varying, IN p_last_name character varying, IN p_nationality character varying, OUT p_author_id_out integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE author
    SET first_name = p_first_name,
        last_name = p_last_name,
        nationality = p_nationality
    WHERE author_id = p_author_id
    RETURNING author_id INTO p_author_id_out;
END;
$$;


ALTER PROCEDURE public.update_author(IN p_author_id integer, IN p_first_name character varying, IN p_last_name character varying, IN p_nationality character varying, OUT p_author_id_out integer) OWNER TO postgres;

--
-- Name: update_due_date_on_rental(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_due_date_on_rental(IN p_item_id integer, IN p_user_id integer, OUT p_due_date date)
    LANGUAGE plpgsql
    AS $$
   DECLARE
       p_user_type_id SMALLINT;
       p_rental_time SMALLINT;
       p_extratime_counter INTEGER;
       p_max_extratime INTEGER;
      p_is_exist BOOLEAN;
       message_text TEXT;
      item_name TEXT;
       old_due_date DATE;
       new_due_date DATE;
   BEGIN
      SELECT 1 FROM rental_log WHERE item_id = p_item_id AND user_id = p_user_id INTO p_is_exist;
      IF p_is_exist THEN
         SELECT user_type_id FROM user_account WHERE user_id = p_user_id INTO p_user_type_id;
         SELECT extratime_counter FROM rental_log WHERE rental_log.item_id = p_item_id INTO p_extratime_counter;
         SELECT max_extratime, rental_time FROM user_type WHERE user_type_id = p_user_type_id INTO p_max_extratime, p_rental_time;


         IF p_extratime_counter < p_max_extratime THEN
             SELECT name INTO item_name
            FROM item
            WHERE item_id = p_item_id;
            
             SELECT due_date FROM rental_log WHERE rental_log.item_id = p_item_id INTO old_due_date;
            
            new_due_date = old_due_date + p_rental_time;
             message_text := 'You have changed the due date of ' || item_name || ' to ' || new_due_date;


             INSERT INTO notifications (message, user_id) VALUES (message_text, p_user_id);
            
            UPDATE rental_log
            SET due_date = new_due_date,
               extratime_counter = extratime_counter + 1
            WHERE rental_log.item_id = p_item_id
            RETURNING due_date INTO p_due_date;
         ELSE
             RAISE EXCEPTION 'Maximum extra time request has been reached.';
         END IF;
      ELSE
          RAISE EXCEPTION 'Record does not exist.';
      END IF;
   EXCEPTION
       WHEN others THEN
           RAISE EXCEPTION 'An error acquired: %', SQLERRM;
   END;
$$;


ALTER PROCEDURE public.update_due_date_on_rental(IN p_item_id integer, IN p_user_id integer, OUT p_due_date date) OWNER TO postgres;

--
-- Name: update_language(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_language(IN p_language_id integer, IN p_language_name character varying, OUT p_language_id_out integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE language
    SET language_name = p_language_name
    WHERE language_id = p_language_id
    RETURNING language_id INTO p_language_id_out;
END;
$$;


ALTER PROCEDURE public.update_language(IN p_language_id integer, IN p_language_name character varying, OUT p_language_id_out integer) OWNER TO postgres;

--
-- Name: update_multimedia_item_information(integer, character varying, date, character varying, character varying, integer, character varying, character varying, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_multimedia_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_size integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
 BEGIN
     	SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;

 	UPDATE item
 	SET name = p_name,
     	publication_date = p_publication_date,
     	publisher_id = p_publisher_id,
     	language_id = p_language_id,
     	branch_id = p_branch_id,
     	barcode = p_barcode,
     	serie_id = p_serie_id,
     	genre_id = p_genre_id
 	WHERE item.item_id = p_item_id;

 	UPDATE multimedia_item
 	SET size = p_size
 	WHERE multimedia_item.item_id = p_item_id;

 	RAISE NOTICE 'Item information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_multimedia_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_size integer) OWNER TO postgres;

--
-- Name: update_nonperiodical_item_information(integer, character varying, date, character varying, character varying, integer, character varying, character varying, integer, character varying, character varying, character varying, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_nonperiodical_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_author_first_name character varying, IN p_author_last_name character varying, IN p_author_nationality character varying, IN p_isbn integer, IN p_edition integer, IN p_page_number integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
    p_author_id INTEGER;
 BEGIN

    SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;

	SELECT author_id FROM author WHERE first_name = p_author_first_name and last_name = p_author_last_name and
        			nationality = p_author_nationality INTO p_author_id;
 	IF p_author_id is null THEN
     	CALL add_author(p_author_first_name, p_author_last_name, p_author_nationality, p_author_id);
 	END IF;

 	UPDATE item
 	SET name = p_name,
     	publication_date = p_publication_date,
     	publisher_id = p_publisher_id,
     	language_id = p_language_id,
     	branch_id = p_branch_id,
     	barcode = p_barcode,
     	serie_id = p_serie_id,
     	genre_id = p_genre_id
 	WHERE item.item_id = p_item_id;

 	UPDATE nonperiodical_item
 	SET item_id = p_item_id,
 	    author_id = p_author_id,
 	    isbn = p_isbn,
 	    edition = p_edition,
 	    page_number = p_page_number
 	WHERE nonperiodical_item.item_id = p_item_id;

 	RAISE NOTICE 'Item information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_nonperiodical_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_serie_name character varying, IN p_genre_id integer, IN p_author_first_name character varying, IN p_author_last_name character varying, IN p_author_nationality character varying, IN p_isbn integer, IN p_edition integer, IN p_page_number integer) OWNER TO postgres;

--
-- Name: update_periodical_item_information(integer, character varying, date, character varying, character varying, integer, character varying, character varying, integer, character varying, integer, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_periodical_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_frequency character varying, IN p_volume_number integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_living boolean)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_language_id INTEGER;
 	p_publisher_id INTEGER;
 	p_serie_id INTEGER;
 BEGIN
     	SELECT language_id FROM language WHERE language_name = p_language_name INTO p_language_id;
 	IF p_language_id is null THEN
     	CALL add_language(p_language_name, p_language_id);
 	END IF;

 	SELECT publisher_id FROM publisher WHERE publisher_name = p_publisher_name INTO p_publisher_id;
 	IF p_publisher_id is null THEN
     	CALL add_publisher(p_publisher_name, p_publisher_id);
 	END IF;

 	SELECT serie_id FROM serie WHERE serie_name = p_serie_name INTO p_serie_id;
 	IF p_serie_id is null THEN
     	CALL add_serie(p_serie_name, p_serie_id);
 	END IF;

 	UPDATE item
 	SET name = p_name,
     	publication_date = p_publication_date,
     	publisher_id = p_publisher_id,
     	language_id = p_language_id,
     	branch_id = p_branch_id,
     	barcode = p_barcode,
     	serie_id = p_serie_id,
     	genre_id = p_genre_id
 	WHERE item.item_id = p_item_id;

 	UPDATE periodical_item
 	SET frequency = p_frequency,
     	volume_number = p_volume_number,
     	living = p_living
 	WHERE periodical_item.item_id = p_item_id;

 	RAISE NOTICE 'Item information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_periodical_item_information(IN p_item_id integer, IN p_name character varying, IN p_publication_date date, IN p_publisher_name character varying, IN p_language_name character varying, IN p_branch_id integer, IN p_barcode character varying, IN p_frequency character varying, IN p_volume_number integer, IN p_serie_name character varying, IN p_genre_id integer, IN p_living boolean) OWNER TO postgres;

--
-- Name: update_rate(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_rate(IN p_rate integer, IN p_user_id integer, IN p_item_id integer)
    LANGUAGE plpgsql
    AS $$
 DECLARE
 	p_new_rate numeric(4, 2) ;
 	p_old_rate numeric(4, 2);
 	p_rated_user_number numeric(4, 2) ;
 	p_user_old_rate numeric(4, 2) ;
 BEGIN
 	SELECT rate FROM rating WHERE user_id = p_user_id AND item_id = p_item_id INTO p_user_old_rate;
 	SELECT rate, rated_user_number FROM item WHERE item.item_id = p_item_id INTO p_old_rate, p_rated_user_number;
 	p_new_rate = (((p_rated_user_number::numeric(4, 2)  * p_old_rate::numeric(4, 2))::numeric(4, 2) - p_user_old_rate::numeric(4, 2)  + p_rate::numeric(4, 2) )::numeric(4, 2) / p_rated_user_number::numeric(4, 2) )::numeric(4, 2);
 	UPDATE item
 	SET rate = p_new_rate
 	WHERE item.item_id = p_item_id;

 	UPDATE rating
 	SET rate = p_rate
 	WHERE rating.user_id = p_user_id AND rating.item_id = p_item_id;

 	RAISE NOTICE 'Rate updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_rate(IN p_rate integer, IN p_user_id integer, IN p_item_id integer) OWNER TO postgres;

--
-- Name: update_user_information(integer, character varying, character varying, character varying, character varying, character varying, smallint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_user_information(IN p_user_id integer, IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_phone_number character varying, IN p_user_type_id smallint)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	UPDATE user_account
 	SET first_name = p_first_name,
     	last_name = p_last_name,
     	email = p_email,
     	username = p_username,
         phone_number = p_phone_number,
     	user_type_id = p_user_type_id
 	WHERE user_account.user_id = p_user_id;

 	RAISE NOTICE 'User information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_user_information(IN p_user_id integer, IN p_first_name character varying, IN p_last_name character varying, IN p_email character varying, IN p_username character varying, IN p_phone_number character varying, IN p_user_type_id smallint) OWNER TO postgres;

--
-- Name: update_user_password(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_user_password(IN p_user_id integer, IN p_password character varying)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	UPDATE user_account
 	SET password = p_password
 	WHERE user_account.user_id = p_user_id;

 	RAISE NOTICE 'User password updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_user_password(IN p_user_id integer, IN p_password character varying) OWNER TO postgres;

--
-- Name: update_user_type(integer, character varying, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_user_type(IN p_user_type_id integer, IN p_type_name character varying, IN p_max_extratime integer, IN p_max_rental integer, IN p_max_reservation_day integer, IN p_rental_time integer, IN p_penalty_fee integer)
    LANGUAGE plpgsql
    AS $$
 BEGIN
 	UPDATE user_type
 	SET type_name = p_type_name,
     	max_extratime = p_max_extratime,
     	max_rental = p_max_rental,
     	max_reservation_day = p_max_reservation_day,
     	rental_time = p_rental_time,
     	penalty_fee = p_penalty_fee
 	WHERE user_type.user_type_id = p_user_type_id;

 	RAISE NOTICE 'User type information updated successfully.';
 EXCEPTION
 	WHEN others THEN
     	RAISE EXCEPTION 'An error acquired: %', SQLERRM;
 END;
 $$;


ALTER PROCEDURE public.update_user_type(IN p_user_type_id integer, IN p_type_name character varying, IN p_max_extratime integer, IN p_max_rental integer, IN p_max_reservation_day integer, IN p_rental_time integer, IN p_penalty_fee integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_item_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_item_history (
    query_id integer NOT NULL,
    user_id integer,
    item_id integer,
    "timestamp" timestamp without time zone DEFAULT now()
);


ALTER TABLE public.access_item_history OWNER TO postgres;

--
-- Name: access_item_history_query_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_item_history_query_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_item_history_query_id_seq OWNER TO postgres;

--
-- Name: access_item_history_query_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_item_history_query_id_seq OWNED BY public.access_item_history.query_id;


--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    admin_id integer NOT NULL,
    firstname character varying(255),
    last_name character varying(255),
    email character varying(255),
    username character varying(255),
    password character varying(255),
    phone_number character varying(255)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_admin_id_seq OWNER TO postgres;

--
-- Name: admin_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_admin_id_seq OWNED BY public.admin.admin_id;


--
-- Name: banned_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banned_user (
    user_id integer NOT NULL,
    admin_id integer,
    report text
);


ALTER TABLE public.banned_user OWNER TO postgres;

--
-- Name: user_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_account (
    user_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    user_type_id integer,
    email character varying(255),
    username character varying(255),
    password character varying(255),
    phone_number character varying(255),
    rental_counter integer,
    admin_id integer,
    id_number character varying(255),
    banned boolean,
    photo character varying(255),
    photo_type character varying(255)
);


ALTER TABLE public.user_account OWNER TO postgres;

--
-- Name: all_banned_users; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_banned_users AS
 SELECT ua.user_id,
    ua.first_name,
    ua.last_name,
    b.admin_id,
    b.report
   FROM (public.banned_user b
     JOIN public.user_account ua ON ((ua.user_id = b.user_id)))
  WHERE (ua.banned = true);


ALTER TABLE public.all_banned_users OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    item_id integer NOT NULL,
    name character varying(255),
    publication_date date,
    format_id integer,
    publisher_id integer,
    language_id integer,
    serie_id integer,
    branch_id integer,
    admin_id integer,
    status character varying(255),
    barcode character varying(255),
    register_date date,
    rate numeric(4,2),
    rated_user_number integer,
    genre_id integer
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: rental_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rental_log (
    item_id integer NOT NULL,
    user_id integer,
    rent_date date,
    due_date date,
    extratime_counter integer,
    admin_id integer
);


ALTER TABLE public.rental_log OWNER TO postgres;

--
-- Name: all_current_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_current_rentals AS
 SELECT ua.user_id,
    i.item_id,
    i.name,
    ua.first_name,
    ua.last_name,
    ua.id_number,
    r.admin_id,
    r.extratime_counter,
    r.due_date,
    r.rent_date,
    i.publication_date
   FROM ((public.rental_log r
     JOIN public.user_account ua ON ((ua.user_id = r.user_id)))
     JOIN public.item i ON ((i.item_id = r.item_id)))
  ORDER BY r.due_date;


ALTER TABLE public.all_current_rentals OWNER TO postgres;

--
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    user_id integer,
    item_id integer NOT NULL,
    state character varying(255),
    reservation_end_date date
);


ALTER TABLE public.reservation OWNER TO postgres;

--
-- Name: all_current_reservations; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_current_reservations AS
 SELECT ua.user_id,
    ua.first_name,
    ua.last_name,
    ua.id_number,
    i.item_id,
    i.name,
    i.publication_date
   FROM ((public.reservation r
     JOIN public.user_account ua ON ((ua.user_id = r.user_id)))
     JOIN public.item i ON ((i.item_id = r.item_id)));


ALTER TABLE public.all_current_reservations OWNER TO postgres;

--
-- Name: all_item_counter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_item_counter AS
 SELECT count(item.item_id) AS count
   FROM public.item;


ALTER TABLE public.all_item_counter OWNER TO postgres;

--
-- Name: author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.author (
    author_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    nationality character varying(255)
);


ALTER TABLE public.author OWNER TO postgres;

--
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    branch_id integer NOT NULL,
    branch_code character varying(255),
    shelf_id integer
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- Name: shelf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shelf (
    shelf_id integer NOT NULL,
    shelf_code character varying(255)
);


ALTER TABLE public.shelf OWNER TO postgres;

--
-- Name: branch_shelf; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.branch_shelf AS
 SELECT branch.branch_id,
    branch.branch_code,
    s.shelf_code
   FROM (public.branch
     LEFT JOIN public.shelf s ON ((branch.shelf_id = s.shelf_id)));


ALTER TABLE public.branch_shelf OWNER TO postgres;

--
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    genre_id integer NOT NULL,
    genre_name character varying(255)
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- Name: item_format; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_format (
    format_id integer NOT NULL,
    format_name character varying(255)
);


ALTER TABLE public.item_format OWNER TO postgres;

--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language (
    language_id integer NOT NULL,
    language_name character varying(255)
);


ALTER TABLE public.language OWNER TO postgres;

--
-- Name: nonperiodical_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nonperiodical_item (
    item_id integer NOT NULL,
    author_id integer,
    isbn character varying(255),
    edition character varying(255),
    page_number integer
);


ALTER TABLE public.nonperiodical_item OWNER TO postgres;

--
-- Name: nonperiodical_item_author; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.nonperiodical_item_author AS
 SELECT np.item_id,
    np.author_id,
    np.isbn,
    np.edition,
    np.page_number,
    a.first_name,
    a.last_name,
    a.nationality,
    i.name,
    i.publication_date
   FROM ((public.nonperiodical_item np
     LEFT JOIN public.author a ON ((np.author_id = a.author_id)))
     LEFT JOIN public.item i ON ((np.item_id = i.item_id)));


ALTER TABLE public.nonperiodical_item_author OWNER TO postgres;

--
-- Name: publisher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publisher (
    publisher_id integer NOT NULL,
    publisher_name character varying(255)
);


ALTER TABLE public.publisher OWNER TO postgres;

--
-- Name: serie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serie (
    serie_id integer NOT NULL,
    serie_name character varying(255)
);


ALTER TABLE public.serie OWNER TO postgres;

--
-- Name: all_items; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_items AS
 SELECT item.item_id,
    item.name,
    item.publication_date,
    item.status,
    item.barcode,
    item.register_date,
    item.rate,
    item.rated_user_number,
    g.genre_name,
    bs.branch_code,
    bs.shelf_code,
    if.format_name,
    p.publisher_name,
    l.language_name,
    s.serie_name,
    item.admin_id
   FROM (((((((public.item
     LEFT JOIN public.publisher p ON ((item.publisher_id = p.publisher_id)))
     LEFT JOIN public.language l ON ((item.language_id = l.language_id)))
     LEFT JOIN public.serie s ON ((item.serie_id = s.serie_id)))
     LEFT JOIN public.genre g ON ((item.genre_id = g.genre_id)))
     LEFT JOIN public.branch_shelf bs ON ((item.branch_id = bs.branch_id)))
     LEFT JOIN public.item_format if ON ((item.format_id = if.format_id)))
     LEFT JOIN public.nonperiodical_item_author npia ON ((item.item_id = npia.item_id)))
  ORDER BY item.item_id;


ALTER TABLE public.all_items OWNER TO postgres;

--
-- Name: lost_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lost_item (
    item_id integer NOT NULL,
    admin_id integer,
    report_date date
);


ALTER TABLE public.lost_item OWNER TO postgres;

--
-- Name: all_lost_items; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_lost_items AS
 SELECT i.item_id,
    i.name,
    i.publication_date,
    p.publisher_name,
    l.admin_id,
    l.report_date
   FROM ((public.lost_item l
     JOIN public.item i ON ((l.item_id = i.item_id)))
     JOIN public.publisher p ON ((p.publisher_id = i.publisher_id)))
  ORDER BY l.report_date;


ALTER TABLE public.all_lost_items OWNER TO postgres;

--
-- Name: maintenance_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_history (
    maintenance_id integer NOT NULL,
    item_id integer,
    admin_id integer,
    maintenance_date date,
    maintenance_end_date date,
    description text
);


ALTER TABLE public.maintenance_history OWNER TO postgres;

--
-- Name: all_maintenance_history_items; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_maintenance_history_items AS
 SELECT i.item_id,
    i.name,
    i.publication_date,
    p.publisher_name,
    m.admin_id,
    m.maintenance_date,
    m.maintenance_end_date,
    m.description
   FROM ((public.maintenance_history m
     JOIN public.item i ON ((m.item_id = i.item_id)))
     JOIN public.publisher p ON ((p.publisher_id = i.publisher_id)))
  ORDER BY m.maintenance_end_date;


ALTER TABLE public.all_maintenance_history_items OWNER TO postgres;

--
-- Name: maintenance_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_log (
    item_id integer NOT NULL,
    admin_id integer,
    maintenance_date date,
    description text
);


ALTER TABLE public.maintenance_log OWNER TO postgres;

--
-- Name: all_maintenance_log_items; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_maintenance_log_items AS
 SELECT i.item_id,
    i.name,
    i.publication_date,
    p.publisher_name,
    m.admin_id,
    m.maintenance_date,
    m.description
   FROM ((public.maintenance_log m
     JOIN public.item i ON ((m.item_id = i.item_id)))
     JOIN public.publisher p ON ((p.publisher_id = i.publisher_id)))
  ORDER BY m.maintenance_date;


ALTER TABLE public.all_maintenance_log_items OWNER TO postgres;

--
-- Name: multimedia_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.multimedia_item (
    item_id integer NOT NULL,
    size integer,
    type character varying(255),
    path character varying(255)
);


ALTER TABLE public.multimedia_item OWNER TO postgres;

--
-- Name: all_multimedia; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_multimedia AS
 SELECT m.item_id,
    i.name,
    m.size,
    m.type,
    m.path
   FROM (public.multimedia_item m
     JOIN public.item i ON ((i.item_id = m.item_id)))
  ORDER BY m.item_id;


ALTER TABLE public.all_multimedia OWNER TO postgres;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rating (
    user_id integer,
    item_id integer,
    rate integer
);


ALTER TABLE public.rating OWNER TO postgres;

--
-- Name: all_rating_with_names; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_rating_with_names AS
 SELECT r.user_id,
    r.item_id,
    r.rate,
    ua.first_name,
    ua.last_name,
    i.name
   FROM ((public.rating r
     JOIN public.user_account ua ON ((ua.user_id = r.user_id)))
     JOIN public.item i ON ((r.item_id = i.item_id)));


ALTER TABLE public.all_rating_with_names OWNER TO postgres;

--
-- Name: author_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.author_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.author_author_id_seq OWNER TO postgres;

--
-- Name: author_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.author_author_id_seq OWNED BY public.author.author_id;


--
-- Name: avaliable_items; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avaliable_items AS
 SELECT item.item_id,
    item.name
   FROM public.item
  WHERE ((item.status)::text = 'available'::text);


ALTER TABLE public.avaliable_items OWNER TO postgres;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branch_branch_id_seq OWNER TO postgres;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_branch_id_seq OWNED BY public.branch.branch_id;


--
-- Name: genre_genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genre_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genre_genre_id_seq OWNER TO postgres;

--
-- Name: genre_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genre_genre_id_seq OWNED BY public.genre.genre_id;


--
-- Name: heading; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.heading (
    heading_id integer NOT NULL,
    heading character varying(255)
);


ALTER TABLE public.heading OWNER TO postgres;

--
-- Name: heading_heading_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heading_heading_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.heading_heading_id_seq OWNER TO postgres;

--
-- Name: heading_heading_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.heading_heading_id_seq OWNED BY public.heading.heading_id;


--
-- Name: item_format_format_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_format_format_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_format_format_id_seq OWNER TO postgres;

--
-- Name: item_format_format_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_format_format_id_seq OWNED BY public.item_format.format_id;


--
-- Name: item_heading; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_heading (
    heading_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.item_heading OWNER TO postgres;

--
-- Name: item_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_item_id_seq OWNER TO postgres;

--
-- Name: item_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_item_id_seq OWNED BY public.item.item_id;


--
-- Name: item_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_list (
    list_id integer,
    item_id integer
);


ALTER TABLE public.item_list OWNER TO postgres;

--
-- Name: item_search; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.item_search AS
 SELECT item.item_id,
    item.name,
    item.publication_date,
    item.status,
    item.barcode,
    item.register_date,
    item.rate,
    item.rated_user_number,
    g.genre_name,
    bs.branch_code,
    bs.shelf_code,
    if.format_name,
    p.publisher_name,
    l.language_name,
    s.serie_name,
    item.admin_id,
    h.heading
   FROM (((((((((public.item
     LEFT JOIN public.publisher p ON ((item.publisher_id = p.publisher_id)))
     LEFT JOIN public.language l ON ((item.language_id = l.language_id)))
     LEFT JOIN public.serie s ON ((item.serie_id = s.serie_id)))
     LEFT JOIN public.genre g ON ((item.genre_id = g.genre_id)))
     LEFT JOIN public.branch_shelf bs ON ((item.branch_id = bs.branch_id)))
     LEFT JOIN public.item_format if ON ((item.format_id = if.format_id)))
     LEFT JOIN public.nonperiodical_item_author npia ON ((item.item_id = npia.item_id)))
     LEFT JOIN public.item_heading ih ON ((item.item_id = ih.item_id)))
     JOIN public.heading h ON ((ih.heading_id = h.heading_id)));


ALTER TABLE public.item_search OWNER TO postgres;

--
-- Name: language_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_language_id_seq OWNER TO postgres;

--
-- Name: language_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_language_id_seq OWNED BY public.language.language_id;


--
-- Name: list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.list (
    list_id integer NOT NULL,
    user_id integer,
    list_name character varying(255)
);


ALTER TABLE public.list OWNER TO postgres;

--
-- Name: list_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.list_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.list_list_id_seq OWNER TO postgres;

--
-- Name: list_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.list_list_id_seq OWNED BY public.list.list_id;


--
-- Name: maintenance_history_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.maintenance_history_maintenance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.maintenance_history_maintenance_id_seq OWNER TO postgres;

--
-- Name: maintenance_history_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.maintenance_history_maintenance_id_seq OWNED BY public.maintenance_history.maintenance_id;


--
-- Name: multimedia_item_counter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.multimedia_item_counter AS
 SELECT count(item.item_id) AS count
   FROM (public.item
     LEFT JOIN public.item_format i ON ((item.format_id = i.format_id)))
  WHERE ((i.format_name)::text = 'multimedia_item'::text);


ALTER TABLE public.multimedia_item_counter OWNER TO postgres;

--
-- Name: nonperiodical_counter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.nonperiodical_counter AS
 SELECT count(item.item_id) AS count
   FROM (public.item
     LEFT JOIN public.item_format i ON ((item.format_id = i.format_id)))
  WHERE ((i.format_name)::text = 'nonperiodical_item'::text);


ALTER TABLE public.nonperiodical_counter OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    message text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    is_read boolean DEFAULT false
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: otpcode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otpcode (
    user_id integer NOT NULL,
    otp character varying(255),
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expiresat timestamp without time zone
);


ALTER TABLE public.otpcode OWNER TO postgres;

--
-- Name: periodical_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periodical_item (
    item_id integer NOT NULL,
    frequency character varying(255),
    volume_number integer,
    living boolean
);


ALTER TABLE public.periodical_item OWNER TO postgres;

--
-- Name: periodical_item_counter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.periodical_item_counter AS
 SELECT count(item.item_id) AS count
   FROM (public.item
     LEFT JOIN public.item_format i ON ((item.format_id = i.format_id)))
  WHERE ((i.format_name)::text = 'periodical_item'::text);


ALTER TABLE public.periodical_item_counter OWNER TO postgres;

--
-- Name: processing_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.processing_history (
    query_id integer NOT NULL,
    id integer,
    admin boolean,
    executed_query text,
    query_params jsonb,
    "timestamp" timestamp without time zone DEFAULT now(),
    query_duration integer
);


ALTER TABLE public.processing_history OWNER TO postgres;

--
-- Name: processing_history_query_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.processing_history_query_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.processing_history_query_id_seq OWNER TO postgres;

--
-- Name: processing_history_query_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.processing_history_query_id_seq OWNED BY public.processing_history.query_id;


--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publisher_publisher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.publisher_publisher_id_seq OWNER TO postgres;

--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publisher_publisher_id_seq OWNED BY public.publisher.publisher_id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    admin boolean
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refresh_tokens_id_seq OWNER TO postgres;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- Name: return_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_history (
    return_id integer NOT NULL,
    user_id integer,
    item_id integer,
    due_date date,
    return_date date,
    is_late boolean,
    received_fee numeric(5,2),
    description text,
    admin_id integer,
    rent_date date
);


ALTER TABLE public.return_history OWNER TO postgres;

--
-- Name: return_history_return_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_history_return_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_history_return_id_seq OWNER TO postgres;

--
-- Name: return_history_return_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_history_return_id_seq OWNED BY public.return_history.return_id;


--
-- Name: serie_serie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serie_serie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.serie_serie_id_seq OWNER TO postgres;

--
-- Name: serie_serie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serie_serie_id_seq OWNED BY public.serie.serie_id;


--
-- Name: shelf_shelf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shelf_shelf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shelf_shelf_id_seq OWNER TO postgres;

--
-- Name: shelf_shelf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shelf_shelf_id_seq OWNED BY public.shelf.shelf_id;


--
-- Name: statistics; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.statistics AS
 SELECT ( SELECT count(*) AS count
           FROM public.item) AS item_count,
    ( SELECT count(*) AS count
           FROM public.maintenance_log) AS maintenance_log_count,
    ( SELECT count(*) AS count
           FROM public.lost_item) AS lost_item_count,
    ( SELECT count(*) AS count
           FROM public.avaliable_items) AS avaliable_items_count,
    ( SELECT count(*) AS count
           FROM public.multimedia_item) AS multimedia_item_count,
    ( SELECT count(*) AS count
           FROM public.periodical_item) AS periodical_item_count,
    ( SELECT count(*) AS count
           FROM public.nonperiodical_item) AS nonperiodical_item_count,
    ( SELECT count(*) AS count
           FROM public.rental_log) AS rental_log_count,
    ( SELECT count(*) AS count
           FROM public.reservation) AS reservation_count,
    ( SELECT count(*) AS count
           FROM public.banned_user) AS banned_user_count,
    ( SELECT count(*) AS count
           FROM public.user_account) AS user_account_count;


ALTER TABLE public.statistics OWNER TO postgres;

--
-- Name: user_account_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_account_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_account_user_id_seq OWNER TO postgres;

--
-- Name: user_account_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_account_user_id_seq OWNED BY public.user_account.user_id;


--
-- Name: user_all_information; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_all_information AS
 SELECT user_account.user_id,
    user_account.first_name,
    user_account.last_name,
    user_account.user_type_id,
    user_account.email,
    user_account.username,
    user_account.password,
    user_account.phone_number,
    user_account.rental_counter,
    user_account.admin_id,
    user_account.id_number,
    user_account.banned,
    bu.report
   FROM (public.user_account
     LEFT JOIN public.banned_user bu ON ((user_account.user_id = bu.user_id)));


ALTER TABLE public.user_all_information OWNER TO postgres;

--
-- Name: user_to_see_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_to_see_list AS
 SELECT l.user_id,
    user_account.first_name,
    user_account.last_name,
    l.list_id,
    l.list_name,
    i.item_id,
    i.name,
    i.rate,
    i.publication_date
   FROM (((public.user_account
     JOIN public.list l ON ((user_account.user_id = l.user_id)))
     JOIN public.item_list il ON ((l.list_id = il.list_id)))
     JOIN public.item i ON ((il.item_id = i.item_id)))
  ORDER BY l.user_id, l.list_id;


ALTER TABLE public.user_to_see_list OWNER TO postgres;

--
-- Name: user_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_type (
    user_type_id integer NOT NULL,
    type_name character varying(255),
    max_extratime integer,
    max_rental integer,
    max_reservation_day integer,
    penalty_fee integer,
    rental_time integer
);


ALTER TABLE public.user_type OWNER TO postgres;

--
-- Name: user_type_user_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_type_user_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_type_user_type_id_seq OWNER TO postgres;

--
-- Name: user_type_user_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_type_user_type_id_seq OWNED BY public.user_type.user_type_id;


--
-- Name: access_item_history query_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_item_history ALTER COLUMN query_id SET DEFAULT nextval('public.access_item_history_query_id_seq'::regclass);


--
-- Name: admin admin_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN admin_id SET DEFAULT nextval('public.admin_admin_id_seq'::regclass);


--
-- Name: author author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author ALTER COLUMN author_id SET DEFAULT nextval('public.author_author_id_seq'::regclass);


--
-- Name: branch branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN branch_id SET DEFAULT nextval('public.branch_branch_id_seq'::regclass);


--
-- Name: genre genre_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre ALTER COLUMN genre_id SET DEFAULT nextval('public.genre_genre_id_seq'::regclass);


--
-- Name: heading heading_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heading ALTER COLUMN heading_id SET DEFAULT nextval('public.heading_heading_id_seq'::regclass);


--
-- Name: item item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item ALTER COLUMN item_id SET DEFAULT nextval('public.item_item_id_seq'::regclass);


--
-- Name: item_format format_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_format ALTER COLUMN format_id SET DEFAULT nextval('public.item_format_format_id_seq'::regclass);


--
-- Name: language language_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language ALTER COLUMN language_id SET DEFAULT nextval('public.language_language_id_seq'::regclass);


--
-- Name: list list_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list ALTER COLUMN list_id SET DEFAULT nextval('public.list_list_id_seq'::regclass);


--
-- Name: maintenance_history maintenance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_history ALTER COLUMN maintenance_id SET DEFAULT nextval('public.maintenance_history_maintenance_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: processing_history query_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processing_history ALTER COLUMN query_id SET DEFAULT nextval('public.processing_history_query_id_seq'::regclass);


--
-- Name: publisher publisher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher ALTER COLUMN publisher_id SET DEFAULT nextval('public.publisher_publisher_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- Name: return_history return_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_history ALTER COLUMN return_id SET DEFAULT nextval('public.return_history_return_id_seq'::regclass);


--
-- Name: serie serie_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie ALTER COLUMN serie_id SET DEFAULT nextval('public.serie_serie_id_seq'::regclass);


--
-- Name: shelf shelf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelf ALTER COLUMN shelf_id SET DEFAULT nextval('public.shelf_shelf_id_seq'::regclass);


--
-- Name: user_account user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account ALTER COLUMN user_id SET DEFAULT nextval('public.user_account_user_id_seq'::regclass);


--
-- Name: user_type user_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_type ALTER COLUMN user_type_id SET DEFAULT nextval('public.user_type_user_type_id_seq'::regclass);


--
-- Data for Name: access_item_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_item_history (query_id, user_id, item_id, "timestamp") FROM stdin;
196	18	8	2023-06-12 19:47:23.756516
197	18	8	2023-06-12 19:47:27.909871
198	18	8	2023-06-12 19:51:56.505774
199	18	4	2023-06-12 20:24:21.642713
200	18	1	2023-06-12 20:39:00.452924
201	18	8	2023-06-12 20:40:50.79234
202	18	10	2023-06-12 21:29:10.969864
203	18	5	2023-06-12 22:27:38.137535
204	18	5	2023-06-12 22:29:21.04004
205	18	4	2023-06-12 22:35:35.02799
206	21	8	2023-06-13 00:57:17.431706
207	21	51	2023-06-13 00:57:42.612826
208	21	1	2023-06-13 01:03:04.621936
\.


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (admin_id, firstname, last_name, email, username, password, phone_number) FROM stdin;
1	IBRAHIM	KILAS	iklas@weebly.com	ibolino03	1346798520	(555, 0) 333333
2	Barbie	Fine	bfine0@weebly.com	bfine0	H2sJnaM	(559, 0) 1727066
3	Kipp	Cecchetelli	kcecchetelli1@amazon.com	kcecchetelli1	azMF8p6RbfOO	(508, 0) 4499368
4	Clemmy	Accombe	caccombe2@jimdo.com	caccombe2	wQ1D6W5phZWZ	(971, 0) 4978248
5	Tedra	Hovey	thovey3@ow.ly	thovey3	sccLUfGd	(138, 0) 3650435
6	Gertrud	O'Bradden	gobradden4@census.gov	gobradden4	08K5YZu4kV	(797, 0) 9060623
7	Billi	Straughan	bstraughan5@tumblr.com	bstraughan5	Isg3M4cR2YP	(754, 0) 4296650
8	Kingston	Newcome	knewcome6@tinyurl.com	knewcome6	JMrWDLT	(283, 0) 9350414
9	Shell	Muzzullo	smuzzullo7@wikia.com	smuzzullo7	GfVsFY9ZBN	(243, 0) 8176441
10	Erastus	Climer	eclimer8@discovery.com	eclimer8	D3nXsGt	(100, 0) 4739586
12	John	Doe	john.doe2@example.com	johndoe	$2b$10$EcI8VmJ.9W38ag8vd6hYl.iz6vI/ggkeyz7gQW8ySylETl/aL8XWS	555-1234
13	Fevzi	KILAS	fevzi@google.com	nietzsche	$2b$10$LbruwWbBRHk5VonGeI94quaD.jyAzt48NzoLY75eqhEnxHXLpxy6a	05433473514
\.


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.author (author_id, first_name, last_name, nationality) FROM stdin;
3	F. Scott	Fitzgerald	American
4	George	Orwell	British
5	J.D.	Salinger	American
6	Jane	Austen	British
7	Harper	Lee	American
8	Gabriel	Garcia Marquez	Colombian
9	Victor	Hugo	French
10	J.R.R.	Tolkien	British
11	Fyodor	Dostoevsky	Russian
\.


--
-- Data for Name: banned_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banned_user (user_id, admin_id, report) FROM stdin;
13	1	Rule violation.
14	4	Damaged library books.
15	2	He did not deliver his books on time.
16	1	Damaged library books.
1	1	Damaged library books.
2	1	Damaged library books.
\.


--
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch (branch_id, branch_code, shelf_id) FROM stdin;
2	001	1
3	002	1
4	003	1
5	001	2
6	002	2
7	003	2
8	001	3
9	002	3
10	003	3
11	001	4
12	002	4
13	004	4
14	001	5
15	002	5
16	003	5
17	001	6
18	002	6
19	003	6
20	001	7
21	002	7
22	004	7
23	001	8
24	002	8
25	003	8
26	001	9
27	002	9
28	003	9
29	001	10
30	002	10
31	004	10
32	008	1
\.


--
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (genre_id, genre_name) FROM stdin;
1	Action|Adventure|Comedy
2	Documentary
3	Comedy|Drama|Fantasy
4	Drama|Thriller
5	Comedy|Musical
6	Comedy|Crime|Mystery
7	Comedy
8	Comedy|Drama
9	Western
10	Horror|Thriller
11	Adventure
12	Drama
13	Horror
14	Action|Adventure|Crime|Drama|Thriller
15	Comedy|Drama
16	Action|Adventure|Fantasy
17	Horror
18	Comedy|Drama|Romance
19	Drama
20	Documentary
21	Western
22	Crime|Drama|Thriller
23	Drama
24	Animation|Children|Comedy|Drama
25	Drama|Fantasy|Romance
26	Adventure|Fantasy|Romance|Sci-Fi|Thriller
27	Adventure|Comedy
28	Comedy
29	new genre
30	new genre 2
31	new genre 3
32	New Genre 4
\.


--
-- Data for Name: heading; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.heading (heading_id, heading) FROM stdin;
1	medicine
2	European History
3	Mystery
4	Detective
5	Suspense
6	Science Fiction
7	Biography
8	Romance
9	Thriller
10	Fantasy
11	Epic Fantasy
12	Self-Help
13	Cooking
15	International Cooking
16	Travel
17	Art
18	History
19	Ancient History
20	Business
21	Finance
22	Children
23	Picture Books
24	Religion
25	Music
26	Politics
27	Sports
28	Science
29	Technology
30	Internet
31	Health
32	Philosophy
33	Reference
34	True Crime
35	Horror
36	Poetry
37	Drama
38	Comics
39	Graphic Novels
40	Memoir
41	Humor
42	Essays
43	Short Stories
44	Fiction
45	Nonfiction
46	Autobiography
47	Anthology
48	Educational
49	Classic Literature
50	Crime Fiction
51	Historical Fiction
52	Political Thriller
53	Psychological Thriller
54	Contemporary Fiction
55	Young Adult Fiction
56	Children's Fiction
57	Children's Nonfiction
58	Biographical Fiction
59	Urban Fiction
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item (item_id, name, publication_date, format_id, publisher_id, language_id, serie_id, branch_id, admin_id, status, barcode, register_date, rate, rated_user_number, genre_id) FROM stdin;
8	The Catcher in the Rye	1951-07-16	1	8	1	1	6	7	available	9780316769174	2023-05-02	0.00	0	7
9	The Hobbit	1937-09-21	1	4	1	2	25	3	available	9780547928227	2023-05-02	0.00	0	4
10	Crime and Punishment	1866-12-22	1	9	2	1	7	1	available	9781840224306	2023-05-02	0.00	0	8
12	To the Lighthouse	1927-05-05	1	11	1	1	8	1	available	9780156907392	2023-05-02	0.00	0	11
13	One Hundred Years of Solitude	1967-05-30	1	12	3	1	2	8	available	9780060883287	2023-05-02	0.00	0	12
14	Moby-Dick	1851-10-18	1	13	1	1	10	4	available	9780393972832	2023-05-02	0.00	0	13
15	The Color Purple	1982-06-29	1	14	1	1	5	5	available	9780156031820	2023-05-02	0.00	0	14
16	The Sun Also Rises	1926-10-22	1	2	1	1	7	9	available	9780684800714	2023-05-02	0.00	0	15
17	The Sound and the Fury	1929-10-07	1	15	1	1	6	3	available	9780679732242	2023-05-02	0.00	0	16
18	The Picture of Dorian Gray	1890-06-20	1	16	1	1	3	2	available	9781503290259	2023-05-02	0.00	0	17
19	The Old Man and the Sea	1952-09-01	1	17	1	1	12	6	available	9780684801223	2023-05-02	0.00	0	18
27	The Adventures of Sherlock Holmes	1892-10-14	1	21	1	6	5	1	available	9780143039198	2023-05-02	0.00	0	13
28	Heart of Darkness	1899-02-01	1	18	1	1	3	6	available	9780486264646	2023-05-02	0.00	0	26
29	The War of the Worlds	1898-01-01	1	22	1	1	4	1	available	9781503275866	2023-05-02	0.00	0	27
30	To the Lighthouse	1927-05-05	1	11	1	1	2	9	available	9780156907392	2023-05-02	0.00	0	28
31	Brave New World	1932-01-01	1	20	1	1	10	1	available	9780060850524	2023-05-02	0.00	0	19
32	One Hundred Years of Solitude	1967-05-30	1	23	3	1	6	3	available	9780060883287	2023-05-02	0.00	0	20
36	1984	1949-06-08	2	24	1	1	2	2	available	2345678901	2023-05-02	0.00	0	21
37	The Catcher in the Rye	1951-07-16	2	8	1	1	3	3	available	3456789012	2023-05-02	0.00	0	15
38	Pride and Prejudice	1813-01-28	2	5	1	1	4	4	available	4567890123	2023-05-02	0.00	0	14
39	To Kill a Mockingbird	1960-07-11	2	25	1	1	5	5	available	5678901234	2023-05-02	0.00	0	25
62	Veja	2022-09-15	3	42	6	25	4	1	available	89012345678902	2023-05-02	0.00	0	9
63	Al-Ahram	2022-10-01	3	43	7	26	2	1	available	90123456789013	2023-05-02	0.00	0	12
64	Yomiuri Shimbun	2022-11-15	3	44	8	27	8	2	available	01234567890124	2023-05-02	0.00	0	15
65	South China Morning Post	2022-12-01	3	45	1	28	14	1	available	12345678901236	2023-05-02	0.00	0	11
44	Kırmızı Pazartesi	2002-04-01	3	47	10	34	2	10	rented	9789750706318	2023-05-02	0.00	0	1
59	El País	2022-06-01	3	39	3	22	2	1	lost	56789012345679	2023-05-02	0.00	0	7
60	Le Monde	2022-07-15	3	40	4	23	5	5	lost	67890123456780	2023-05-02	0.00	0	10
61	Die Zeit	2022-08-01	3	41	5	24	10	3	lost	78901234567891	2023-05-02	0.00	0	13
48	Time	2022-04-18	3	30	1	11	14	1	rented	56789012345678	2023-05-02	0.00	0	11
50	Vogue	2022-06-15	3	29	1	13	6	2	rented	78901234567890	2023-05-02	0.00	0	7
49	Popular Mechanics	2022-05-02	3	31	1	12	4	1	available	67890123456789	2023-05-02	0.00	0	9
21	Beloved	1987-09-02	1	19	1	1	5	8	reserved	9781400033416	2023-05-02	0.00	0	20
52	Nature	2022-08-15	3	28	1	15	8	5	maintenance	90123456789012	2023-05-02	0.00	0	5
53	Harvard Business Review	2022-09-01	3	33	1	16	11	6	maintenance	01234567890123	2023-05-02	0.00	0	14
54	Rolling Stone	2022-10-17	3	34	1	17	10	1	maintenance	12345678901235	2023-05-02	0.00	0	15
55	The Guardian	2022-03-14	3	35	1	18	7	1	maintenance	23456789012346	2023-05-02	0.00	0	6
56	The Times	2022-04-01	3	36	1	19	12	2	maintenance	34567890123457	2023-05-02	0.00	0	11
47	Wired	2022-03-01	3	29	1	10	2	3	rented	45678901234567	2023-05-02	0.00	0	8
42	The Lord of the Rings	1954-07-29	2	4	1	1	8	8	available	8901234567	2023-05-02	0.00	0	2
43	Crime and Punishment	1866-01-01	2	9	2	1	9	9	available	9012345678	2023-05-02	0.00	0	7
20	Heart of Darkness	1899-02-01	1	18	1	1	4	1	reserved	9781503290273	2023-05-02	0.00	0	19
35	The Catcher in the Rye	1951-07-16	2	48	1	33	2	2	available	9780316769174	2023-05-02	0.00	0	2
45	Scientific American	2022-02-01	3	28	1	8	2	1	rented	23456789012345	2023-05-02	0.00	0	12
46	The New Yorker	2022-02-14	3	29	1	9	9	1	rented	34567890123456	2023-05-02	0.00	0	6
23	The Brothers Karamazov	1880-11-01	1	9	2	1	7	1	reserved	9780140449242	2023-05-02	0.00	0	12
40	One Hundred Years of Solitude	1967-05-30	2	12	3	1	6	6	available	6789012345	2023-05-02	5.00	1	14
24	The Adventures of Huckleberry Finn	1884-12-10	1	20	1	1	5	1	available	9780486280615	2023-05-02	0.00	0	12
26	Anna Karenina	1877-01-01	1	9	2	1	8	1	rented	9780393275869	2023-05-02	0.00	0	24
41	Les Misérables	1862-03-16	2	26	4	1	7	7	rented	7890123456	2023-05-02	10.00	-3	17
7	Harry Potter and the Philosopher's Stone	1997-06-26	1	7	1	4	2	8	rented	9780747532743	2023-05-02	0.00	0	6
2	The Great Gatsby	1925-04-10	1	2	1	1	2	1	available	9780743273565	2023-05-02	0.00	0	2
11	The Da Vinci Code	2003-03-18	1	10	1	5	20	2	lost	9780385504201	2023-05-02	0.00	0	9
57	The Wall Street Journal	2022-05-15	3	37	1	20	3	9	lost	45678901234568	2023-05-02	0.00	0	14
67	Kırmızı Pazartesi	2002-04-01	1	47	10	30	2	1	available	9789750706318	2023-05-05	0.00	0	1
68	Kırmızı Pazartesi	2002-04-01	1	47	10	30	2	1	available	9789750706318	2023-05-05	0.00	0	1
69	Kırmızı Pazartesi	2002-04-01	3	47	10	31	2	1	available	9789750706318	2023-05-05	0.00	0	1
70	Kırmızı Pazartesi	2002-04-01	3	47	10	32	2	1	available	9789750706318	2023-05-05	0.00	0	1
71	The Catcher in the Rye	1951-07-16	2	48	1	33	2	2	available	9780316769174	2023-05-05	0.00	0	2
22	The Adventures of Huckleberry Finn	1884-12-10	1	20	1	1	9	1	available	9780143107323	2023-05-02	0.00	0	11
25	The Picture of Dorian Gray	1890-07-01	1	16	1	1	2	7	available	9781976153676	2023-05-02	0.00	0	13
3	1984	1949-06-08	1	3	1	1	15	2	reserved	9780451524935	2023-05-02	0.00	0	3
1	Kırmızı Pazartesi	2002-04-01	1	47	10	30	2	10	lost	9789750706318	2023-05-02	0.00	0	1
5	Pride and Prejudice	1813-01-28	1	5	1	1	3	1	rented	9781983611178	2023-05-02	0.00	0	5
51	The Economist	2022-07-01	3	32	1	14	13	2	maintenance	89012345678901	2023-05-02	0.00	0	13
4	The Lord of the Rings	1954-07-29	1	4	1	2	10	5	available	9780547928210	2023-05-02	9.00	1	4
\.


--
-- Data for Name: item_format; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_format (format_id, format_name) FROM stdin;
1	multimedia_item
2	nonperiodical_item
3	periodical_item
\.


--
-- Data for Name: item_heading; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_heading (heading_id, item_id) FROM stdin;
1	16
2	16
3	26
4	1
5	29
6	23
7	1
8	9
9	15
10	21
11	25
12	21
13	14
15	24
16	12
17	25
18	4
19	18
20	5
21	16
22	14
23	22
24	8
25	10
26	29
27	26
28	9
29	23
30	30
31	23
32	15
33	25
34	9
35	21
36	24
37	27
38	7
39	19
40	29
18	25
41	7
42	28
43	25
44	12
45	27
46	20
47	26
48	18
49	11
50	20
51	19
52	22
53	11
54	19
55	14
56	16
57	19
58	24
59	25
\.


--
-- Data for Name: item_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_list (list_id, item_id) FROM stdin;
4	3
13	25
13	14
11	14
10	14
6	54
14	40
1	43
12	41
15	14
3	13
14	31
7	50
16	43
15	42
2	12
22	4
28	21
\.


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language (language_id, language_name) FROM stdin;
1	English
2	Russian
3	Spanish
4	French
5	German
6	Portuguese
7	Arabic
8	Japanese
10	Türkçe
\.


--
-- Data for Name: list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.list (list_id, user_id, list_name) FROM stdin;
1	7	My Favorite Books
2	12	My Reading List
3	15	Exam Books
4	8	Library Books
5	5	Recently Read Books
6	11	Holiday Books
7	10	Books for School Projects
8	9	Books for Research
9	13	New Releases
10	7	Movie Adaptations
11	9	Popular Books
12	8	Classics
13	6	History Books
14	14	Personal development books
15	10	Science Fiction Books
16	7	Music Books
21	7	New List
19	7	test name
20	7	new name
23	18	Daha Sonra Okunacaklar
22	18	My books
27	21	Babamın Kitapları
28	21	Benim Kitaplarım
\.


--
-- Data for Name: lost_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lost_item (item_id, admin_id, report_date) FROM stdin;
57	5	2023-05-02
59	3	2023-05-02
60	8	2023-05-02
61	3	2023-05-02
11	1	2023-05-06
1	13	2023-06-11
\.


--
-- Data for Name: maintenance_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_history (maintenance_id, item_id, admin_id, maintenance_date, maintenance_end_date, description) FROM stdin;
1	46	1	2023-05-02	2023-05-02	Multiple pages are missing.
2	47	1	2023-05-02	2023-05-02	Ink stains on cover page.
3	48	2	2023-05-02	2023-05-02	Pages are crumpled.
4	49	3	2023-05-02	2023-05-02	Torn cover page.
5	50	9	2023-05-02	2023-05-02	Multiple pages are creased.
6	11	1	2023-05-06	2023-05-06	description
\.


--
-- Data for Name: maintenance_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_log (item_id, admin_id, maintenance_date, description) FROM stdin;
51	4	2023-05-02	Loose binding.
52	4	2023-05-02	Water damage on cover page.
53	7	2023-05-02	Missing pages.
54	3	2023-05-02	Pages are smudged.
55	8	2023-05-02	Torn pages.
56	2	2023-05-02	Pages are stained with coffee.
\.


--
-- Data for Name: multimedia_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.multimedia_item (item_id, size, type, path) FROM stdin;
5	2	\N	\N
7	4	\N	\N
8	2	\N	\N
9	2	\N	\N
10	3	\N	\N
11	5	\N	\N
12	3	\N	\N
13	4	\N	\N
14	6	\N	\N
15	2	\N	\N
17	2	\N	\N
18	1	\N	\N
19	2	\N	\N
20	2	\N	\N
21	2	\N	\N
22	2	\N	\N
23	3	\N	\N
24	2	\N	\N
25	2	\N	\N
26	4	\N	\N
27	3	\N	\N
28	1	\N	\N
29	2	\N	\N
30	2	\N	\N
31	4	\N	\N
32	3	\N	\N
67	256	\N	\N
68	256	\N	\N
1	0	application/pdf	upload\\pdf\\fevzikilas.pdf2082366b-2ede-4f94-9707-2c17c631bb96.pdf
2	0	audio/mpeg	upload\\audio\\1686612758993.mp3
3	1	video/mp4	upload\\video\\1686612859008.mp4
4	\N	\N	\N
\.


--
-- Data for Name: nonperiodical_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nonperiodical_item (item_id, author_id, isbn, edition, page_number) FROM stdin;
36	4	9780451	3	200
37	5	97874	1	250
38	6	9780148	1	1000
39	7	9783547	1	920
40	8	9783287	1	810
41	9	978599	2	315
42	10	9780657	2	1500
43	11	97873	1	1000
35	5	97803	2	277
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, message, user_id, created_at, is_read) FROM stdin;
1	You have changed the due date of The Adventures of Huckleberry Finn to 2023-06-01	10	2023-06-10 17:21:20.034494	f
2	You have changed the due date of The Adventures of Huckleberry Finn to 2023-06-16	10	2023-06-10 17:22:06.028405	f
3	You have returned The Lord of the Rings	13	2023-06-10 17:56:16.861488	f
4	You have returned The Adventures of Huckleberry Finn	12	2023-06-10 17:59:48.069021	f
8	You have returned The Picture of Dorian Gray	18	2023-06-10 18:00:36.796411	f
9	You have rented The Lord of the Rings	18	2023-06-12 18:53:47.694575	f
10	You have returned The Lord of the Rings	18	2023-06-12 18:54:07.30676	f
\.


--
-- Data for Name: otpcode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otpcode (user_id, otp, createdat, expiresat) FROM stdin;
\.


--
-- Data for Name: periodical_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periodical_item (item_id, frequency, volume_number, living) FROM stdin;
45	monthly	308	t
46	weekly	56	f
47	monthly	92	t
48	weekly	210	t
49	monthly	96	t
50	monthly	128	t
51	weekly	672	t
52	weekly	732	t
53	monthly	68	t
54	monthly	272	t
55	daily	62	t
56	daily	75	t
57	daily	150	t
59	daily	90	t
60	daily	45	t
61	weekly	32	t
62	weekly	80	t
63	daily	120	t
64	daily	250	t
65	daily	80	t
69	monthly	7	t
44	monthly	7	t
\.


--
-- Data for Name: processing_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.processing_history (query_id, id, admin, executed_query, query_params, "timestamp", query_duration) FROM stdin;
175	18	f	INSERT INTO list (user_id, list_name) VALUES ($1::INTEGER, $2::VARCHAR)	{"params": [18, ""]}	2023-06-12 21:24:03.394155	6
177	18	f	INSERT INTO list (user_id, list_name) VALUES ($1::INTEGER, $2::VARCHAR)	{"params": [18, "beğenmediklerim"]}	2023-06-12 21:27:21.301716	6
179	18	f	UPDATE list SET list_name = $1::VARCHAR WHERE list_id = $2::INTEGER	{"params": ["New Books", "22"]}	2023-06-12 21:46:33.387115	5
181	18	f	UPDATE list SET list_name = $1::VARCHAR WHERE list_id = $2::INTEGER	{"params": ["My books", "22"]}	2023-06-12 22:06:40.814631	5
183	18	f	INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1OTk3NzUsImV4cCI6MTY4OTE5MTc3NX0.Aa46qVrouyv7ZEulm_5mfPFvpr6Z4jSeW0cCwtxCEn4", "2023-07-12T19:56:15.198Z", false]}	2023-06-12 22:56:15.201223	2
187	13	t	DELETE FROM refresh_tokens WHERE token = $1::VARCHAR	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY2MDQ5OTYsImV4cCI6MTY4OTE5Njk5Nn0.xauIUyqs0WNI6SF4I9T7ln0Zbvi90u4ooSIlTOf3Rs0"]}	2023-06-13 00:24:26.282302	2
194	21	f	DELETE FROM refresh_tokens WHERE token = $1::VARCHAR	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyMSwiZW1haWwiOiJiMjIwMDM1NjgyMkBjcy5oYWNldHRlcGUuZWR1LnRyIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY2MDY3NzgsImV4cCI6MTY4OTE5ODc3OH0.94HgzXenCBBNpMfBHqQ03T-N87E8tHk4nDXK6r3zpNI"]}	2023-06-13 00:54:00.825957	1
196	21	f	CALL add_reservation($1::INTEGER, $2::INTEGER)	{"params": ["51", 21]}	2023-06-13 00:57:56.220946	68
198	21	f	INSERT INTO item_list (list_id, item_id) VALUES ($1, $2)	{"params": ["28", "21"]}	2023-06-13 01:03:37.508131	7
200	21	f	UPDATE user_account SET photo = $1::VARCHAR, photo_type = $2::VARCHAR WHERE user_id = $3::INTEGER	{"params": ["upload\\\\image\\\\1686607566221.jpg", "image/jpeg", 21]}	2023-06-13 01:06:06.276916	1
202	21	f	DELETE FROM refresh_tokens WHERE token = $1::VARCHAR	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyMSwiZW1haWwiOiJiMjIwMDM1NjgyMkBjcy5oYWNldHRlcGUuZWR1LnRyIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY2MDY4NjEsImV4cCI6MTY4OTE5ODg2MX0.4ubbn7LFrfjjPEBMwaeiUBS-24xqBNNAfZVupAcWxdE"]}	2023-06-13 01:08:19.51373	1
203	13	t	INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY2MDc3MDYsImV4cCI6MTY4OTE5OTcwNn0.gmKSmvKiVPHKdPxmisqQnC2XFfyQgLFsDIgEAs6O9_k", "2023-07-12T22:08:26.419Z", true]}	2023-06-13 01:08:26.42161	1
205	13	t	UPDATE multimedia_item SET type = $1::VARCHAR, path = $2::VARCHAR, size = $3::INTEGER WHERE item_id = $4::INTEGER	{"params": ["audio/mpeg", "upload\\\\audio\\\\1686612758993.mp3", 0, "2"]}	2023-06-13 02:32:39.048326	2
207	13	t	UPDATE multimedia_item SET type = $1::VARCHAR, path = $2::VARCHAR, size = $3::INTEGER WHERE item_id = $4::INTEGER	{"params": ["application/pdf", "upload\\\\pdf\\\\G. Michael Schneider - Invitation to Computer Science-Cengage Learning (2018).pdf94582022-83ba-44dd-b25a-d6e445fc9525.pdf", 23, "4"]}	2023-06-13 02:36:34.711897	2
209	13	t	UPDATE multimedia_item SET type = $1::VARCHAR, path = $2::VARCHAR, size = $3::INTEGER WHERE item_id = $4::INTEGER	{"params": ["video/mp4", "upload\\\\video\\\\1686613297828.mp4", 1, "4"]}	2023-06-13 02:41:37.897082	1
210	13	t	UPDATE multimedia_item SET type = $1, path = $2, size = $3 WHERE item_id = $4::INTEGER	{"params": [null, null, null, "4"]}	2023-06-13 02:41:41.16027	4
176	18	f	DELETE FROM list WHERE list_id = $1	{"params": ["25"]}	2023-06-12 21:24:17.238503	9
178	18	f	DELETE FROM list WHERE list_id = $1	{"params": ["26"]}	2023-06-12 21:27:51.744738	5
180	18	f	UPDATE list SET list_name = $1::VARCHAR WHERE list_id = $2::INTEGER	{"params": ["New Books", "22"]}	2023-06-12 21:47:00.530027	5
182	18	f	DELETE FROM refresh_tokens WHERE token = $1::VARCHAR	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1ODUzMjAsImV4cCI6MTY4OTE3NzMyMH0.7h9Y7VSwBJY1tLUlw2iIwtKrTXU_i3k0PwJNaWuEfLA"]}	2023-06-12 22:55:21.573094	6
184	18	f	DELETE FROM refresh_tokens WHERE token = $1::VARCHAR	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1OTk3NzUsImV4cCI6MTY4OTE5MTc3NX0.Aa46qVrouyv7ZEulm_5mfPFvpr6Z4jSeW0cCwtxCEn4"]}	2023-06-13 00:08:29.390129	5
186	13	t	CALL add_user_account($1::VARCHAR, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR, $5::VARCHAR, $6::VARCHAR, $7::INTEGER, $8::VARCHAR, $9::BOOLEAN, $10::SMALLINT, $11::INTEGER)	{"params": ["nazmi ibo", "kılas", "b2200356822@cs.hacettepe.edu.tr", "nazmi_ibo", "$2b$10$lnrwziKjNm.RWdvmUoda7OAYKC3s5FzWYrMBxPn9AhDZ6Cz5iubKS", "44433473514", 13, "2199595", false, 4, 1]}	2023-06-13 00:24:15.09558	9
193	21	f	INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyMSwiZW1haWwiOiJiMjIwMDM1NjgyMkBjcy5oYWNldHRlcGUuZWR1LnRyIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY2MDY3NzgsImV4cCI6MTY4OTE5ODc3OH0.94HgzXenCBBNpMfBHqQ03T-N87E8tHk4nDXK6r3zpNI", "2023-07-12T21:52:58.507Z", false]}	2023-06-13 00:52:58.510311	2
195	21	f	INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)	{"params": ["eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyMSwiZW1haWwiOiJiMjIwMDM1NjgyMkBjcy5oYWNldHRlcGUuZWR1LnRyIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY2MDY4NjEsImV4cCI6MTY4OTE5ODg2MX0.4ubbn7LFrfjjPEBMwaeiUBS-24xqBNNAfZVupAcWxdE", "2023-07-12T21:54:21.622Z", false]}	2023-06-13 00:54:21.624411	2
197	21	f	INSERT INTO list (user_id, list_name) VALUES ($1::INTEGER, $2::VARCHAR)	{"params": [21, "Benim Kitaplarım"]}	2023-06-13 01:02:30.747312	6
199	21	f	CALL delete_reservation($1::INTEGER, $2::INTEGER)	{"params": ["51", 21]}	2023-06-13 01:05:15.298778	12
201	21	f	UPDATE user_account SET photo = $1::VARCHAR, photo_type = $2::VARCHAR WHERE user_id = $3::INTEGER	{"params": ["upload\\\\image\\\\1686607674243.png", "image/png", 21]}	2023-06-13 01:07:54.302986	2
204	13	t	UPDATE multimedia_item SET type = $1::VARCHAR, path = $2::VARCHAR, size = $3::INTEGER WHERE item_id = $4::INTEGER	{"params": ["application/pdf", "upload\\\\pdf\\\\fevzikilas.pdf2082366b-2ede-4f94-9707-2c17c631bb96.pdf", 0, "1"]}	2023-06-13 02:02:07.038621	2
206	13	t	UPDATE multimedia_item SET type = $1::VARCHAR, path = $2::VARCHAR, size = $3::INTEGER WHERE item_id = $4::INTEGER	{"params": ["video/mp4", "upload\\\\video\\\\1686612859008.mp4", 1, "3"]}	2023-06-13 02:34:19.036331	1
208	13	t	UPDATE multimedia_item SET type = $1, path = $2, size = $3 WHERE item_id = $4::INTEGER	{"params": [null, null, null, "4"]}	2023-06-13 02:37:18.220442	5
\.


--
-- Data for Name: publisher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publisher (publisher_id, publisher_name) FROM stdin;
1	HarperCollins
2	Scribner
3	Secker & Warburg
4	George Allen & Unwin
5	T. Egerton
7	Bloomsbury Publishing
8	Little, Brown
9	The Russian Messenger
10	Doubleday
11	Hogarth Press
12	Harper & Row
13	Harper & Brothers
14	Harcourt Brace Jovanovich
15	Jonathan Cape & Harrison Smith
16	Lippincott's Monthly Magazine
17	Charles Scribner's Sons
18	Blackwood's Magazine
19	Alfred A. Knopf
20	Chatto & Windus
21	George Newnes Ltd
22	William Heinemann
23	Editorial Sudamericana
24	Harvill Secker
25	J. B. Lippincott
26	A. Lacroix, Verboeckhoven & Cie
27	National Geographic Partners
28	Springer Nature
29	Condé Nast
30	Time USA, LLC
31	Hearst Communications, Inc.
32	The Economist Group
33	Harvard Business Publishing
34	Penske Media Corporation
35	Guardian Media Group
36	News UK
37	Dow Jones & Company
39	Grupo Prisa
40	Groupe Le Monde
41	Die Zeit Verlagsgruppe
42	Editora Abril
43	Al-Ahram Foundation
44	The Yomiuri Shimbun Holdings
45	Alibaba Group
47	Can Yayınları
48	Little, Brown and Company
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rating (user_id, item_id, rate) FROM stdin;
7	40	40
12	41	5
13	41	10
18	4	9
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, token, expires_at, admin) FROM stdin;
74	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzMDY1NzksImV4cCI6MTY4ODg5ODU3OX0.isDXut94RZRmm_i8KYdWGHP3WkRGAss7yf8Y1Luki4o	2023-07-09 13:29:39.718	t
76	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYzMDkwMzgsImV4cCI6MTY4ODkwMTAzOH0.QUwFa_PIaaZ9R-IFJOkTftgsdhty9fG5T_y8WBnALrg	2023-07-09 14:10:38.085	f
79	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYzMDk1MzAsImV4cCI6MTY4ODkwMTUzMH0.oUbzLpuyXZaanINipbHAlI3lGSq_0xtlIZgWiFBDYVE	2023-07-09 14:18:50.739	f
82	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTczNzIsImV4cCI6MTY4ODk4OTM3Mn0.lLCHxa3JKvZbMt0s5WNbe_gpkit6lz-CqV-_Na1X8EI	2023-07-10 14:42:52.265	t
83	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTczNzIsImV4cCI6MTY4ODk4OTM3Mn0.lLCHxa3JKvZbMt0s5WNbe_gpkit6lz-CqV-_Na1X8EI	2023-07-10 14:42:52.309	t
85	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc0MjQsImV4cCI6MTY4ODk4OTQyNH0.moe2VGlLmAKDdMWlbYyyeLZzZKPiqQBdDTRPPtHhS9o	2023-07-10 14:43:44.464	t
87	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc1MjksImV4cCI6MTY4ODk4OTUyOX0.SMTmZozJs_cdXkyFCNaKPgQ59oIQKmaZoba6cwbUbeI	2023-07-10 14:45:29.453	t
89	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc1NzMsImV4cCI6MTY4ODk4OTU3M30.ro8lWTYRq2eeTXB-rEL_oRrGpMA7dToqtxcoRKuxjrA	2023-07-10 14:46:13.532	t
91	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc3MjksImV4cCI6MTY4ODk4OTcyOX0.p-Wv3VHwpzPSoNVwccqUUJtaDP1eokPU3A9yzH85ZoM	2023-07-10 14:48:49.162	t
93	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTg3NTIsImV4cCI6MTY4ODk5MDc1Mn0.YCWhNPO8muweoo0lzapiMrv20dSTutsUfR5bFkBSw0E	2023-07-10 15:05:52.642	t
95	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDA4NzEsImV4cCI6MTY4ODk5Mjg3MX0._3me8jCmfwL3MqZwu0StNxwMQmDMcGx2hyrh8yjv7kY	2023-07-10 15:41:11.652	t
97	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDMwNTcsImV4cCI6MTY4ODk5NTA1N30.giidLfGrFmeUoSZhdUAmF2Bz2Qg5DPpaWax_LBEaR9I	2023-07-10 16:17:37.819	t
98	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDMwNjAsImV4cCI6MTY4ODk5NTA2MH0.whJCte1ZQ7Bvg1Y8CQXoWidjXWY5r2psqBrQ2LqZEJA	2023-07-10 16:17:40.674	t
100	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDgwMTMsImV4cCI6MTY4OTAwMDAxM30.0y-ZJg7aptNvn4gE5qHzcGwBHASvfV0BiqN3PIcGzZA	2023-07-10 17:40:13.562	t
101	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDgwMTksImV4cCI6MTY4OTAwMDAxOX0.ljzhldOFQ_grtB_qO4GnOGNlq0CK8CZLbOQUBkq1vAU	2023-07-10 17:40:19.787	t
103	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1MDMyNjYsImV4cCI6MTY4OTA5NTI2Nn0.m1OW5k8_aJJ6Gn3jI1M-B9Z0IC0hsVtGXU8Z4QGTmxk	2023-07-11 20:07:46.404	f
105	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1MDY5NTUsImV4cCI6MTY4OTA5ODk1NX0.Ji0Q5JXqnfonWMx497hTIDBszlgoEbrRXzqIJs2ODjI	2023-07-11 21:09:15.906	t
107	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1MDcwMTgsImV4cCI6MTY4OTA5OTAxOH0.x1Rs-StNsqczZ5WufGx88dJeA2FyXjLIcDu7BYRRSRk	2023-07-11 21:10:18.119	t
109	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1MDcyMTgsImV4cCI6MTY4OTA5OTIxOH0.aX3wqowQmc08lywFxZTvbVjjyTQkfe9ytvkRj6-GzIw	2023-07-11 21:13:38.971	t
111	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1NTIwNzYsImV4cCI6MTY4OTE0NDA3Nn0.8cAoaiJ2POs9cGnML568OwAE3gZYFpCwo7bAJb6BBNQ	2023-07-12 09:41:16.222	t
113	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1NjA5MzQsImV4cCI6MTY4OTE1MjkzNH0.qu_wiKNiqDjX5zVz5q_f5ViWDrzBlChtRMw_e7WiIPM	2023-07-12 12:08:54.947	f
115	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1NjEzNDAsImV4cCI6MTY4OTE1MzM0MH0.b7Fo5m8rC7FYvSD6FvXuQtneVjswkdtn-IckQ76k9o0	2023-07-12 12:15:40.175	f
117	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1NjI5MTEsImV4cCI6MTY4OTE1NDkxMX0.OGZeLstxDAT0CzMK5woZKJrmvEmfny37eO03p-ezAYM	2023-07-12 12:41:51.86	f
119	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1NjQyNzcsImV4cCI6MTY4OTE1NjI3N30.w2gPB0Lv8si0LXz210nxclZhonYrRRH2Af_hf4akziA	2023-07-12 13:04:37.3	f
127	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY2MDc3MDYsImV4cCI6MTY4OTE5OTcwNn0.gmKSmvKiVPHKdPxmisqQnC2XFfyQgLFsDIgEAs6O9_k	2023-07-13 01:08:26.419	t
75	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzMDg4MDksImV4cCI6MTY4ODkwMDgwOX0.1-FdcXn7BgrEn6177rVFEOrhA3Bm8lYzK0e2aFktBSg	2023-07-09 14:06:49.09	t
77	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzMDkyNTUsImV4cCI6MTY4ODkwMTI1NX0.ClQBpZWehipf5mJ4EbPsgT-Q3-K8s3RFJzko-4imgFo	2023-07-09 14:14:15.923	t
78	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzMDkyNTgsImV4cCI6MTY4ODkwMTI1OH0.ZY92gFQevPaum8PiCmLAKohrpIZX3pqnfR_KQGbOIXM	2023-07-09 14:14:18.914	t
80	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTU4MjAsImV4cCI6MTY4ODk4NzgyMH0.6d-6HxTvvLhKVmrJ6Lg2OATl43-3iDqnosonHMFPu8A	2023-07-10 14:17:00.509	t
81	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTU4MjQsImV4cCI6MTY4ODk4NzgyNH0.1gFZHwUDe5OWiynp6UQS8YikNmjMbkLemSjYNd_jH9o	2023-07-10 14:17:04.489	t
84	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTczODUsImV4cCI6MTY4ODk4OTM4NX0.-LSRvS_Ne_3q4ivCzoh4DgbsDb9cm5ZECJxnk-WyH7c	2023-07-10 14:43:05.203	t
86	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc1MDgsImV4cCI6MTY4ODk4OTUwOH0.g4EtKcmg8fkoXH1mE5SL4a39b-kqR6a36YEnVIFy2f0	2023-07-10 14:45:08.063	t
88	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc1NTIsImV4cCI6MTY4ODk4OTU1Mn0.80QhIQaePygYeXgUikxoA72EcGOWvltcnhPxIGpgRVs	2023-07-10 14:45:52.122	t
90	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc2NDIsImV4cCI6MTY4ODk4OTY0Mn0.x4XYDIXygn6RqCR3z3x44er9ZCYYgUMc6vrQlfzygsw	2023-07-10 14:47:22.652	t
92	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTc3MzksImV4cCI6MTY4ODk4OTczOX0.pqZ60mBZBhW6xrzUrLXSBtFbq8heIwB9FyI-u54Wl04	2023-07-10 14:48:59.491	t
94	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYzOTk2OTcsImV4cCI6MTY4ODk5MTY5N30.zgjW429kCTgVwQdxQ90Nwr_Amn7Xq9BHwNkUugwxPZ4	2023-07-10 15:21:37.489	t
96	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0MDE5NDksImV4cCI6MTY4ODk5Mzk0OX0.TjB4L7AqcI0TnXGjpb9f8x6wcpSQ6r9LgLa3srQ9qDY	2023-07-10 15:59:09.563	t
99	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY0MDc2ODQsImV4cCI6MTY4ODk5OTY4NH0.EEbXAaeOf3ulGtpVQQGibyLOAvMXaNh9mmE_HaIwti8	2023-07-10 17:34:44.761	f
102	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY0Njg0MjEsImV4cCI6MTY4OTA2MDQyMX0.fxdP4_4aXX7GqXb-42Mw826JgINW950PyelAxxuZnYo	2023-07-11 10:27:01.294	t
66	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk1NDAsImV4cCI6MTY4ODg5MTU0MH0.SlpiquZcZui4mR9psk6gcrQwx4xfehbsXujUuHNrgVs	2023-07-09 11:32:20.391	f
67	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk2NzksImV4cCI6MTY4ODg5MTY3OX0.9NZeu1bC-VDtNmrZ3WjO2issnB03PlqeW58ip632IXg	2023-07-09 11:34:39.796	f
68	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk3MTgsImV4cCI6MTY4ODg5MTcxOH0.1y7rpOxzJZesEpQygNinTd8Sk76ucdfpawrolO1rUwg	2023-07-09 11:35:18.96	f
69	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk3NTIsImV4cCI6MTY4ODg5MTc1Mn0.zVjOCH0DhG6EOgcFZ15qjpAvisqfG5dJpV9RnZ0AWPI	2023-07-09 11:35:52.331	f
70	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYyOTk3NTUsImV4cCI6MTY4ODg5MTc1NX0.kGtyYZuZrN89LnlcAi0EYBuim6YfwfDpOCx6bbSTG3A	2023-07-09 11:35:55.629	t
71	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk3NTgsImV4cCI6MTY4ODg5MTc1OH0.xUZUFx9LvNka0ClysTywUC1dcBGvcqv6qsFHK_b1wG0	2023-07-09 11:35:58.307	f
72	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODYyOTk4NTgsImV4cCI6MTY4ODg5MTg1OH0.DFUDnH7_U14j6fcyqXYxD_CpG5t_w_-T4TNAOJlBiSs	2023-07-09 11:37:38.486	t
73	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODYyOTk4NzYsImV4cCI6MTY4ODg5MTg3Nn0.lJdBskYArhIuk_y2BNTyYDoTHvw4SBrnhp00K26AyX0	2023-07-09 11:37:56.303	f
104	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1MDY3OTAsImV4cCI6MTY4OTA5ODc5MH0.VsAP26XgAJHkU5FZ5_509VPvLdz8SZ_8TwdX7So-AGM	2023-07-11 21:06:30.077	f
106	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1MDY5NzEsImV4cCI6MTY4OTA5ODk3MX0.1Ml28ZWB85qQE5mL393Uomyixn35yAWODsioejfP0EU	2023-07-11 21:09:31.827	t
108	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1MDcwNTQsImV4cCI6MTY4OTA5OTA1NH0.xSv-_QXaBsN-zHuwbmJhGFzHokxCfLE4mi-1blJoIEk	2023-07-11 21:10:54.374	f
110	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1MDcyMzMsImV4cCI6MTY4OTA5OTIzM30.SKDx5XXU1SvdgZskddVYDtyJdbt11JeUa7fUeG5lCE4	2023-07-11 21:13:53.107	f
112	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxOCwiZW1haWwiOiJqb2huQGV4YW1wbGUuY29tIiwiYWRtaW4iOmZhbHNlLCJpYXQiOjE2ODY1NTIyNTIsImV4cCI6MTY4OTE0NDI1Mn0.JQ_l0aJLejxyVDtxD4zUY-Vc-DgL4A3y3oyHHCGZgFo	2023-07-12 09:44:12.23	f
114	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1NjExNTksImV4cCI6MTY4OTE1MzE1OX0.DifdNDJfgDksOAhgXQAv6VAwo8pnhy5VWzhOdZxsOgA	2023-07-12 12:12:39.277	t
116	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1NjI2MDksImV4cCI6MTY4OTE1NDYwOX0.aWAmUdLqyaxWAELE_VfNFtN_PAz9zEApf-c3jE6IuSQ	2023-07-12 12:36:49.54	t
118	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1NjM3ODEsImV4cCI6MTY4OTE1NTc4MX0.V11WKg8BbFN2BcWb8T2lVpdapxuuU1XSQNFmn9-CEMo	2023-07-12 12:56:21.369	t
120	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbl9pZCI6MTMsImVtYWlsIjoiZmV2emlAZ29vZ2xlLmNvbSIsImFkbWluIjp0cnVlLCJpYXQiOjE2ODY1ODQ4OTAsImV4cCI6MTY4OTE3Njg5MH0.yhw2h1EOegUFB5yR-5L-YmJIR9-xIbDJpuhGMQeMmFE	2023-07-12 18:48:10.612	t
\.


--
-- Data for Name: rental_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rental_log (item_id, user_id, rent_date, due_date, extratime_counter, admin_id) FROM stdin;
46	9	2023-05-02	2023-05-17	0	2
47	14	2023-05-02	2023-06-01	0	9
48	14	2023-05-02	2023-06-01	0	1
50	11	2023-05-02	2023-05-17	0	5
20	1	2023-05-02	2023-05-17	0	5
21	1	2023-05-02	2023-05-17	0	2
23	11	2023-05-02	2023-05-17	0	9
26	11	2023-05-02	2023-05-17	0	5
3	3	2023-05-03	2023-05-18	0	1
5	12	2023-05-03	2023-05-18	0	1
7	13	2023-05-03	2023-06-02	0	1
44	5	2023-05-02	2023-06-01	1	8
45	2	2023-05-02	2023-06-01	1	5
41	13	2023-05-06	2023-06-05	0	1
24	10	2023-05-02	2023-06-16	2	1
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation (user_id, item_id, state, reservation_end_date) FROM stdin;
9	20	valid	\N
10	21	valid	\N
12	23	valid	\N
18	3	invalid	\N
\.


--
-- Data for Name: return_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_history (return_id, user_id, item_id, due_date, return_date, is_late, received_fee, description, admin_id, rent_date) FROM stdin;
1	7	40	2023-05-17	2023-05-02	f	0.00	no damage	3	2023-05-02
2	12	41	2023-05-17	2023-05-02	f	0.00	no damage	8	2023-05-02
3	15	42	2023-05-17	2023-05-02	f	0.00	no damage	6	2023-05-02
4	8	43	2023-05-17	2023-05-02	f	0.00	missing cover	1	2023-05-02
5	2	2	2023-07-02	2023-05-04	f	0.00	nothing	1	2023-05-03
6	13	4	2023-06-02	2023-06-10	t	24.00	nothing	1	2023-05-03
7	12	22	2023-05-17	2023-06-10	t	24.00	nothing	4	2023-05-02
11	9	25	2023-05-17	2023-06-10	t	24.00	aassad	1	2023-05-02
12	18	4	2023-06-27	2023-06-12	f	0.00	nothing.	13	2023-06-12
\.


--
-- Data for Name: serie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serie (serie_id, serie_name) FROM stdin;
1	
2	The Lord of the Rings
4	Harry Potter
5	Robert Langdon
6	Sherlock Holmes
7	National Geographic Magazine
8	Scientific American
9	The New Yorker
10	Wired
11	Time Magazine
12	Popular Mechanics
13	Vogue
14	The Economist
15	Nature
16	Harvard Business Review
17	Rolling Stone
18	The Guardian
19	The Times
20	The Wall Street Journal
22	El País
23	Le Monde
24	Die Zeit
25	Veja
26	Al-Ahram
27	Yomiuri Shimbun
28	South China Morning Post
30	Romanlar
31	\N
32	\N
33	Modern Classics
34	\N
\.


--
-- Data for Name: shelf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shelf (shelf_id, shelf_code) FROM stdin;
1	A1
2	B2
3	C3
4	D4
5	E5
6	F6
7	G7
8	H8
9	I9
10	J10
11	K11
\.


--
-- Data for Name: user_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_account (user_id, first_name, last_name, user_type_id, email, username, password, phone_number, rental_counter, admin_id, id_number, banned, photo, photo_type) FROM stdin;
4	Daniel	Davis	1	daniel.davis@example.com	danield	passwordabc	555-3456	0	7	890123456	t	\N	\N
5	Olivia	Wilson	1	olivia.wilson@example.com	oliviaw	passworddef	555-7890	1	1	345678901	f	\N	\N
1	Emma	Johnson	1	emma.johnson@example.com	emmaj	$2b$10$z608VGXGwT4vBNk3ucYKhegF1Chth6pJNF/4z.14dHhZ6QWZsGUfm	555-1234	2	5	123456789	t	\N	\N
14	Benjamin	Franklin	5	besn.gonzalez@example.com	benming	passwo67	545-6789	2	1	789245	t	\N	\N
3	Sophia	Garcia	2	sophia.garcia@example.com	sophiag	password789	555-9012	1	10	234567890	f	\N	\N
2	William	Brown	1	william.brown@example.com	willb	password456	555-5678	1	2	987654321	f	\N	\N
11	Charlotte	Moore	1	charlotte.moore@example.com	charlottem	passwordvwx	555-3456	3	5	678901234	f	\N	\N
7	Ava	Anderson	1	ava.anderson@example.com	avaa	passwordjkl	555-6789	0	1	012345678	f	\N	\N
15	Peter	Parker	4	peterail.parker@example.com	petergailp	passwo890	535-1234	0	2	2342267890	t	\N	\N
8	Ethan	Taylor	2	ethan.taylor@example.com	ethant	passwordmno	555-1234	0	8	345678901	f	\N	\N
10	Alexander	Hernandez	2	alexander.hernandez@example.com	alexanderh	passwordstu	555-9012	2	1	234567890	f	\N	\N
6	James	Martinez	1	james.martinez@example.com	jamesm	passwordghi	555-2345	2	3	678901234	f	\N	\N
16	John2	Doe	1	john.doe@example.com	johndoe	$2b$10$BufHeGOIV7YpXLKYAz6MauQR5P5m62qL1fwhjn3HLCQOTHV9mUVHW	555-1234	2	1	1234567890	t	\N	\N
21	nazmi ibo	kılas	4	b2200356822@cs.hacettepe.edu.tr	nazmi_ibo	$2b$10$Oomt6yHAK5ZGPcavQw5OU.Ha35wWShDkD7QgKg4KqX24zCMF0uINS	44433473514	0	13	2199595	f	upload\\image\\1686607674243.png	image/png
13	Emily	Lee	3	emily.lee@example.com	emilyl	password234	555-2345	2	6	345678901	t	\N	\N
12	Michael	Jackson	1	michael.jackson@example.com	michaelj	passwordyz1	555-7890	2	2	012345678	f	\N	\N
9	Mia	Thomas	1	mia.thomas@example.com	miat	passwordpqr	555-5678	2	1	789012345	f	\N	\N
19	ibrahim	kılas	3	ibrahim@google.com	ibo	$2b$10$PMKLRw9wsJrJTrDaKs7XkOzQHpgmq2y0v2W0UmhNJhUE9T6S4Hvn2	555-555-5555	0	13	2191212	f	\N	\N
20	nazmi	kılas	4	nazmi@google.com	nazmikılas	$2b$10$T4HlYJF/jVjwBOReOD9ByO.DAMSx5ZipYRupTXAVMkU3gV0r/kmu2	5333333333	0	13	2010101	f	\N	\N
18	John	Doe	2	john@example.com	johndoe	$2b$10$PN76PW8.cO9dpA5/J1E/EeODQhH7A9JYOVgYxLFfmj.mntIPbnLji	555-1234	1	13	1234567890_1	f	upload\\image\\1686562252471.jpg	image/jpeg
\.


--
-- Data for Name: user_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_type (user_type_id, type_name, max_extratime, max_rental, max_reservation_day, penalty_fee, rental_time) FROM stdin;
1	STUDENT	3	3	2	1	15
2	GRADUATED	3	3	2	5	15
3	INSTRUCTOR	5	5	2	3	30
4	PERSONAL	5	5	2	3	15
5	TECHNICAL ASSISTANT	5	2	2	2	30
\.


--
-- Name: access_item_history_query_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_item_history_query_id_seq', 208, true);


--
-- Name: admin_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_admin_id_seq', 14, true);


--
-- Name: author_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.author_author_id_seq', 11, true);


--
-- Name: branch_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_branch_id_seq', 33, true);


--
-- Name: genre_genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genre_genre_id_seq', 32, true);


--
-- Name: heading_heading_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heading_heading_id_seq', 59, true);


--
-- Name: item_format_format_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_format_format_id_seq', 3, true);


--
-- Name: item_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_item_id_seq', 71, true);


--
-- Name: language_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_language_id_seq', 10, true);


--
-- Name: list_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.list_list_id_seq', 28, true);


--
-- Name: maintenance_history_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.maintenance_history_maintenance_id_seq', 6, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 10, true);


--
-- Name: processing_history_query_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.processing_history_query_id_seq', 210, true);


--
-- Name: publisher_publisher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publisher_publisher_id_seq', 48, true);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 127, true);


--
-- Name: return_history_return_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_history_return_id_seq', 12, true);


--
-- Name: serie_serie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serie_serie_id_seq', 34, true);


--
-- Name: shelf_shelf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shelf_shelf_id_seq', 13, true);


--
-- Name: user_account_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_account_user_id_seq', 21, true);


--
-- Name: user_type_user_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_type_user_type_id_seq', 7, true);


--
-- Name: access_item_history access_item_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_item_history
    ADD CONSTRAINT access_item_history_pkey PRIMARY KEY (query_id);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (admin_id);


--
-- Name: author author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (author_id);


--
-- Name: banned_user banned_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_user_pkey PRIMARY KEY (user_id);


--
-- Name: branch branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genre_id);


--
-- Name: heading heading_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.heading
    ADD CONSTRAINT heading_pkey PRIMARY KEY (heading_id);


--
-- Name: item_format item_format_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_format
    ADD CONSTRAINT item_format_pkey PRIMARY KEY (format_id);


--
-- Name: item_heading item_heading_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_heading
    ADD CONSTRAINT item_heading_pkey PRIMARY KEY (heading_id, item_id);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (item_id);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (language_id);


--
-- Name: list list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (list_id);


--
-- Name: lost_item lost_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lost_item
    ADD CONSTRAINT lost_item_pkey PRIMARY KEY (item_id);


--
-- Name: maintenance_history maintenance_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_history
    ADD CONSTRAINT maintenance_history_pkey PRIMARY KEY (maintenance_id);


--
-- Name: maintenance_log maintenance_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_log
    ADD CONSTRAINT maintenance_log_pkey PRIMARY KEY (item_id);


--
-- Name: multimedia_item multimedia_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multimedia_item
    ADD CONSTRAINT multimedia_item_pkey PRIMARY KEY (item_id);


--
-- Name: nonperiodical_item nonperiodical_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonperiodical_item
    ADD CONSTRAINT nonperiodical_item_pkey PRIMARY KEY (item_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: otpcode otpcode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otpcode
    ADD CONSTRAINT otpcode_pkey PRIMARY KEY (user_id);


--
-- Name: periodical_item periodical_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodical_item
    ADD CONSTRAINT periodical_item_pkey PRIMARY KEY (item_id);


--
-- Name: processing_history processing_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processing_history
    ADD CONSTRAINT processing_history_pkey PRIMARY KEY (query_id);


--
-- Name: publisher publisher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (publisher_id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: rental_log rental_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_log
    ADD CONSTRAINT rental_log_pkey PRIMARY KEY (item_id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (item_id);


--
-- Name: return_history return_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_history
    ADD CONSTRAINT return_history_pkey PRIMARY KEY (return_id);


--
-- Name: serie serie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (serie_id);


--
-- Name: shelf shelf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelf
    ADD CONSTRAINT shelf_pkey PRIMARY KEY (shelf_id);


--
-- Name: user_account user_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account
    ADD CONSTRAINT user_account_pkey PRIMARY KEY (user_id);


--
-- Name: user_type user_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_type
    ADD CONSTRAINT user_type_pkey PRIMARY KEY (user_type_id);


--
-- Name: author_first_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX author_first_name ON public.author USING btree (first_name);


--
-- Name: author_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX author_last_name ON public.author USING btree (last_name);


--
-- Name: item_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX item_name ON public.item USING btree (name);


--
-- Name: reservation trg_update_notification_on_update_reservation_state; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_notification_on_update_reservation_state AFTER UPDATE OF state ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.trg_update_notification_on_update_reservation_state();


--
-- Name: lost_item trg_update_on_delete_lost_item; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_on_delete_lost_item AFTER DELETE ON public.lost_item FOR EACH ROW EXECUTE FUNCTION public.trg_update_on_delete_lost_item();


--
-- Name: maintenance_history trg_update_on_maintenance_history; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_on_maintenance_history AFTER INSERT ON public.maintenance_history FOR EACH ROW EXECUTE FUNCTION public.trg_update_on_maintenance_history();


--
-- Name: return_history trg_update_on_return_history; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_on_return_history AFTER INSERT ON public.return_history FOR EACH ROW EXECUTE FUNCTION public.trg_update_on_return_history();


--
-- Name: user_account trg_update_reservation_rating_list_on_delete_user; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_reservation_rating_list_on_delete_user AFTER DELETE ON public.user_account FOR EACH ROW EXECUTE FUNCTION public.trg_update_reservation_rating_list_on_delete_user();


--
-- Name: banned_user trg_update_user_unban; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_user_unban BEFORE DELETE ON public.banned_user FOR EACH ROW EXECUTE FUNCTION public.trg_update_user_unban();


--
-- Name: list update_item_list_on_delete_list; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_list_on_delete_list AFTER DELETE ON public.list FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_list_on_delete_list();


--
-- Name: rating update_item_on_delete_rating; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_on_delete_rating BEFORE DELETE ON public.rating FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_on_delete_rating();


--
-- Name: lost_item update_item_on_lost_item; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_on_lost_item AFTER INSERT ON public.lost_item FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_on_lost_item();


--
-- Name: maintenance_log update_item_on_maintenance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_on_maintenance AFTER INSERT ON public.maintenance_log FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_on_maintenance();


--
-- Name: reservation update_item_on_reservation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_on_reservation AFTER INSERT ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_on_reservation();


--
-- Name: reservation update_item_user_on_delete_reservation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_user_on_delete_reservation AFTER DELETE ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_user_on_delete_reservation();


--
-- Name: rental_log update_item_user_on_rental; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_item_user_on_rental AFTER INSERT ON public.rental_log FOR EACH ROW EXECUTE FUNCTION public.trg_update_item_user_on_rental();


--
-- Name: banned_user update_user_ban; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_ban AFTER INSERT ON public.banned_user FOR EACH ROW EXECUTE FUNCTION public.trg_update_user_ban();


--
-- Name: access_item_history access_item_history_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_item_history
    ADD CONSTRAINT access_item_history_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: access_item_history access_item_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_item_history
    ADD CONSTRAINT access_item_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: banned_user banned_user_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_user_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: banned_user banned_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banned_user
    ADD CONSTRAINT banned_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: branch branch_shelf_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_shelf_id_fkey FOREIGN KEY (shelf_id) REFERENCES public.shelf(shelf_id);


--
-- Name: item item_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: item item_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branch(branch_id);


--
-- Name: item item_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_format_id_fkey FOREIGN KEY (format_id) REFERENCES public.item_format(format_id);


--
-- Name: item item_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre(genre_id);


--
-- Name: item_heading item_heading_heading_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_heading
    ADD CONSTRAINT item_heading_heading_id_fkey FOREIGN KEY (heading_id) REFERENCES public.heading(heading_id);


--
-- Name: item_heading item_heading_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_heading
    ADD CONSTRAINT item_heading_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: item item_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.language(language_id);


--
-- Name: item_list item_list_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_list
    ADD CONSTRAINT item_list_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: item_list item_list_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_list
    ADD CONSTRAINT item_list_list_id_fkey FOREIGN KEY (list_id) REFERENCES public.list(list_id);


--
-- Name: item item_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES public.publisher(publisher_id);


--
-- Name: item item_serie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_serie_id_fkey FOREIGN KEY (serie_id) REFERENCES public.serie(serie_id);


--
-- Name: list list_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.list
    ADD CONSTRAINT list_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: lost_item lost_item_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lost_item
    ADD CONSTRAINT lost_item_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: lost_item lost_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lost_item
    ADD CONSTRAINT lost_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: maintenance_history maintenance_history_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_history
    ADD CONSTRAINT maintenance_history_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: maintenance_history maintenance_history_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_history
    ADD CONSTRAINT maintenance_history_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: maintenance_log maintenance_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_log
    ADD CONSTRAINT maintenance_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: maintenance_log maintenance_log_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_log
    ADD CONSTRAINT maintenance_log_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: multimedia_item multimedia_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multimedia_item
    ADD CONSTRAINT multimedia_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: nonperiodical_item nonperiodical_item_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonperiodical_item
    ADD CONSTRAINT nonperiodical_item_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.author(author_id);


--
-- Name: nonperiodical_item nonperiodical_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonperiodical_item
    ADD CONSTRAINT nonperiodical_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: periodical_item periodical_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodical_item
    ADD CONSTRAINT periodical_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: rating rating_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: rating rating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: rental_log rental_log_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_log
    ADD CONSTRAINT rental_log_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: rental_log rental_log_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_log
    ADD CONSTRAINT rental_log_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: rental_log rental_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_log
    ADD CONSTRAINT rental_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: reservation reservation_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: reservation reservation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: return_history return_history_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_history
    ADD CONSTRAINT return_history_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: return_history return_history_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_history
    ADD CONSTRAINT return_history_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(item_id);


--
-- Name: return_history return_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_history
    ADD CONSTRAINT return_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_account(user_id);


--
-- Name: user_account user_account_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account
    ADD CONSTRAINT user_account_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: user_account user_account_user_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_account
    ADD CONSTRAINT user_account_user_type_id_fkey FOREIGN KEY (user_type_id) REFERENCES public.user_type(user_type_id);


--
-- PostgreSQL database dump complete
--

