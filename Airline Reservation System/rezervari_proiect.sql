---------------------------register--------------------
create or replace procedure register(email_user varchar2, parola_user varchar2) as
    v_maxim int;
    v_result int;
    
    user_existent EXCEPTION;
    PRAGMA EXCEPTION_INIT(user_existent, -20006);
begin
    select max(id_user) into v_maxim from users_app;
    SELECT count(*) into v_result FROM users_app WHERE email=email_user and parola=parola_user;
    if(v_result=0) then
        insert into users_app values (v_maxim+1, email_user, parola_user);
    else 
        raise user_existent;
    end if;
end;
/
set serveroutput on;
BEGIN
  register('doman.sabrina@gmail.com','dragoman');
END;
/
--------------------------------------login----------------------------------------------------
-------------------------verificam daca emailul si parola se afla in baza de date---------------
CREATE OR REPLACE PROCEDURE login(x varchar2, y varchar2) AS
  v_result number;
  
  user_inexistent EXCEPTION;
  PRAGMA EXCEPTION_INIT(user_inexistent, -20001);
BEGIN

  SELECT count(*) into v_result FROM users_app WHERE email=x and parola=y;
  IF ( v_result = 1 ) THEN
    DBMS_OUTPUT.PUT_LINE('Login succesfully!');
  ELSE
    RAISE user_inexistent;
  END IF;
END;
/
set serveroutput on;
BEGIN
  login('dragoman.sabrina@gmail.com','dragoman');
END;
/

-----------------------------verificare detalii plata-------------------------------------------------
--------------------se verifica autenticitatea cardului cumparatorului--------------------------------
CREATE OR REPLACE FUNCTION verificarePlata(nr_card int, nr_cvv int, data_expirare date) RETURN NUMBER AS
BEGIN
  IF(length(nr_card) = 16 and length(nr_cvv) = 3 and data_expirare > current_date) THEN
    return 1;
  ELSE
    return 0;
  END IF;
END;
/
set serveroutput on;
BEGIN
  DBMS_OUTPUT.PUT_LINE(verificarePlata(5467389203344098, 222, '12 mai 2018'));
END;
/

-----------------------------adaugare detalii plata-----------------------------
------------------in functie de tipul pasagerului se acorda diferite reduceri-------------------------
------------------daca biletul se cumpara cu mai putin de o luna inainte de data plecarii se aplica o scumpire de 10%-----------
CREATE OR REPLACE PROCEDURE detaliiPlata(nr_card int, nr_cvv int, data_exp date, id_pasag int, n_clasa varchar2, id_zboor int) AS
  v_result int;
  v_pret clasa.pret%type;
  v_bilet bilet.id_bilet%type;
  v_clasa clasa.nume_clasa%type;
  v_id_pasager pasageri.id_pasager%type; 
  v_id_plata detalii_plata.id_plata%type;
  v_tip_pasager pasageri.tip_pasager%type;
  v_data_plecare orar_rute.data_plecare%type;
  
BEGIN

  IF( verificarePlata(nr_card, nr_cvv, data_exp) = 1 ) THEN
    select max(id_plata) into v_id_plata from detalii_plata;
    select c.pret, p.tip_pasager, p.id_pasager, o.data_plecare, b.id_bilet into v_pret, v_tip_pasager, v_id_pasager, v_data_plecare, v_bilet from clasa c 
        join bilet b on c.id_zbor=b.id_zbor
        join pasageri p on b.id_pasager=p.id_pasager 
        join orar_rute o on b.id_zbor=o.id_zbor 
        where p.id_pasager=id_pasag and c.nume_clasa= n_clasa and b.id_zbor = id_zboor; 
    
    IF( v_tip_pasager = 'copil' ) THEN
      IF( months_between(v_data_plecare, current_date) >= 1 ) THEN
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager,  v_bilet, nr_card, nr_cvv, data_exp, substr(v_pret,1,length(v_pret)-1)/2 || '€.'); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' are pretul biletului: ' || substr(v_pret,1,length(v_pret)-1)/2 || '€.');
      ELSE
        v_result := substr(v_pret,1,length(v_pret)-1)/2 + 10/100;
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager,v_bilet, nr_card, nr_cvv, data_exp, v_result || '€'); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' are pretul biletului mai scump decat inainte: ' || v_result || '€.');
      END IF;
      
    ELSIF ( v_tip_pasager = 'bebelus' ) THEN
      IF( months_between(v_data_plecare, current_date) >= 1 ) THEN
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager,v_bilet, nr_card, nr_cvv, data_exp, '0€'); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' are pretul biletului: ' || '0€');
      ELSE
        v_result := 0 + 10/100;
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager, v_bilet,nr_card, nr_cvv, data_exp, v_result); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' are pretul biletului mai scump decat inainte: ' || v_result || '€.');
      END IF;
      
    ELSE
      IF( months_between(v_data_plecare, current_date) >= 1 ) THEN
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager, v_bilet,nr_card, nr_cvv, data_exp, v_pret); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' nu beneficiaza de reducerea pretului biletului.');
      ELSE
        v_result := substr(v_pret,1,length(v_pret)-1) + 10/100;
        INSERT into detalii_plata VALUES (v_id_plata+1, v_id_pasager,v_bilet, nr_card, nr_cvv, data_exp, v_result); 
        DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_id_pasager || ' are pretul biletului mai scump decat inainte: ' || v_result || '€.');
      END IF;
    END IF;
    END IF;
