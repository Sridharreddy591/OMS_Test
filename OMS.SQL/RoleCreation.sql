﻿IF NOT EXISTS(SELECT 1 FROM SYS.tables WHERE NAME ='LOGIN_ROLE')
BEGIN
	CREATE TABLE LOGIN_ROLE
	(
		LOGINROLEID INT IDENTITY(1,1),
		ROLENAME VARCHAR(400),		
	)
END
IF NOT EXISTS(SELECT 1 FROM SYS.tables WHERE NAME ='LOGIN_ROLE_USER')
BEGIN
	CREATE TABLE LOGIN_ROLE_USER
	(
		LOGINROLEUSERID INT IDENTITY(1,1),
		USERID INT,
		LOGINROLEID INT
	)
END
GO
IF EXISTS (SELECT 1 FROM SYS.procedures WHERE NAME ='USP_SAVE_LOGIN_ROLE')
DROP PROCEDURE USP_SAVE_LOGIN_ROLE
GO 
/*******************************************************************
**
**
**
********************************************************************/
CREATE PROCEDURE dbo.USP_SAVE_LOGIN_ROLE
(
	@LOGINROLEID INT,
	@ROLENAME VARCHAR(400)
)
AS
BEGIN
	IF ISNULL(@LOGINROLEID,0) = 0
	BEGIN
		INSERT INTO LOGIN_ROLE(ROLENAME)
		SELECT @ROLENAME
	END
	ELSE 
	BEGIN
		UPDATE LOGIN_ROLE SET ROLENAME = @ROLENAME WHERE LOGINROLEID= @LOGINROLEID
	END
END
GO
IF EXISTS (SELECT 1 FROM SYS.procedures WHERE NAME ='USP_SAVE_LOGIN_ROLE_USER')
DROP PROCEDURE USP_SAVE_LOGIN_ROLE_USER
GO 
/*******************************************************************
**
**
**
********************************************************************/
CREATE PROCEDURE dbo.USP_SAVE_LOGIN_ROLE_USER
(
	@LOGINROLEUSERID INT,
	@USERID INT,
	@LOGINROLEID INT
)
AS
BEGIN
	IF ISNULL(@LOGINROLEUSERID,0) = 0
	BEGIN
		INSERT INTO LOGIN_ROLE_USER(USERID,LOGINROLEID)
		SELECT @USERID,@LOGINROLEID
	END
	ELSE 
	BEGIN
		UPDATE LOGIN_ROLE_USER SET LOGINROLEID = @LOGINROLEID WHERE LOGINROLEUSERID= @LOGINROLEUSERID
	END
END
go
IF EXISTS (SELECT 1 FROM SYS.procedures WHERE NAME ='usp_save_user')
DROP PROCEDURE usp_save_user
GO
CREATE PROCEDURE dbo.usp_save_user
(
	@username VARCHAR(500),
	@password  VARCHAR(500)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM LOGIN WHERE username = @username)
	BEGIN
		SELECT 'Error' Status, 'User already Exists in System' Message
	END
	ELSE
	BEGIN
		INSERT INTO LOGIN (username,password)
		SELECT @username username,@password password
		SELECT 'Info' Status, 'User crateed in System' Message
	END
END


--INSERT INTO LOGIN_ROLE (ROLENAME)
--SELECT 'Admin' ROLENAME
--UNION
--SELECT 'User' ROLENAME

--INSERT INTO Login(username,password)
--SELECT 'admin' username,'adminpass'password
--UNION 
--SELECT 'user' username,'userpass'password

--INSERT INTO LOGIN_ROLE_USER(USERID,LOGINROLEID)
--select 1 USERID,1 LOGINROLEID
--union 
--select 2 USERID,2 LOGINROLEID