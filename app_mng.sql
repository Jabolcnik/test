
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Application"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Permission"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Environment"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Right"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Role"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_RolePermission"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_GroupRole"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/
CREATE SEQUENCE "SI_API_APPMNG"."SEQ_Group"
 INCREMENT BY 1
 NOMAXVALUE
 NOMINVALUE
 NOCACHE
/


CREATE TABLE "SI_API_APPMNG"."Role"(
  "Id" Number(10,0) NOT NULL,
  "ApplicationId" Number(10,0) NOT NULL,
  "RoleCode" NVarchar2(200) NOT NULL,
  "RoleName" NVarchar2(200) NOT NULL,
  "RoleDescription" NVarchar2(200),
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_Role_Id" ON "SI_API_APPMNG"."Role" ("Id")
TABLESPACE "TS_SI_API"
/

CREATE UNIQUE INDEX "SI_API_APPMNG"."UQ_Role_Application" ON "SI_API_APPMNG"."Role" ("Id","ApplicationId")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_Role_ApplicationId" ON "SI_API_APPMNG"."Role" ("ApplicationId")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Role" ADD CONSTRAINT "PK_Role" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Role_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Role"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Role_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Role"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Role".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Role_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Role"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Role_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Role"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Role" IS 'Role/Vloge'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."ApplicationId" IS 'FK Aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."RoleCode" IS 'Naziv-koda'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."RoleName" IS 'Dolgi naziv'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."RoleDescription" IS 'Opis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Role"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."Application"(
  "Id" Number(10,0) NOT NULL,
  "ApplicationCode" NVarchar2(20) NOT NULL,
  "ApplicationName" NVarchar2(200) NOT NULL,
  "ApplicationDescription" NVarchar2(1000),
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_Application_ApplicationCode" ON "SI_API_APPMNG"."Application" ("ApplicationCode","_IsDeletedKey")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Application" ADD CONSTRAINT "PK_Application" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Application_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Application"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Application_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Application"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Application".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Application_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Application"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Application_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Application"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Application" IS 'Aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."ApplicationCode" IS 'Šifra aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."ApplicationName" IS 'Naziv aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."ApplicationDescription" IS 'Opis aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Application"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."Permission"(
  "Id" Number(10,0) NOT NULL,
  "ApplicationId" Number(10,0) NOT NULL,
  "PermissionCode" NVarchar2(200) NOT NULL,
  "PermissionName" NVarchar2(500) NOT NULL,
  "PermissionDescription" NVarchar2(1000),
  "PermissionAreaCode" NVarchar2(200),
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_Permission_AppCode" ON "SI_API_APPMNG"."Permission" ("PermissionCode","_IsDeletedKey")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_Permission_ApplicationId" ON "SI_API_APPMNG"."Permission" ("ApplicationId")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Permission" ADD CONSTRAINT "PK_Permission" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Permission_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Permission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Permission_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Permission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Permission".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Permission_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Permission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Permission_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Permission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Permission" IS 'Seznam pravic'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."ApplicationId" IS 'Id aplikacije'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."PermissionCode" IS 'Šifra pravice'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."PermissionName" IS 'Naziv pravice'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."PermissionDescription" IS 'Opis pravice'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."PermissionAreaCode" IS 'Oznaka področja sklopa v katero spada pravica'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Permission"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."Environment"(
  "Id" Number(10,0) NOT NULL,
  "EnvironmentCode" NVarchar2(200) NOT NULL,
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_EnvironmentId" ON "SI_API_APPMNG"."Environment" ("Id")
TABLESPACE "TS_SI_API"
/

CREATE UNIQUE INDEX "UQ_EnvironmentCode" ON "SI_API_APPMNG"."Environment" ("EnvironmentCode","_IsDeletedKey")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Environment" ADD CONSTRAINT "PK_Environment" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Environment_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Environment"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Environment_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Environment"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Environment".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Environment_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Environment"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Environment_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Environment"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Environment" IS 'Agencije - vir CRS'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."EnvironmentCode" IS 'Koda '
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Environment"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."Group"(
  "Id" Number(10,0) NOT NULL,
  "GroupCode" NVarchar2(200) NOT NULL,
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_GroupId" ON "SI_API_APPMNG"."Group" ("Id")
TABLESPACE "TS_SI_API"
/

CREATE UNIQUE INDEX "UQ_GroupCode" ON "SI_API_APPMNG"."Group" ("GroupCode","_IsDeletedKey")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Group" ADD CONSTRAINT "PK_Group" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Group_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Group"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Group_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Group"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Group".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Group_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Group"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Group_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Group"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Group" IS 'Grupe '
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."GroupCode" IS 'Koda '
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Group"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."GroupRole"(
  "Id" Number(10,0) NOT NULL,
  "RoleId" Number(10,0) NOT NULL,
  "GroupId" Number(10,0) NOT NULL,
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_GroupRoleId" ON "SI_API_APPMNG"."GroupRole" ("Id")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_GroupRole_RoleId" ON "SI_API_APPMNG"."GroupRole" ("RoleId")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_GroupRole_GroupId" ON "SI_API_APPMNG"."GroupRole" ("GroupId")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."GroupRole" ADD CONSTRAINT "PK_GroupRole" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_GroupRole_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."GroupRole"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_GroupRole_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."GroupRole"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_GroupRole".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_GroupRole_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."GroupRole"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_GroupRole_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."GroupRole"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."GroupRole" IS 'Agencije - vir CRS'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."RoleId" IS 'FK - role'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."GroupId" IS 'FK - group'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."GroupRole"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."RolePermission"(
  "Id" Number(10,0) NOT NULL,
  "RoleId" Number(10,0) NOT NULL,
  "PermissionId" Number(10,0) NOT NULL,
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE INDEX "IFK_RolePermission_RoleId" ON "SI_API_APPMNG"."RolePermission" ("RoleId")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_RolePermission_PermissionId" ON "SI_API_APPMNG"."RolePermission" ("PermissionId")
TABLESPACE "TS_SI_API"
/

CREATE UNIQUE INDEX "UQ_RolePermission_Entry" ON "SI_API_APPMNG"."RolePermission" ("RoleId","PermissionId","_IsDeletedKey")
/

ALTER TABLE "SI_API_APPMNG"."RolePermission" ADD CONSTRAINT "PK_RolePermission" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_RolePermission_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."RolePermission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_RolePermission_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."RolePermission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_RolePermission".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_RolePermission_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."RolePermission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_RolePermission_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."RolePermission"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."RolePermission" IS 'Agencije - vir CRS'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."RoleId" IS 'FK - role'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."PermissionId" IS 'FK - permission'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."RolePermission"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/



CREATE TABLE "SI_API_APPMNG"."Right"(
  "Id" Number(10,0) NOT NULL,
  "RoleId" Number(10,0) NOT NULL,
  "EnvironmentId" Number(10,0) NOT NULL,
  "IsDeleted" Number(1,0) DEFAULT 0 NOT NULL
        CHECK ("IsDeleted" IN (0,1)),
  "CreatedBy" NVarchar2(100) NOT NULL,
  "CreatedOn" Timestamp(3) with time zone NOT NULL,
  "ModifiedBy" NVarchar2(100),
  "ModifiedOn" Timestamp(3) with time zone,
  "DeletedBy" NVarchar2(100),
  "DeletedOn" Timestamp(3) with time zone,
  "_IsDeletedKey" Number(10,0) INVISIBLE AS (CASE WHEN "IsDeleted" = 1 THEN "Id" ELSE 0 END) NOT NULL
)
TABLESPACE "TS_SI_API"
NO INMEMORY
/

CREATE UNIQUE INDEX "UQ_RightId" ON "SI_API_APPMNG"."Right" ("Id")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_Right_RoleId" ON "SI_API_APPMNG"."Right" ("RoleId")
TABLESPACE "TS_SI_API"
/

CREATE INDEX "IFK_Right_EnvironmentId" ON "SI_API_APPMNG"."Right" ("EnvironmentId")
TABLESPACE "TS_SI_API"
/

ALTER TABLE "SI_API_APPMNG"."Right" ADD CONSTRAINT "PK_Right" PRIMARY KEY ("Id")
   USING INDEX TABLESPACE "TS_SI_API"
/

CREATE TRIGGER "TRG_Right_CRE"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Right"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :NEW."CreatedOn" := NVL(:NEW."CreatedOn", CURRENT_TIMESTAMP);
  :NEW."CreatedBy" := NVL(:NEW."CreatedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
END; 
/

CREATE TRIGGER "TRG_Right_SEQ"
  BEFORE INSERT
  ON "SI_API_APPMNG"."Right"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  :new."Id" := CASE WHEN :new."Id" IS NULL OR :new."Id" = 0 THEN "SEQ_Right".nextval ELSE :new."Id" END;
END;

/

CREATE TRIGGER "TRG_Right_MOD"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Right"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
  --Modified on Logic
  IF (:OLD."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := NVL(:NEW."ModifiedOn", CURRENT_TIMESTAMP);
  ELSIF (:OLD."ModifiedOn" = :NEW."ModifiedOn" OR :NEW."ModifiedOn" IS NULL) THEN
    :NEW."ModifiedOn" := CURRENT_TIMESTAMP;
  ELSE 
    NULL;
  END IF;
  -- Modified By Logic
  IF (:OLD."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" := NVL(:NEW."ModifiedBy", NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER')));
  ELSIF  (:NEW."ModifiedBy" IS NULL) THEN
    :NEW."ModifiedBy" :=  NVL(SYS_CONTEXT('USERENV', 'PROXY_USER'), SYS_CONTEXT('USERENV', 'SESSION_USER'));
  END IF;
END;
/

CREATE TRIGGER "TRG_Right_DEL"
  BEFORE UPDATE
  ON "SI_API_APPMNG"."Right"
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN
    -- If set to Deleted
    IF (:OLD."IsDeleted" = 0 AND :NEW."IsDeleted" = 1) THEN
        IF (:NEW."DeletedOn" IS NULL) THEN
            :NEW."DeletedOn" := CURRENT_TIMESTAMP;
        END IF;  
        IF (:NEW."DeletedBy" IS NULL) THEN
            :NEW."DeletedBy" := NVL(SYS_CONTEXT('USERENV','PROXY_USER'),SYS_CONTEXT('USERENV','SESSION_USER'));
        END IF;
    END IF;
    -- If set to Un-Deleted
    IF (:OLD."IsDeleted" = 1 AND :NEW."IsDeleted" = 0) THEN
        :NEW."DeletedOn" := NULL;
        :NEW."DeletedBy" := NULL;
    END IF;
END;

/

COMMENT ON TABLE "SI_API_APPMNG"."Right" IS 'Agencije - vir CRS'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."Id" IS 'PK'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."RoleId" IS 'FK - roleId'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."EnvironmentId" IS 'FK - enviromentId'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."IsDeleted" IS 'Oznaka ali je zapis brisan (1,0)'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."CreatedBy" IS 'Uporabniško ime uporabnika, ki je kreiral zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."CreatedOn" IS 'Datum kreiranja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."ModifiedBy" IS 'Uporabniško ime uporabnika, ki je spremenil zapis'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."ModifiedOn" IS 'Datum spreminjanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."DeletedBy" IS 'Zapis brisan s strani uporabnika'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."DeletedOn" IS 'Datum brisanja zapisa'
/
COMMENT ON COLUMN "SI_API_APPMNG"."Right"."_IsDeletedKey" IS 'Key - Deleted Zapis Tabele'
/

ALTER TABLE "SI_API_APPMNG"."Role" ADD CONSTRAINT "FK_Role_ApplicationId" FOREIGN KEY ("ApplicationId") REFERENCES "SI_API_APPMNG"."Application" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."Permission" ADD CONSTRAINT "FK_Permission_ApplicationId" FOREIGN KEY ("ApplicationId") REFERENCES "SI_API_APPMNG"."Application" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."GroupRole" ADD CONSTRAINT "FK_GroupRole_RoleId" FOREIGN KEY ("RoleId") REFERENCES "SI_API_APPMNG"."Role" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."GroupRole" ADD CONSTRAINT "FK_GroupRole_GroupId" FOREIGN KEY ("GroupId") REFERENCES "SI_API_APPMNG"."Group" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."RolePermission" ADD CONSTRAINT "FK_RolePermission_RoleId" FOREIGN KEY ("RoleId") REFERENCES "SI_API_APPMNG"."Role" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."RolePermission" ADD CONSTRAINT "FK_RolePermission_PermissionId" FOREIGN KEY ("PermissionId") REFERENCES "SI_API_APPMNG"."Permission" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."Right" ADD CONSTRAINT "FK_Right_RoleId" FOREIGN KEY ("RoleId") REFERENCES "SI_API_APPMNG"."Role" ("Id")
/
ALTER TABLE "SI_API_APPMNG"."Right" ADD CONSTRAINT "FK_Right_EnviromentId" FOREIGN KEY ("EnvironmentId") REFERENCES "SI_API_APPMNG"."Environment" ("Id")
/