end;
/

set serveroutput on;
BEGIN
  detaliiPlata(5467389203344098, 222, '12 mai 2020', 9502, 'Economica', 1970);
END;
/

-------------------------------adaugare pasager---------------------------------------------------
CREATE OR REPLACE PROCEDURE adaugaPasager(nume varchar2, prenume varchar2, nr_telefon varchar2, data_nastere date, emailA varchar2, adresa varchar2, nationalitate varchar2, tip varchar2, gen varchar2) AS
  v_id_pasager pasageri.id_pasager%type;
  v_result number;
  
  pasager_existent EXCEPTION;
  PRAGMA EXCEPTION_INIT(pasager_existent, -20002);
  
BEGIN
    SELECT max(id_pasager) INTO v_id_pasager FROM pasageri ;
    SELECT count(*) INTO v_result FROM pasageri WHERE email=emailA;
    
    IF (v_result = 0) THEN
      INSERT into pasageri VALUES (v_id_pasager+1, nume, prenume, nr_telefon, data_nastere, emailA, adresa, nationalitate, tip, gen);
    ELSE
      RAISE pasager_existent;
    END IF;
END;
/

set serveroutput on;
BEGIN
  adaugaPasager('Ionescu', 'Ion', '0798564432', '11 noiembrie 2018', '', 'str. Copou nr. 8, Iasi, Romania', 'Roman', 'copil', 'MASCULIN');
END;
/

--------------------------------creare bilet------------------------------------------------
CREATE OR REPLACE PROCEDURE creareBilet(id_pasag int, id_ruta int, nume_clasa_loc varchar2) AS
  v_loc locuri.numar_loc%type;
  v_result int;
  v_maxim int;
  
  numar_locuri_epuizate EXCEPTION;
  PRAGMA EXCEPTION_INIT(numar_locuri_epuizate, -20003);
  
BEGIN
  SELECT count(*) INTO v_result FROM locuri l join clasa c on c.id_clasa=l.id_clasa where c.id_zbor=id_ruta and c.nume_clasa=nume_clasa_loc;
  
  IF( v_result = 0 ) THEN
    RAISE numar_locuri_epuizate;
  ELSE
    SELECT locuri.numar_loc INTO v_loc FROM locuri
       join clasa on clasa.id_clasa=locuri.id_clasa
    where clasa.id_zbor=id_ruta and clasa.nume_clasa=nume_clasa_loc and rownum<2;
  END IF;
  
  SELECT max(id_bilet) INTO v_maxim FROM bilet;
  INSERT INTO bilet VALUES (v_maxim+1, id_ruta, id_pasag, nume_clasa_loc, v_loc);
  DELETE from locuri WHERE numar_loc=v_loc;
  UPDATE clasa set nr_locuri_disponibile=nr_locuri_disponibile-1 WHERE nume_clasa=nume_clasa_loc and id_zbor=id_ruta;
end;
/

set serveroutput on;
BEGIN
  creareBilet(4,1,'Intai');
END;
/
select * from bilet order by id_pasager;

