DROP TABLE users_app CASCADE CONSTRAINTS
/
DROP TABLE rute CASCADE CONSTRAINTS
/
DROP TABLE orar_rute CASCADE CONSTRAINTS
/
DROP TABLE pasageri CASCADE CONSTRAINTS
/
DROP TABLE clasa CASCADE CONSTRAINTS
/
DROP TABLE bilet CASCADE CONSTRAINTS
/
DROP TABLE detalii_plata CASCADE CONSTRAINTS
/
DROP TABLE aeroport CASCADE CONSTRAINTS
/
DROP TABLE locuri CASCADE CONSTRAINTS
/

CREATE TABLE users_app (
    id_user INT NOT NULL PRIMARY KEY,
    email VARCHAR2(100) NOT NULL UNIQUE,
    parola VARCHAR2(15) NOT NULL,
    tip_user VARCHAR2(15) NOT NULL
)
/

CREATE TABLE pasageri (
    id_pasager INT NOT NULL PRIMARY KEY,
    nume VARCHAR2(20) NOT NULL,
    prenume	VARCHAR2(30) NOT NULL,
    nr_telefon VARCHAR2(20) NOT NULL,
    data_nastere DATE NOT NULL,
    email VARCHAR2(60),
    adresa VARCHAR2(100) NOT NULL,
    nationalitate VARCHAR2(30) NOT NULL,
    tip_pasager	VARCHAR2(10) NOT NULL,
    gen	VARCHAR2(10),
    CONSTRAINT GEN_CK CHECK (gen in ('FEMININ', 'MASCULIN'))
)
/

CREATE TABLE rute (
    id_zbor INT NOT NULL PRIMARY KEY,
    nr_zbor VARCHAR2(10) NOT NULL,
    sursa VARCHAR2(30) NOT NULL,
    destinatie VARCHAR2(30) NOT NULL,
    nume_companie VARCHAR2(50) NOT NULL
)
/

CREATE TABLE locuri (
    id_clasa INT NOT NULL,
    numar_loc VARCHAR2(5),
    CONSTRAINT CLASA_LOC_FK FOREIGN KEY (id_clasa) REFERENCES clasa(id_clasa)
)
/

CREATE TABLE clasa (
    id_clasa INT NOT NULL PRIMARY KEY,
    id_zbor INT NOT NULL,
    nume_clasa VARCHAR2(15) NOT NULL,
    nr_locuri_disponibile NUMBER NOT NULL,
    pret VARCHAR2(10) NOT NULL,
    CONSTRAINT ID_ZBOR_FK FOREIGN KEY (id_zbor) REFERENCES rute(id_zbor)
)
/

CREATE TABLE orar_rute (
    id_orar INT NOT NULL PRIMARY KEY,
    id_zbor INT NOT NULL,
    data_plecare DATE NOT NULL,
    data_sosire DATE NOT NULL,
    ora_plecare VARCHAR2(10) NOT NULL,
    ora_sosire VARCHAR2(10),
    poarta VARCHAR2(10),
    CONSTRAINT ORAR_ZBOR_FK FOREIGN KEY (id_zbor) REFERENCES rute(id_zbor)
)
/

CREATE TABLE bilet (
    id_bilet INT NOT NULL PRIMARY KEY,
    id_zbor INT NOT NULL,
    id_pasager INT NOT NULL,
    tip_clasa VARCHAR2(20) NOT NULL, 
    numar_loc VARCHAR2(10) NOT NULL,
    CONSTRAINT BILET_PASAGER_FK FOREIGN KEY (id_pasager) REFERENCES pasageri(id_pasager),
    CONSTRAINT BILET_ZBOR_FK FOREIGN KEY (id_zbor) REFERENCES rute(id_zbor)
)
/

CREATE TABLE detalii_plata (
    id_plata INT NOT NULL PRIMARY KEY,
    id_pasager INT NOT NULL,
    id_bilet INT NOT NULL,
    numar_card int NOT NULL,
    nr_cvv int NOT NULL,
    data_expirare DATE NOT NULL,
    pret VARCHAR2(10) NOT NULL,
    CONSTRAINT PASAGER_FK FOREIGN KEY (id_pasager) REFERENCES pasageri(id_pasager),
    CONSTRAINT BILET_FK FOREIGN KEY (id_bilet) REFERENCES bilet(id_bilet)
)
/

