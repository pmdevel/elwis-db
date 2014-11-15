 drop user wiso cascade;
 drop user wisu cascade;
 drop user wisro cascade;

 drop tablespace DATAS01 including contents and datafiles;
 drop tablespace DATAL01 including contents and datafiles;
 drop tablespace DATAL02  including contents and datafiles;
 drop tablespace LOB01 including contents and datafiles;
 drop tablespace WISO_TEMP including contents and datafiles;

 drop tablespace INDEXL01 including contents and datafiles;
 drop tablespace INDEXS01 including contents and datafiles;

-- Tablespaces
-- STATIC
create tablespace DATAS01
       datafile 'DATAS01.dat'
       size 5M autoextend on;

-- DYNAMIC
create tablespace DATAL01
       datafile 'DATAL01.dat'
       size 50M autoextend on;

create tablespace DATAL02
       datafile 'DATAL02.dat'
       size 10M autoextend on;

create tablespace LOB01
       datafile 'LOB01.dat'
       size 10M autoextend on;

create tablespace INDEXL01
       datafile 'INDEXLO1.dat'
       size 5M autoextend on;

create tablespace INDEXS01
       datafile 'INDEXSO1.dat'
       size 5M autoextend on;

create temporary tablespace WISO_TEMP
       tempfile 'WISO_TEMP.dat'
       size 5M autoextend on;

-- Users
create user wiso identified by wiso
       default tablespace DATAS01
       quota unlimited ON DATAL01
       quota unlimited ON DATAL02
       quota unlimited ON LOB01
       quota unlimited ON INDEXL01
       quota unlimited ON INDEXS01
       temporary tablespace WISO_TEMP;

grant all privileges to wiso;
grant unlimited tablespace to wiso;

create user wisu identified by wisu
       default tablespace DATAS01
       quota unlimited ON DATAL01
       quota unlimited ON DATAL02
       quota unlimited ON LOB01
       quota unlimited ON INDEXL01
       temporary tablespace WISO_TEMP;

grant create session to wisu;
grant all privileges to wisu;
grant unlimited tablespace to wisu;

create user wisro identified by wisro;

grant create session to wisro;
grant select any table to wisro;