--------------------------------anulare bilet-----------------------------------
CREATE OR REPLACE PROCEDURE anulareBilet(id_bilet_anulat int) AS
    v_result int;
    v_id_pasager pasageri.id_pasager%type;
    v_id_zbor bilet.id_zbor%type;
    v_id_clasa clasa.id_clasa%type;
    v_nr_loc bilet.numar_loc%type;
    
BEGIN
    SELECT b.id_pasager, b.id_zbor, c.id_clasa, b.numar_loc INTO v_id_pasager, v_id_zbor, v_id_clasa, v_nr_loc FROM bilet b
        join clasa c on c.id_zbor=b.id_zbor and b.tip_clasa=c.nume_clasa
    where b.id_bilet=id_bilet_anulat;
    
    SELECT count(*) INTO v_result FROM bilet WHERE id_pasager=v_id_pasager;
    IF(v_result!=0) THEN 
        INSERT into locuri values (v_id_clasa, v_nr_loc);
        DELETE from detalii_plata where id_bilet=id_bilet_anulat;
        DELETE from bilet where id_bilet=id_bilet_anulat;
        UPDATE clasa set nr_locuri_disponibile = nr_locuri_disponibile + 1 where id_clasa=v_id_clasa and id_zbor=v_id_zbor;
    ELSE 
        INSERT into locuri values (v_id_clasa, v_nr_loc);
        DELETE from detalii_plata where id_bilet=id_bilet_anulat;
        DELETE from bilet where id_bilet=id_bilet_anulat;
        DELETE from pasageri where id_pasager=v_id_pasager;
        UPDATE clasa set nr_locuri_disponibile = nr_locuri_disponibile + 1 where id_clasa=v_id_clasa and id_zbor=v_id_zbor;
    END IF;
END;
/
set serveroutput on;
BEGIN
  anulareBilet(2);
END;
/
select * from bilet order by id_bilet;
  CREATE OR REPLACE DIRECTORY MYDIR as 'E:\AEROPORT';

----------------------------emitere bilet--------------------------------
CREATE OR REPLACE PROCEDURE emitereBilet(id_pasag int, id_zboor int) AS
  v_fisier UTL_FILE.FILE_TYPE;
  v_nume_fisier VARCHAR2(100);
  v_nume pasageri.nume%type;
  v_prenume pasageri.prenume%type;
  v_nr_zbor rute.nr_zbor%type;
  v_sursa rute.sursa%type;
  v_destinatie rute.destinatie%type;
  v_poarta orar_rute.poarta%type;
  v_data_plecare orar_rute.data_plecare%type;
  v_ora_plecare orar_rute.ora_plecare%type;
  v_nume_clasa bilet.numar_loc%type;
  v_nume_aeroport_pornire aeroport.nume%type;
  v_nume_aeroport_sosire aeroport.nume%type;