CREATE TABLE aeroport (
    id_aeroport INT NOT NULL PRIMARY KEY,
    nume VARCHAR2(200) NOT NULL,
    cod_iata VARCHAR2(5) NOT NULL,
    oras VARCHAR2(30) NOT NULL,
    tara VARCHAR2(30) NOT NULL
)
/

SET SERVEROUTPUT ON;
DECLARE
    TYPE varr IS VARRAY(2000) OF varchar2(255); 
    lista_orase varr:= varr('Tokyo','Seul','Mexico City','Mumbai','Delhi','New York','Jakarta','Sao Paulo','Manila','Los Angeles','Shanghai','Osaka',
        'Cairo','Kolkata','Karachi','Guangzhou','Buenos Aires','Moscova','Beijing','Dhaka','Istanbul','Rio de Janeiro','Teheran','Londra','Shenzhen','Lagos',
        'Paris','Chicago','Chongqing','Nagoya','Wuhan','Lima','Bangkok','Bogota','Kinshasa','Washington','Tianjin','Chennai','Dongguan',
        'Bangalore','Hyderabad','Johannesburg','San Francisco','Essen','Hong Kong','Taipei','Ho Chi Minh City','Bagdad','Dallas','Madrid','Philadelphia',
        'Santiago','Belo Horizonte','Toronto','Ahmedabad','Houston','Detroit','Boston','Atlanta','Khartoum','Chengdu','Miami','Kuala Lumpur','Shenyang',
        'Riyadh','Caracas','Yangon','X? ?n','Saint Petersburg','Singapore','Guadalajara','Chittagong','Sidney','Phoenix','Alger','Harbin','Abidjan','Berlin'
        ,'Porto Alegre','Barcelona','Milano','Nanjing','Monterrey','Shantou','Hangzhou','Casablanca','Seattle','Ankara','Melbourne','Recife','Brasilia','Alep',
        'Atena','Montréal','Phenian','Busan','Fortaleza','Cape Town','Salvador','Yokohama','Durban','Medellin','Bandung','Dalian','Curitiba','Accra',
        'Minneapolis','Luanda','Changchun','Ha Noi','Jinan','Qingdao','Nairobi','Jeddah','Ibadan','Addis Ababa','Fuzhou','Tel Aviv','Kunming','Santo Domingo',
        'Taiyuan','Napoli','Dar es Salaam','Zhengzhou','Sibiu','Kabul','Guiyang','Surabaya','San Diego','Damasc','Lisabona','Amman','Lucknow','Campinas',
        'St Louis','Izmir','Zibo','Tampa','Denver','Cleveland','Kaohsiung','Katowice','Onesti','Cali','Orlando','Taichung','Guatemala City','San Juan','Dakar',
        'Medan','Stuttgart','Mashhad','Daegu','Changsha','Incheon','Hamburg','Birmingham','Guayaquil','Sapporo','Suzhou','Colombo','Manchester',
        'Port-au-Prince','Chaoyang','Taskent','Patna','Pretoria','Fukuoka','Varsovia','Zhongshan','Shijiazhuang','Urumqi','Pittsburgh','Vancouver',
        'Frankfurt am Main','Nanchang','Lanzhou','Maracaibo','Sacramento','West Midlands','Tunis','Budapesta','Havana','Harare','Quanzhou','Anshan','Belém',
        'Giza','Portland','Wuxi','Quezon City','Baltimore','Dubai','Cincinnati','Nanhai','Leeds','Bucuresti','Asuncion','Ningbo','Douala','Goiânia',
        'Bhilai Nagar','Rotterdam','Nanning','Preston','Xiamen','San Antonio','Sanaa','Kansas City','Bonn','Viena','Esfahan','Zaozhuang','München','Wenzhou',
        'Tangshan','Valencia','Jilin','Hyderabad','Taoyuan','Linyi','Stockholm','Amsterdam','Indianapolis','Las Vegas','Puebla de Zaragoza','Hofu','Dammam',
        'Kampala','Minsk','Baotou','Baia Mare','Coimbatore','Maputo','Puning','Donetk','Bruxelles','Rabat','Manaus','Barranquilla','Hiroshima','Harkov',
        'Antananarivo','Bamako','Columbus','Sikasso','La Paz','Kuweit','Nanchong','Ludhiana','Lusaka','Santos','Vitória','Changzhou','Quito','Toluca',
        'Milwaukee','Yantai','Fuyang','Charlotte','Nijni Novgorod','Shunde','Montevideo','Satu Mare','Iasi','Xuzhou','Ségou','San Salvador','Virginia Beach',
        'Hefei','Tijuana','Austin','Salt Lake','Santa Cruz','Meerut','Conakry','Valencia','Asansol','Torino','Tianmen','Oradea','Belgrad','Providence','Suizhou',
        'Perth','Leon','Kitakyushu','Mannheim','Nanyang','Córdoba','Raleigh','Nakuru','Koulikoro','Bursa','Kumasi','Blaj','Nashville-Davidson','Liuan','Arad',
        'Bacau','Cluj-Napoca','Constanta','Suceava','Tulcea','Timisoara');
     
    lista_tari varr :=varr('Japonia','Coreea de Sud','Mexic','India','India','Statele Unite','Indonezia','Brazilia','Filipine','Statele Unite','China',
        'Japonia','Egipt','India','Pakistan','China','Argentina','Rusia','China','Bangladesh','Turcia','Brazilia','Iran','Regatul Unit al Marii Britanii',
        'China','Nigeria','Franþa','Statele Unite','China','Japonia','China','Peru','Thailanda','Columbia','Congo','Statele Unite','China','Africa de Sud','Statele Unite','Germania','China','China','Vietnam','Irak','Statele Unite','Spania','Statele Unite','Chile',
        'Brazilia','Canada','India','Statele Unite','Sudan','China','Statele Unite','Malaiezia','China','Arabia Saudita','Venezuel','Myanmar','China','Rusia','India','Singapore','Mexic','Egipt','Bangladesh','Australia','Statele Unite','Algeria',
        'China','Coasta de Fildes','Germania','Brazilia','Spania','Italia','China','Mexic','China','India','Maroc','Statele Unite','Turcia',
        'Australia','Brazilia','Brazilia','Siria','Grecia',' Canada',' Coreea de Nord','Coreea de Sud','Brazilia','Africa de Sud','Brazilia','Japonia',
        'Africa',' Columbia','Indonezia','China','Brazilia','Ghana','Statele Unite','Angola','China',' Vietnam','China',' Ucraina','China','Kenya','Italia',
        'Arabia Sauditã','Nigeria','Nigeria','Etiopia','Pakistan','China','Israel','China','Republica Dominicana','China','Italia','Tanzania','China',
        'Romania','Afghanistan','China','Indonezia','Statele Unite','Siria','Portugalia','Iordania','India','Brazilia','Statele Unite','Turcia','China',
        'Statele Unite','China','Polonia','Columbia','Statele Unite','China','Guatemala','Puerto Rico','Senegal',
        'Indonezia','Germania','Iran','Coreea de Sud','China','Coreea de Sud','Germania','Regatul Unit al Marii Britanii','Ecuador','Japonia','China',
        'Sri Lanka','Brazilia','Regatul Unit al Marii Britanii',' Haiti',' China','Uzbekistan','India','Africa de Sud','Japonia','Polonia','Filipine',
        'China','China','China','Statele Unite','Canada','Germania','China','China','Venezuela','Statele Unite','Regatul Unit al Marii Britanii','Tunisia',
        'Ungaria','Cuba','Zimbabwe','China','China','Brazilia','Egipt','Statele Unite','China','Filipine','Statele Unite','Emiratele Arabe Unite',
        'Statele Unite','China','Marea Britanie','România','Paraguay','China','Camerun','Brazilia','India','Olanda','China','Regatul Unit al Marii Britanii',
        'China','Statele Unite','Yemen','Statele Unite','Germania','Austria',' Iran','China','Germania','Pakistan','China','China','Venezuela','China',
        'Pakistan','China','China','Suedia','Olanda','Statele Unite','Mexic','Japonia','Azerbaidjan','Arabia Saudita','Uganda','Belarus',
        ' China','Mozambic','China','Ucraina','Belgia','Maroc','Brazilia','Columbia','Japonia','Ucraina','Madagascar','Pakistan','Mali',
        'Statele Unite','Mali','Bolivia',' Kuweit','China','India','Zambia','Brazilia','Brazilia','Indonezia','India','China','Ecuador','Mexic',
        'China','Statele Unite',' Rusia','China','Uruguay','Indonezia','India','Romania','Romania','Camerun','El Salvador',
        'Statele Unite','China',' Mexic','Statele Unite','Bolivia','India','India','Guineea','Spania','India','Nigeria','Italia','China',
        'India','India','Serbia','Statele Unite','China','Australia','Mexic','Japonia',' Germania','China',' Argentina','Statele Unite','Kenya','Mali',
        'Turcia','Ghana','India','China','Romania','Romania','Romania','Romania','Romania','Romania','Romania');   
        
    lista_companii varr:= varr('Aegean Airlines','Air Miles','Blue Star Airlines','Greece Airways','Olympic Airlines','Sky Express','Air Atlanta Icelandic',
        'Eagle Air','Iceland Express','Landsflug','Aer Lingus','Air Contractors','Ryanair','Starair','Air Dolomiti','Air Freedom','Air One','Air Vallée',
        'Alidaunia','Alitalia Express','Alpi Eagles','Blue Panorama Airlines','Cargoitalia','Eurofly','ItAli Airlines','Italy First','Meridiana','MyAir',
        'Ocean Airlines','Windjet','AirBaltic','LatCharter','Amber Air','Aviavilsa','Comlux','Lionair','Luxair','West Air Luxembourg','Air Vardar','MAT Macedonian Airlines',
        'BritishJET','Medavia','Air Atlantique','Astraeus','Aurigny Air','BAC Express Airlines','Blue Islands','BMI regional','British International Helicopters',
        'Castle Air','City Star Airlines','Coyne Airways','Eastern Airways','EuroManx','European Executive','Flightline','Fly Europa','FlyFirst','Flyglobespan',
        'Gama Aviation','GB Airways','Gregg Air','Highland Airways','Jet2.com','Loganair','Lydd Air','Monarch Airlines','Palmair','ScotAirways','Sky Value Ltd',
        'Thomsonfly','Titan AirwaysvVirgin Galactic','FlyOne','Moldavian Airlines','Tandem Aero','Tepavia Trans','Monaco','RivieraJet','Di Air','OKI Air International',
        'Air Norway','CHC Helikopter Service','Kato Airline','Norsk Luftambulanse','Vildanden','Arkefly Business Jet','Dynamic Airlines','KLM Exel','Metropolis',
        'PrivateAir','Schreiner Airways','Centralwings','Fischer Air Polska','Sky Express','Aerocondor','Hifly','PGA Express Portugália','SATA International',
        'Acvila Air','Blue Air','Carpatair','Ion ?iriac Air','Romavia','Tarom','Abakan Avia','Airlines 400','Astair Airlines','Atruvera Aviation','Avial NV',
        'BAL Bashkirian Airlines','Bugulma Air Enterprise','Chelyabinsk Airlines');
    
    CURSOR lista_email IS SELECT email FROM pasageri;
    CURSOR lista_clase IS SELECT id_clasa FROM CLASA;
    CURSOR lista_rute IS SELECT id_zbor from rute;
    CURSOR lista_zbor is select id_zbor from rute;
    CURSOR lista_bilete IS SELECT id_bilet, id_pasager, pret from bilet b join clasa c on b.id_zbor=c.id_zbor and b.tip_clasa=c.nume_clasa;
    v_id_plata int;
    v_card int;
    v_cvv int;
    v_data date;
    v_zbor varchar2(10);
    v_id_pasager int;
    v_clasa varchar2(15);
    v_loc varchar2(10);
    v_id_clasa int;
    v_id_bilet int;
    v_email varchar2(50);
    v_parola varchar2(50);
    v_result int;
    v_unic int;
    v_nr_loc varchar2(5);
    v_randuri int;
    v_zbor int;
    v_nume_clasa varchar2(15);
    v_capacitate int;
    v_pret int;
    v_result int;
    v_j int;
    v_oras varchar2(30);
    v_tara varchar2(30);
    v_nume_aeroport varchar2(100);
    v_iata varchar2(4);
    v_nr_zbor varchar2(10);
    v_sursa varchar2(30);
    v_destinatie varchar2(30);
    v_rand1 varchar2(30);
    v_rand2 varchar2(30);
    v_companie varchar2(70);
    v_id_orar int;
    v_ora_plecare varchar2(10);
    v_ora_sosire varchar2(10);
    v_data_plecare date;
    v_data_sosire date;
    v_poarta varchar2(5);
