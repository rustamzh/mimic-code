-- -------------------------------------------------------------------------------
--
-- Create the MIMIC-III tables
--
-- -------------------------------------------------------------------------------

--------------------------------------------------------
--  File created - Thursday-November-28-2015
--------------------------------------------------------

-- Define the schema where all tables are created
CREATE SCHEMA IF NOT EXISTS mimiciii;
SET search_path TO mimiciii;

-- Restoring the search path to its default value can be accomplished as follows:
--  SET search_path TO "$user",public;

/* Set the mimic_data_dir variable to point to directory containing
   all .csv files. If using Docker, this should not be changed here.
   Rather, when running the docker container, use the -v option
   to have Docker mount a host volume to the container path /mimic_data
   as explained in the README file
*/


--------------------------------------------------------
--  DDL for Table ADMISSIONS
--------------------------------------------------------

DROP TABLE IF EXISTS ADMISSIONS;
CREATE TABLE ADMISSIONS
(
  ROW_ID INT NOT NULL,
  SUBJECT_ID INT NOT NULL,
  HADM_ID INT NOT NULL,
  ADMITTIME TIMESTAMP(0) NOT NULL,
  DISCHTIME TIMESTAMP(0) NOT NULL,
  DEATHTIME TIMESTAMP(0),
  ADMISSION_TYPE VARCHAR(50) NOT NULL,
  ADMISSION_LOCATION VARCHAR(50) NOT NULL,
  DISCHARGE_LOCATION VARCHAR(50) NOT NULL,
  INSURANCE VARCHAR(255) NOT NULL,
  LANGUAGE VARCHAR(10),
  RELIGION VARCHAR(50),
  MARITAL_STATUS VARCHAR(50),
  ETHNICITY VARCHAR(200) NOT NULL,
  EDREGTIME TIMESTAMP(0),
  EDOUTTIME TIMESTAMP(0),
  DIAGNOSIS VARCHAR(255),
  HOSPITAL_EXPIRE_FLAG SMALLINT,
  HAS_IOEVENTS_DATA SMALLINT NOT NULL,
  HAS_CHARTEVENTS_DATA SMALLINT NOT NULL,
  CONSTRAINT adm_rowid_pk PRIMARY KEY (ROW_ID),
  CONSTRAINT adm_hadm_unique UNIQUE (HADM_ID)
) ;

--------------------------------------------------------
--  DDL for Table CALLOUT
--------------------------------------------------------

DROP TABLE IF EXISTS CALLOUT;
CREATE TABLE CALLOUT
    (   ROW_ID INT NOT NULL,
        SUBJECT_ID INT NOT NULL,
        HADM_ID INT NOT NULL,
        SUBMIT_WARDID INT,
        SUBMIT_CAREUNIT VARCHAR(15),
        CURR_WARDID INT,
        CURR_CAREUNIT VARCHAR(15),
        CALLOUT_WARDID INT,
        CALLOUT_SERVICE VARCHAR(10) NOT NULL,
        REQUEST_TELE SMALLINT NOT NULL,
        REQUEST_RESP SMALLINT NOT NULL,
        REQUEST_CDIFF SMALLINT NOT NULL,
        REQUEST_MRSA SMALLINT NOT NULL,
        REQUEST_VRE SMALLINT NOT NULL,
        CALLOUT_STATUS VARCHAR(20) NOT NULL,
        CALLOUT_OUTCOME VARCHAR(20) NOT NULL,
        DISCHARGE_WARDID INT,
        ACKNOWLEDGE_STATUS VARCHAR(20) NOT NULL,
        CREATETIME TIMESTAMP(0) NOT NULL,
        UPDATETIME TIMESTAMP(0) NOT NULL,
        ACKNOWLEDGETIME TIMESTAMP(0),
        OUTCOMETIME TIMESTAMP(0) NOT NULL,
        FIRSTRESERVATIONTIME TIMESTAMP(0),
        CURRENTRESERVATIONTIME TIMESTAMP(0),
        CONSTRAINT callout_rowid_pk PRIMARY KEY (ROW_ID)
        );

--------------------------------------------------------
--  DDL for Table CAREGIVERS
--------------------------------------------------------