BEGIN
  v_nume_fisier := 'bilet.txt';
  v_fisier := UTL_FILE.FOPEN('MYDIR', v_nume_fisier, 'W');
  SELECT p.nume, p.prenume, r.nr_zbor, r.sursa, r.destinatie, o.poarta, o.data_plecare, o.ora_plecare, b.tip_clasa INTO v_nume, v_prenume, v_nr_zbor, v_sursa, v_destinatie, v_poarta, v_data_plecare, v_ora_plecare, v_nume_clasa from pasageri p
    join bilet b on b.id_pasager = p.id_pasager
    join rute r on b.id_zbor = r.id_zbor
    join orar_rute o on r.id_zbor = o.id_zbor where p.id_pasager = id_pasag and r.id_zbor=id_zboor;
  SELECT nume INTO v_nume_aeroport_pornire from aeroport where oras=v_sursa and rownum<2;
  SELECT nume INTO v_nume_aeroport_sosire from aeroport where oras=v_destinatie and rownum<2;
  
  UTL_FILE.PUTF(v_fisier, 'BILET \n');
  UTL_FILE.PUTF(v_fisier, 'Nume pasager: ' || v_nume || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Prenume pasager: ' || v_prenume || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Numar zbor: ' || v_nr_zbor || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Sursa: ' || v_sursa || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Destinatie: ' || v_destinatie || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Data plecare: ' || v_data_plecare || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Ora plecare: ' || v_ora_plecare || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Clasa: ' || v_nume_clasa || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Poarta: ' || v_poarta || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Aeroport plecare: ' || v_nume_aeroport_pornire || '; \n');
  UTL_FILE.PUTF(v_fisier, 'Aeroport sosire: ' || v_nume_aeroport_sosire || '. \n');
  UTL_FILE.FCLOSE(v_fisier);
END;
/
--show error;

set serveroutput on;
BEGIN
    emitereBilet(1, 1);
end;
SELECT * from bilet;

--------------------------afisare bilet in interfata-----------------------------
CREATE OR REPLACE TYPE ticketsArray AS varray(1000) of varchar2(30);
/
CREATE OR REPLACE function vizualizareBilete(id_pasag int) 
return ticketsArray as
  bilete_gasite ticketsArray := ticketsArray();
  CURSOR lista_bilete IS SELECT r.nr_zbor, r.sursa, r.destinatie, b.tip_clasa, b.numar_loc, b.id_pasager FROM rute r join bilet b on r.id_zbor = b.id_zbor where b.id_pasager = id_pasag;
  v_std_linie lista_bilete%ROWTYPE;
begin
  for v_std_linie in lista_bilete loop
--    DBMS_OUTPUT.PUT_LINE('Pasagerul cu id-ul ' || v_std_linie.id_pasager || ' are bilet pentru zborul: ' || v_std_linie.nr_zbor || ', de la ' || v_std_linie.sursa || ', spre ' || v_std_linie.destinatie || ', la clasa ' || v_std_linie.tip_clasa || ' si locul ' || v_std_linie.numar_loc || '.');
      bilete_gasite.extend(6);
      bilete_gasite(bilete_gasite.count) := v_std_linie.id_pasager;
      bilete_gasite(bilete_gasite.count) := v_std_linie.nr_zbor;
      bilete_gasite(bilete_gasite.count) := v_std_linie.sursa;
      bilete_gasite(bilete_gasite.count) := v_std_linie.destinatie;
      bilete_gasite(bilete_gasite.count) := v_std_linie.tip_clasa;
      bilete_gasite(bilete_gasite.count) := v_std_linie.numar_loc;
  end loop;
  return bilete_gasite;
end;
/
show error;
set serveroutput on;
    v_rez ticketsArray;
BEGIN
    v_rez:=vizualizareBilete(3);
    for v_i in v_rez.first..v_rez.last loop
        DBMS_OUTPUT.PUT_LINE(v_rez(v_i));
    end loop;
END;
/
------------------------------GENERARE RUTA-------------------------------------------------
--CREATE OR REPLACE PROCEDURE generareRuta(sursa_zbor varchar2, destinatie_zbor varchar2, data_plecare_zbor date, tip_clasa varchar2) AS
--    CURSOR lista_rute IS SELECT * FROM rute r join orar_rute o on r.id_zbor=o.id_zbor join clasa c on c.id_zbor=r.id_zbor and c.nume_clasa=tip_clasa;
--    Cursor lista_escale IS SELECT * FROM rute r join orar_rute o on r.id_zbor=o.id_zbor join clasa c on c.id_zbor=r.id_zbor and c.nume_clasa=tip_clasa;
--    v_result int;    
--    
--    no_result EXCEPTION;
--    PRAGMA EXCEPTION_INIT(user_existent, -20007);
--    no_places EXCEPTION;
--    PRAGMA EXCEPTION_INIT(user_existent, -20008);
--    no_flights EXCEPTION;
--    PRAGMA EXCEPTION_INIT(user_existent, -20009);
--begin
--    v_result:=0;
--    FOR v_std_linie IN lista_rute LOOP    
--        if (v_std_linie.sursa=sursa_zbor) then 
--            if(v_std_linie.destinatie=destinatie_zbor) then
--                if(v_std_linie.data_plecare=data_plecare_zbor) then
--                    if(v_std_linie.nr_locuri_disponibile>0) then
--                        DBMS_OUTPUT.PUT_LINE('Zborul este: ' || v_std_linie.nr_zbor || ' de la ' || sursa_zbor || ' spre ' || destinatie_zbor || ' in data de ' || data_plecare_zbor || ' ora ' || v_std_linie.ora_plecare);
--                        v_result:=1;
--                    else
--                        v_result:=2;
--                    end if;
--                else 
--                    v_result:=3;
--                end if;
--            else
--                for v_linie in lista_escale loop
--                    if(v_linie.sursa=v_std_linie.destinatie and v_linie.destinatie=destinatie_zbor and v_linie.data_plecare=data_plecare_zbor and v_linie.nr_locuri_disponibile>0) then
--                        if((v_linie.data_plecare=v_std_linie.data_sosire or v_linie.data_plecare=v_std_linie.data_sosire+1) and v_std_linie.ora_sosire < v_linie.ora_plecare) then
--                            DBMS_OUTPUT.PUT_LINE('Zborul este: ' || v_std_linie.nr_zbor || ' de la ' || sursa_zbor || ' spre ' || destinatie_zbor || ' in data de ' || data_plecare_zbor || ' ora ' || v_std_linie.ora_plecare || ' cu escala la ' || v_linie.sursa || ' plecarea de aici facandu-se cu zborul ' || v_linie.nr_zbor);                                               
--                            v_result:=1;
--                        end if;
--                    end if;
--                end loop;
--            end if;
--        end if;
--    END LOOP;  
--    
--    if(v_result=0) then
--        raise no_result;
--    elsif(v_result=2) then 
--         raise no_places;
--    elsif(v_result=3)then
--        raise no_flights;
--    end if;
--end;
--/

create or replace type varchar_list AS varray(1000) of varchar2(50);
/

CREATE OR REPLACE FUNCTION returnRuta(sursa_zbor varchar2, destinatie_zbor varchar2, data_plecare_zbor date, tip_clasa varchar2) return varchar_list IS
    CURSOR lista_rute IS SELECT * FROM rute r join orar_rute o on r.id_zbor=o.id_zbor join clasa c on c.id_zbor=r.id_zbor and c.nume_clasa=tip_clasa;
    Cursor lista_escale IS SELECT * FROM rute r join orar_rute o on r.id_zbor=o.id_zbor join clasa c on c.id_zbor=r.id_zbor and c.nume_clasa=tip_clasa;
    v_result int;    
    
    no_result EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_result, -20007);
    no_places EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_places, -20008);
    no_flights EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_flights, -20009);