BEGIN 
-------------------------aeroport---------------------------------------
    for v_i in 1..lista_orase.count loop
        v_oras := trim(lista_orase(v_i));
        v_tara := trim(lista_tari(v_i));
        v_nume_aeroport:=v_oras||' International Airport';
        v_iata:=upper(substr(v_oras,1,2)||substr(v_tara,1,1));
        
        insert into aeroport values(v_i, v_nume_aeroport,v_iata, v_oras, v_tara);
    end loop; 
    
  ---------------------------rute------------------------------------------------  
    for v_i in 1..5000 loop
        v_rand1:=lista_orase(trunc(dbms_random.value(0,lista_orase.count))+1);
        v_rand2:=lista_orase(trunc(dbms_random.value(0,lista_orase.count))+1);
        
        if(v_rand1!=v_rand2) then
            v_sursa:=v_rand1;
            v_destinatie:=v_rand2;
            
            select tara into v_tara from aeroport where oras=v_sursa and rownum<2;
            v_nr_zbor:=upper(substr(v_tara,1,2))||round(dbms_random.value(500,5000));
            
            v_companie := lista_companii(trunc(dbms_random.value(0,lista_companii.count))+1);
            
            insert into rute values (v_i,v_nr_zbor,v_sursa,v_destinatie,v_companie);
        end if;
    end loop;
    