DROP TABLE IF EXISTS CAREGIVERS;
CREATE TABLE CAREGIVERS
   (	ROW_ID INT NOT NULL,
	CGID INT NOT NULL,
	LABEL VARCHAR(15),
	DESCRIPTION VARCHAR(30),
	CONSTRAINT cg_rowid_pk  PRIMARY KEY (ROW_ID),
	CONSTRAINT cg_cgid_unique UNIQUE (CGID)
   ) ;

--------------------------------------------------------
--  DDL for Table CHARTEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS CHARTEVENTS;
CREATE TABLE CHARTEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ICUSTAY_ID INT,
	ITEMID INT,
	CHARTTIME TIMESTAMP(0),
	STORETIME TIMESTAMP(0),
	CGID INT,
	VALUE VARCHAR(255),
	VALUENUM DOUBLE PRECISION,
	VALUEUOM VARCHAR(50),
	WARNING INT,
	ERROR INT,
	RESULTSTATUS VARCHAR(50),
	STOPPED VARCHAR(50),
	CONSTRAINT chartevents_rowid_pk PRIMARY KEY (ROW_ID)
  );


--------------------------------------------------------
--  PARTITION for Table CHARTEVENTS
--------------------------------------------------------

-- CREATE CHARTEVENTS TABLE
CREATE TABLE chartevents_1 ( CHECK ( itemid >= 1  AND itemid < 210 )) INHERITS (chartevents);
CREATE TABLE chartevents_2 ( CHECK ( itemid >= 210  AND itemid < 250 )) INHERITS (chartevents);
CREATE TABLE chartevents_3 ( CHECK ( itemid >= 250  AND itemid < 614 )) INHERITS (chartevents);
CREATE TABLE chartevents_4 ( CHECK ( itemid >= 614  AND itemid < 640 )) INHERITS (chartevents);
CREATE TABLE chartevents_5 ( CHECK ( itemid >= 640  AND itemid < 742 )) INHERITS (chartevents);
CREATE TABLE chartevents_6 ( CHECK ( itemid >= 742  AND itemid < 1800 )) INHERITS (chartevents);
CREATE TABLE chartevents_7 ( CHECK ( itemid >= 1800  AND itemid < 2700 )) INHERITS (chartevents);
CREATE TABLE chartevents_8 ( CHECK ( itemid >= 2700  AND itemid < 3700 )) INHERITS (chartevents);
CREATE TABLE chartevents_9 ( CHECK ( itemid >= 3700  AND itemid < 4700 )) INHERITS (chartevents);
CREATE TABLE chartevents_10 ( CHECK ( itemid >= 4700  AND itemid < 6000 )) INHERITS (chartevents);
CREATE TABLE chartevents_11 ( CHECK ( itemid >= 6000  AND itemid < 7000 )) INHERITS (chartevents);
CREATE TABLE chartevents_12 ( CHECK ( itemid >= 7000  AND itemid < 8000 )) INHERITS (chartevents);
CREATE TABLE chartevents_13 ( CHECK ( itemid >= 8000  AND itemid < 220074 )) INHERITS (chartevents);
CREATE TABLE chartevents_14 ( CHECK ( itemid >= 220074  AND itemid < 323769 )) INHERITS (chartevents);
	
-- CREATE CHARTEVENTS TRIGGER
CREATE OR REPLACE FUNCTION chartevents_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN


IF ( NEW.itemid >= 1 AND NEW.itemid < 210 ) THEN INSERT INTO chartevents_1 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 210 AND NEW.itemid < 250 ) THEN INSERT INTO chartevents_2 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 250 AND NEW.itemid < 614 ) THEN INSERT INTO chartevents_3 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 614 AND NEW.itemid < 640 ) THEN INSERT INTO chartevents_4 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 640 AND NEW.itemid < 742 ) THEN INSERT INTO chartevents_5 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 742 AND NEW.itemid < 1800 ) THEN INSERT INTO chartevents_6 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 1800 AND NEW.itemid < 2700 ) THEN INSERT INTO chartevents_7 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 2700 AND NEW.itemid < 3700 ) THEN INSERT INTO chartevents_8 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 3700 AND NEW.itemid < 4700 ) THEN INSERT INTO chartevents_9 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 4700 AND NEW.itemid < 6000 ) THEN INSERT INTO chartevents_10 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 6000 AND NEW.itemid < 7000 ) THEN INSERT INTO chartevents_11 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 7000 AND NEW.itemid < 8000 ) THEN INSERT INTO chartevents_12 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 8000 AND NEW.itemid < 220074 ) THEN INSERT INTO chartevents_13 VALUES (NEW.*);
ELSIF ( NEW.itemid >= 220074 AND NEW.itemid < 323769 ) THEN INSERT INTO chartevents_14 VALUES (NEW.*);
	ELSE
		INSERT INTO chartevents_null VALUES (NEW.*);
       END IF;
RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insert_chartevents_trigger
    BEFORE INSERT ON chartevents
    FOR EACH ROW EXECUTE PROCEDURE chartevents_insert_trigger();

CREATE INDEX chartevents_1_idx01 ON chartevents_1 (itemid);
CREATE INDEX chartevents_2_idx01 ON chartevents_2 (itemid);
CREATE INDEX chartevents_3_idx01 ON chartevents_3 (itemid);
CREATE INDEX chartevents_4_idx01 ON chartevents_4 (itemid);
CREATE INDEX chartevents_5_idx01 ON chartevents_5 (itemid);
CREATE INDEX chartevents_6_idx01 ON chartevents_6 (itemid);
CREATE INDEX chartevents_7_idx01 ON chartevents_7 (itemid);
CREATE INDEX chartevents_8_idx01 ON chartevents_8 (itemid);
CREATE INDEX chartevents_9_idx01 ON chartevents_9 (itemid);
CREATE INDEX chartevents_10_idx01 ON chartevents_10 (itemid);
CREATE INDEX chartevents_11_idx01 ON chartevents_11 (itemid);
CREATE INDEX chartevents_12_idx01 ON chartevents_12 (itemid);
CREATE INDEX chartevents_13_idx01 ON chartevents_13 (itemid);
CREATE INDEX chartevents_14_idx01 ON chartevents_14 (itemid);

--------------------------------------------------------
--  DDL for Table CPTEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS CPTEVENTS;
CREATE TABLE CPTEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	COSTCENTER VARCHAR(10) NOT NULL,
	CHARTDATE TIMESTAMP(0),
	CPT_CD VARCHAR(10) NOT NULL,
	CPT_NUMBER INT,
	CPT_SUFFIX VARCHAR(5),
	TICKET_ID_SEQ INT,
	SECTIONHEADER VARCHAR(50),
	SUBSECTIONHEADER VARCHAR(255),
	DESCRIPTION VARCHAR(200),
	CONSTRAINT cpt_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table DATETIMEEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS DATETIMEEVENTS;
CREATE TABLE DATETIMEEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ICUSTAY_ID INT,
	ITEMID INT NOT NULL,
	CHARTTIME TIMESTAMP(0) NOT NULL,
	STORETIME TIMESTAMP(0) NOT NULL,
	CGID INT NOT NULL,
	VALUE TIMESTAMP(0),
	VALUEUOM VARCHAR(50) NOT NULL,
	WARNING SMALLINT,
	ERROR SMALLINT,
	RESULTSTATUS VARCHAR(50),
	STOPPED VARCHAR(50),
	CONSTRAINT datetime_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table DIAGNOSES_ICD
--------------------------------------------------------

DROP TABLE IF EXISTS DIAGNOSES_ICD;
CREATE TABLE DIAGNOSES_ICD
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	SEQ_NUM INT,
	ICD9_CODE VARCHAR(20),
	CONSTRAINT diagnosesicd_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table DRGCODES
--------------------------------------------------------

DROP TABLE IF EXISTS DRGCODES;
CREATE TABLE DRGCODES
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	DRG_TYPE VARCHAR(20) NOT NULL,
	DRG_CODE VARCHAR(20) NOT NULL,
	DESCRIPTION VARCHAR(255),
	DRG_SEVERITY SMALLINT,
	DRG_MORTALITY SMALLINT,
	CONSTRAINT drg_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table D_CPT
--------------------------------------------------------