begin
    v_result:=0;
    FOR v_std_linie IN lista_rute LOOP    
        if (v_std_linie.sursa=sursa_zbor) then 
            if(v_std_linie.destinatie=destinatie_zbor) then
                if(v_std_linie.data_plecare=data_plecare_zbor) then
                    if(v_std_linie.nr_locuri_disponibile>0) then
                        return varchar_list(v_std_linie.nr_zbor, sursa_zbor, destinatie_zbor, data_plecare_zbor, v_std_linie.ora_plecare);
                        v_result:=1;
                    else
                        v_result:=2;
                    end if;
                else 
                    v_result:=3;
                end if;
            else
                for v_linie in lista_escale loop
                    if(v_linie.sursa=v_std_linie.destinatie and v_linie.destinatie=destinatie_zbor and v_linie.data_plecare=data_plecare_zbor and v_linie.nr_locuri_disponibile>0) then
                        if((v_linie.data_plecare=v_std_linie.data_sosire or v_linie.data_plecare=v_std_linie.data_sosire+1) and v_std_linie.ora_sosire < v_linie.ora_plecare) then
                            return varchar_list( v_std_linie.nr_zbor, sursa_zbor, destinatie_zbor, data_plecare_zbor, v_std_linie.ora_plecare, v_linie.sursa, v_linie.nr_zbor);                                               
                            v_result:=1;
                        end if;
                    end if;
                end loop;
            end if;
        end if;
    END LOOP;  
    
    if(v_result=0) then
        raise no_result;
    elsif(v_result=2) then 
         raise no_places;
    elsif(v_result=3)then
        raise no_flights;
    end if;
end;
/

set serveroutput on;
declare
    list_v varchar_list;
begin
    list_v:=returnRuta('Iasi','Kabul','06-06-2019','Economica');
    DBMS_OUTPUT.PUT_LINE(list_v(1)||' '||list_v(2)||' '||list_v(3)||' '||list_v(4)||' '||list_v(5));
end;
/

select * from pasageri order by id_pasager desc;