-------------------------------clasa------------------------------------------------------------------
     v_j:=1;
    for v_std_linie in lista_rute loop
        v_capacitate := round(dbms_random.value(150,400));
        if(round(dbms_random.value(1,3))=1) then
            v_pret := round(dbms_random.value(70,200));
            insert into clasa values (v_j,v_std_linie.id_zbor,'Economica',v_capacitate,v_pret||'€');
            v_j:=v_j+1;
            v_pret := round(dbms_random.value(100,400));
            insert into clasa values (v_j,v_std_linie.id_zbor,'Business',v_capacitate,v_pret||'€');
            v_j:=v_j+1;
            v_pret := round(dbms_random.value(300,700));
            insert into clasa values (v_j,v_std_linie.id_zbor,'Intai',v_capacitate,v_pret||'€');
            v_j:=v_j+1;
        elsif(round(dbms_random.value(1,3))=2) then
                v_pret := round(dbms_random.value(70,200));
                insert into clasa values (v_j,v_std_linie.id_zbor,'Economica',v_capacitate,v_pret||'€');
                v_j:=v_j+1;
                v_pret := round(dbms_random.value(100,400));
                insert into clasa values (v_j,v_std_linie.id_zbor,'Business',v_capacitate,v_pret||'€');
                v_j:=v_j+1;
            else 
                v_pret := round(dbms_random.value(70,200));
                insert into clasa values (v_j,v_std_linie.id_zbor,'Economica',v_capacitate,v_pret||'€');
                v_j:=v_j+1;
        end if;
    end loop;
    