DROP TABLE IF EXISTS D_CPT;
CREATE TABLE D_CPT
   (	ROW_ID INT NOT NULL,
	CATEGORY SMALLINT NOT NULL,
	SECTIONRANGE VARCHAR(100) NOT NULL,
	SECTIONHEADER VARCHAR(50) NOT NULL,
	SUBSECTIONRANGE VARCHAR(100) NOT NULL,
	SUBSECTIONHEADER VARCHAR(255) NOT NULL,
	CODESUFFIX VARCHAR(5),
	MINCODEINSUBSECTION INT NOT NULL,
	MAXCODEINSUBSECTION INT NOT NULL,
    	CONSTRAINT dcpt_ssrange_unique UNIQUE (SUBSECTIONRANGE),
    	CONSTRAINT dcpt_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table D_ICD_DIAGNOSES
--------------------------------------------------------

DROP TABLE IF EXISTS D_ICD_DIAGNOSES;
CREATE TABLE D_ICD_DIAGNOSES
   (	ROW_ID INT NOT NULL,
	ICD9_CODE VARCHAR(10) NOT NULL,
	SHORT_TITLE VARCHAR(50) NOT NULL,
	LONG_TITLE VARCHAR(255) NOT NULL,
    	CONSTRAINT d_icd_diag_code_unique UNIQUE (ICD9_CODE),
    	CONSTRAINT d_icd_diag_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table D_ICD_PROCEDURES
--------------------------------------------------------

DROP TABLE IF EXISTS D_ICD_PROCEDURES;
CREATE TABLE D_ICD_PROCEDURES
   (	ROW_ID INT NOT NULL,
	ICD9_CODE VARCHAR(10) NOT NULL,
	SHORT_TITLE VARCHAR(50) NOT NULL,
	LONG_TITLE VARCHAR(255) NOT NULL,
    	CONSTRAINT d_icd_proc_code_unique UNIQUE (ICD9_CODE),
    	CONSTRAINT d_icd_proc_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table D_ITEMS
--------------------------------------------------------

DROP TABLE IF EXISTS D_ITEMS;
CREATE TABLE D_ITEMS
   (	ROW_ID INT NOT NULL,
    	ITEMID INT NOT NULL,
    	LABEL VARCHAR(200),
    	ABBREVIATION VARCHAR(100),
    	DBSOURCE VARCHAR(20),
    	LINKSTO VARCHAR(50),
    	CATEGORY VARCHAR(100),
    	UNITNAME VARCHAR(100),
    	PARAM_TYPE VARCHAR(30),
    	CONCEPTID INT,
    	CONSTRAINT ditems_itemid_unique UNIQUE (ITEMID),
    	CONSTRAINT ditems_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table D_LABITEMS
--------------------------------------------------------

DROP TABLE IF EXISTS D_LABITEMS;
CREATE TABLE D_LABITEMS
   (	ROW_ID INT NOT NULL,
	ITEMID INT NOT NULL,
	LABEL VARCHAR(100) NOT NULL,
	FLUID VARCHAR(100) NOT NULL,
	CATEGORY VARCHAR(100) NOT NULL,
	LOINC_CODE VARCHAR(100),
    	CONSTRAINT dlabitems_itemid_unique UNIQUE (ITEMID),
    	CONSTRAINT dlabitems_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table ICUSTAYS
--------------------------------------------------------

DROP TABLE IF EXISTS ICUSTAYS;
CREATE TABLE ICUSTAYS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	ICUSTAY_ID INT NOT NULL,
	DBSOURCE VARCHAR(20) NOT NULL,
	FIRST_CAREUNIT VARCHAR(20) NOT NULL,
	LAST_CAREUNIT VARCHAR(20) NOT NULL,
	FIRST_WARDID SMALLINT NOT NULL,
	LAST_WARDID SMALLINT NOT NULL,
	INTIME TIMESTAMP(0) NOT NULL,
	OUTTIME TIMESTAMP(0),
	LOS DOUBLE PRECISION,
    	CONSTRAINT icustay_icustayid_unique UNIQUE (ICUSTAY_ID),
    	CONSTRAINT icustay_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table INPUTEVENTS_CV
--------------------------------------------------------

DROP TABLE IF EXISTS INPUTEVENTS_CV;
CREATE TABLE INPUTEVENTS_CV
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ICUSTAY_ID INT,
	CHARTTIME TIMESTAMP(0),
	ITEMID INT,
	AMOUNT DOUBLE PRECISION,
	AMOUNTUOM VARCHAR(30),
	RATE DOUBLE PRECISION,
	RATEUOM VARCHAR(30),
	STORETIME TIMESTAMP(0),
	CGID INT,
	ORDERID INT,
	LINKORDERID INT,
	STOPPED VARCHAR(30),
	NEWBOTTLE INT,
	ORIGINALAMOUNT DOUBLE PRECISION,
	ORIGINALAMOUNTUOM VARCHAR(30),
	ORIGINALROUTE VARCHAR(30),
	ORIGINALRATE DOUBLE PRECISION,
	ORIGINALRATEUOM VARCHAR(30),
	ORIGINALSITE VARCHAR(30),
	CONSTRAINT inputevents_cv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table INPUTEVENTS_MV
--------------------------------------------------------

DROP TABLE IF EXISTS INPUTEVENTS_MV;
CREATE TABLE INPUTEVENTS_MV
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ICUSTAY_ID INT,
	STARTTIME TIMESTAMP(0),
	ENDTIME TIMESTAMP(0),
	ITEMID INT,
	AMOUNT DOUBLE PRECISION,
	AMOUNTUOM VARCHAR(30),
	RATE DOUBLE PRECISION,
	RATEUOM VARCHAR(30),
	STORETIME TIMESTAMP(0),
	CGID INT,
	ORDERID INT,
	LINKORDERID INT,
	ORDERCATEGORYNAME VARCHAR(100),
	SECONDARYORDERCATEGORYNAME VARCHAR(100),
	ORDERCOMPONENTTYPEDESCRIPTION VARCHAR(200),
	ORDERCATEGORYDESCRIPTION VARCHAR(50),
	PATIENTWEIGHT DOUBLE PRECISION,
	TOTALAMOUNT DOUBLE PRECISION,
	TOTALAMOUNTUOM VARCHAR(50),
	ISOPENBAG SMALLINT,
	CONTINUEINNEXTDEPT SMALLINT,
	CANCELREASON SMALLINT,
	STATUSDESCRIPTION VARCHAR(30),
	COMMENTS_EDITEDBY VARCHAR(30),
	COMMENTS_CANCELEDBY VARCHAR(40),
	COMMENTS_DATE TIMESTAMP(0),
	ORIGINALAMOUNT DOUBLE PRECISION,
	ORIGINALRATE DOUBLE PRECISION,
	CONSTRAINT inputevents_mv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table LABEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS LABEVENTS;
CREATE TABLE LABEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ITEMID INT NOT NULL,
	CHARTTIME TIMESTAMP(0),
	VALUE VARCHAR(200),
	VALUENUM DOUBLE PRECISION,
	VALUEUOM VARCHAR(20),
	FLAG VARCHAR(20),
	CONSTRAINT labevents_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table MICROBIOLOGYEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS MICROBIOLOGYEVENTS;
CREATE TABLE MICROBIOLOGYEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	CHARTDATE TIMESTAMP(0),
	CHARTTIME TIMESTAMP(0),
	SPEC_ITEMID INT,
	SPEC_TYPE_DESC VARCHAR(100),
	ORG_ITEMID INT,
	ORG_NAME VARCHAR(100),
	ISOLATE_NUM SMALLINT,
	AB_ITEMID INT,
	AB_NAME VARCHAR(30),
	DILUTION_TEXT VARCHAR(10),
	DILUTION_COMPARISON VARCHAR(20),
	DILUTION_VALUE DOUBLE PRECISION,
	INTERPRETATION VARCHAR(5),
	CONSTRAINT micro_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table NOTEEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS NOTEEVENTS;
CREATE TABLE NOTEEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	CHARTDATE TIMESTAMP(0),
	CHARTTIME TIMESTAMP(0),
	STORETIME TIMESTAMP(0),
	CATEGORY VARCHAR(50),
	DESCRIPTION VARCHAR(255),
	CGID INT,
	ISERROR CHAR(1),
	TEXT TEXT,
	CONSTRAINT noteevents_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table OUTPUTEVENTS
--------------------------------------------------------

DROP TABLE IF EXISTS OUTPUTEVENTS;
CREATE TABLE OUTPUTEVENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT,
	ICUSTAY_ID INT,
	CHARTTIME TIMESTAMP(0),
	ITEMID INT,
	VALUE DOUBLE PRECISION,
	VALUEUOM VARCHAR(30),
	STORETIME TIMESTAMP(0),
	CGID INT,
	STOPPED VARCHAR(30),
	NEWBOTTLE CHAR(1),
	ISERROR INT,
	CONSTRAINT outputevents_cv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table PATIENTS
--------------------------------------------------------

DROP TABLE IF EXISTS PATIENTS;
CREATE TABLE PATIENTS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	GENDER VARCHAR(5) NOT NULL,
	DOB TIMESTAMP(0) NOT NULL,
	DOD TIMESTAMP(0),
	DOD_HOSP TIMESTAMP(0),
	DOD_SSN TIMESTAMP(0),
	EXPIRE_FLAG INT NOT NULL,
    	CONSTRAINT pat_subid_unique UNIQUE (SUBJECT_ID),
    	CONSTRAINT pat_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table PRESCRIPTIONS
--------------------------------------------------------

DROP TABLE IF EXISTS PRESCRIPTIONS;
CREATE TABLE PRESCRIPTIONS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	ICUSTAY_ID INT,
	STARTDATE TIMESTAMP(0),
	ENDDATE TIMESTAMP(0),
	DRUG_TYPE VARCHAR(100) NOT NULL,
	DRUG VARCHAR(100) NOT NULL,
	DRUG_NAME_POE VARCHAR(100),
	DRUG_NAME_GENERIC VARCHAR(100),
	FORMULARY_DRUG_CD VARCHAR(120),
	GSN VARCHAR(200),
	NDC VARCHAR(120),
	PROD_STRENGTH VARCHAR(120),
	DOSE_VAL_RX VARCHAR(120),
	DOSE_UNIT_RX VARCHAR(120),
	FORM_VAL_DISP VARCHAR(120),
	FORM_UNIT_DISP VARCHAR(120),
	ROUTE VARCHAR(120),
	CONSTRAINT prescription_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table PROCEDUREEVENTS_MV
--------------------------------------------------------

DROP TABLE IF EXISTS PROCEDUREEVENTS_MV;
CREATE TABLE PROCEDUREEVENTS_MV
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	ICUSTAY_ID INT,
	STARTTIME TIMESTAMP(0),
	ENDTIME TIMESTAMP(0),
	ITEMID INT,
	VALUE DOUBLE PRECISION,
	VALUEUOM VARCHAR(30),
	LOCATION VARCHAR(30),
	LOCATIONCATEGORY VARCHAR(30),
	STORETIME TIMESTAMP(0),
	CGID INT,
	ORDERID INT,
	LINKORDERID INT,
	ORDERCATEGORYNAME VARCHAR(100),
	SECONDARYORDERCATEGORYNAME VARCHAR(100),
	ORDERCATEGORYDESCRIPTION VARCHAR(50),
	ISOPENBAG SMALLINT,
	CONTINUEINNEXTDEPT SMALLINT,
	CANCELREASON SMALLINT,
	STATUSDESCRIPTION VARCHAR(30),
	COMMENTS_EDITEDBY VARCHAR(30),
	COMMENTS_CANCELEDBY VARCHAR(30),
	COMMENTS_DATE TIMESTAMP(0),
	CONSTRAINT procedureevents_mv_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table PROCEDURES_ICD
--------------------------------------------------------

DROP TABLE IF EXISTS PROCEDURES_ICD;
CREATE TABLE PROCEDURES_ICD
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	SEQ_NUM INT NOT NULL,
	ICD9_CODE VARCHAR(20) NOT NULL,
	CONSTRAINT proceduresicd_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table SERVICES
--------------------------------------------------------

DROP TABLE IF EXISTS SERVICES;
CREATE TABLE SERVICES
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	TRANSFERTIME TIMESTAMP(0) NOT NULL,
	PREV_SERVICE VARCHAR(20),
	CURR_SERVICE VARCHAR(20),
	CONSTRAINT services_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

--------------------------------------------------------
--  DDL for Table TRANSFERS
--------------------------------------------------------

DROP TABLE IF EXISTS TRANSFERS;
CREATE TABLE TRANSFERS
   (	ROW_ID INT NOT NULL,
	SUBJECT_ID INT NOT NULL,
	HADM_ID INT NOT NULL,
	ICUSTAY_ID INT,
	DBSOURCE VARCHAR(20),
	EVENTTYPE VARCHAR(20),
	PREV_CAREUNIT VARCHAR(20),
	CURR_CAREUNIT VARCHAR(20),
	PREV_WARDID SMALLINT,
	CURR_WARDID SMALLINT,
	INTIME TIMESTAMP(0),
	OUTTIME TIMESTAMP(0),
	LOS DOUBLE PRECISION,
	CONSTRAINT transfers_rowid_pk PRIMARY KEY (ROW_ID)
   ) ;