---------------------------------------locuri---------------------------------------------------
    for v_std_linie in lista_clase loop
        if(round(dbms_random.value(1,3))=1) then
            select nr_locuri_disponibile/4 into v_randuri from clasa where clasa.id_clasa=v_std_linie.id_clasa;
            for v_i in 1..v_randuri loop
                insert into locuri values (v_std_linie.id_clasa, v_i||'A');
                insert into locuri values (v_std_linie.id_clasa, v_i||'B');
                insert into locuri values (v_std_linie.id_clasa, v_i||'C');
                insert into locuri values (v_std_linie.id_clasa, v_i||'D');
            end loop;
        elsif(round(dbms_random.value(1,3))=2) then
                select nr_locuri_disponibile/6 into v_randuri from clasa where clasa.id_clasa=v_std_linie.id_clasa;
                for v_i in 1..v_randuri loop
                    insert into locuri values (v_std_linie.id_clasa, v_i||'A');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'B');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'C');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'D');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'E');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'F');
                end loop;
            else 
                select nr_locuri_disponibile/8 into v_randuri from clasa where clasa.id_clasa=v_std_linie.id_clasa;
                for v_i in 1..v_randuri loop
                    insert into locuri values (v_std_linie.id_clasa, v_i||'A');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'B');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'C');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'D');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'E');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'F');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'G');
                    insert into locuri values (v_std_linie.id_clasa, v_i||'H');
                end loop;
        end if;
   end loop;
   
   -------------------------------users----------------------------------------
   for v_i in 1..10000 loop 
        select count(*), email into v_result,v_email from pasageri where id_pasager = v_i + round(dbms_random.value(10,400)) group by email;
        select count(*) into v_unic from users_app where v_email=email;
        if v_result!=0 and v_unic=0 then
            v_parola := substr(v_email,1,instr(v_email,'.',1)-1);
            insert into users_app values (v_i, v_email, v_parola);
        end if;
    end loop;
    
    -----------------------------bilet-------------------------------------
    v_id_bilet:=1;
    for v_std_linie in lista_zbor loop
        if(v_id_bilet=1000) then
            exit;
        end if;
        
        v_id_pasager := round(dbms_random.value(1,43000))+2*v_id_bilet;
        select nume_clasa, numar_loc, l.id_clasa into v_clasa, v_loc, v_id_clasa from clasa c join locuri l on l.id_clasa=c.id_clasa where c.id_zbor=v_std_linie.id_zbor and rownum<2;
        insert into bilet values (v_id_bilet, v_std_linie.id_zbor,v_id_pasager, v_clasa, v_loc);
        delete from locuri where id_clasa=v_id_clasa and numar_loc=v_loc;
        v_id_bilet:=v_id_bilet+1;
    end loop;
    
    -------------------------------detalii plata---------------------------
    v_id_plata:=1;
    for v_std_linie in lista_bilete loop
        v_card:=round(dbms_random.value(1000000000000000,9999999999999999));
        v_cvv:=round(dbms_random.value(100,999));
        v_data:=to_date('01-06-2019','dd-mm-yyyy')+trunc(dbms_random.value(1,1400));
        insert into detalii_plata values(v_id_plata,v_std_linie.id_pasager,v_std_linie.id_bilet, v_card, v_cvv, v_data, v_std_linie.pret);
        v_id_plata:=v_id_plata+1;
    end loop;
    
    ---------------------------------orar----------------------------------
     v_id_orar:=1;
    for v_std_linie in lista_zbor loop
        
        v_data_plecare:=to_date('29-05-2019','dd-mm-yyyy')+trunc(dbms_random.value(1,400));
        v_data_sosire:=v_data_plecare+round(dbms_random.value(0,4));
        if(round(dbms_random.value(1,2))=1) then
            v_ora_plecare:='0'||round(dbms_random.value(0,9))||':'||round(dbms_random.value(10,59));
            v_ora_sosire:=(substr(v_ora_plecare,1,2)+round(dbms_random.value(0,10)))||':'||(substr(v_ora_plecare,4,2)+round(dbms_random.value(0,30)));
        else
            v_ora_plecare:=round(dbms_random.value(10,23))||':'||round(dbms_random.value(10,59));
            if((24-substr(v_ora_plecare,1,2))<10 and (60-substr(v_ora_plecare,4,2))<10) then
               v_ora_sosire:='0'||(24-substr(v_ora_plecare,1,2))||':0'||(60-substr(v_ora_plecare,4,2));
            elsif((24-substr(v_ora_plecare,1,2))<10 and (60-substr(v_ora_plecare,4,2))>=10) then
                v_ora_sosire:='0'||(24-substr(v_ora_plecare,1,2))||':'||(60-substr(v_ora_plecare,4,2));
            elsif((24-substr(v_ora_plecare,1,2))>=10 and (60-substr(v_ora_plecare,4,2))<10) then
                v_ora_sosire:=(24-substr(v_ora_plecare,1,2))||':0'||(60-substr(v_ora_plecare,4,2));
            else
                v_ora_sosire:=(24-substr(v_ora_plecare,1,2))||':'||(60-substr(v_ora_plecare,4,2));
            end if;
        end if;
        
        v_poarta:=upper(dbms_random.string('A', 1))||round(dbms_random.value(1,20));
        
        insert into orar_rute values (v_id_orar, v_std_linie.id_zbor, v_data_plecare, v_data_sosire, v_ora_plecare, v_ora_sosire, v_poarta);
        v_id_orar:=v_id_orar+1;
    end loop;
END;
/

select * from users_app order by id_user desc;


------------------------index--------------------------------------------
--select * from pasageri where nume='Cozma' and prenume='Maria';
--select * from rute where sursa='Valencia';
--CREATE INDEX pasager_index ON pasageri(nume, prenume, email);
--/
--CREATE INDEX ruta_index ON rute(nr_zbor, sursa, destinatie);
--/
DROP INDEX pasager_index; 
DROP INDEX ruta_index;