-- Login Function:
SELECT * FROM get_user_authentication_fun( p_mobile, p_password);
--SELECT * FROM get_user_authentication_fun( '8667637037', 'Operator@123');

--My Profile  
--Function:
SELECT * FROM user_profile_fn(p_mobile);

	-- When Click on Save Button Running Below Query:  
			UPDATE edm_login_tb 
			SET name = $2,
				district = $3,
				mobile = $4,
				email = $5,
				photo = v_blob,
				mime_type = v_mime,
				file_name = v_file,
				personal_address = $6,
				personal_email = $7,
				personal_mobile = $8,
				emrgency_contact = $9
			WHERE mobile = $10; -- :app_user



--   #*#*#*#**#*#*#*#*#*#*#**##*#*#*#*#**#*#*#*#*#**#*##*#**#*#*#    #*#**#*#*#*#**#*#*##*#**#*#*#*#*#

						 Helpdesk Operator

--   #*#*#*#**#*#*#*#*#*#*#**##*#*#*#*#**#*#*#*#*#**#*##*#**#*#*#    #*#**#*#*#*#**#*#*##*#**#*#*#*#*#

--P29_STATUS		(New, Open, In-Progress, On-Hold, Resolved, Closed)

-- All Request:
--select 1 from EDM_LOGIN_TB where designation not in ('e-District Manager','Helpdesk Admin1', 'Helpdesk Admin2') and mobile = :app_user
--Function:
--SELECT * FROM hdo_service_request_fn(p_status, p_mobile);
SELECT * FROM hdo_service_request_fn(Null, '8667637037');

-- When Click on Request Number, It move to concern form page: (Page 8)
 --1.Service Request
SELECT * FROM edm_service_request_form_fn(p_request_no);
	-- This page contains many Buttons:
		-- When click on 'In-Progress' Button:
				DO $$
				DECLARE
					inprogress_date TEXT;
				BEGIN
					inprogress_date := TO_CHAR(current_timestamp + INTERVAL '5 hours 30 minutes', 'DD-MM-YYYY HH:MI AM');
					UPDATE edm_service_request_t 
					SET request_status = 'In-Progress',
						req_inprogress_date = inprogress_date,
						additional_information = :P8_ADDITIONAL_INFORMATION
					WHERE request_number = :P8_REQUEST_NUMBER;
				END $$;
		-- When Click on Resolved Button Run Below Query:
				DO $$
				DECLARE
					resolve_date TEXT;
				BEGIN
					resolve_date := TO_CHAR(current_timestamp + INTERVAL '5 hours 30 minutes', 'DD-MM-YYYY HH:MI AM');
						UPDATE edm_service_request_t 
						SET request_status = 'Resolved',
							req_resolve_date = resolve_date,
							additional_information = :P8_ADDITIONAL_INFORMATION
						WHERE request_number = :P8_REQUEST_NUMBER;
				END $$;
		-- When Click on Reassign Button Run Below Query:
				update EDM_SERVICE_REQUEST_T 
				set request_status = 'New',
					assigned_to = :P8_ASSIGNED_TO,
					ADDITIONAL_INFORMATION = :P8_ADDITIONAL_INFORMATION
				where REQUEST_NUMBER = :P8_REQUEST_NUMBER;
		-- When Click on Send Back Button Run Below Query:
				DO $$
				DECLARE
					v_created_by TEXT;
					last_owner TEXT;
					cur_owner TEXT;
				BEGIN
					BEGIN
						SELECT created_by, assigned_to
						INTO v_created_by, cur_owner
						FROM edm_service_request_t
						WHERE request_number = :P8_REQUEST_NUMBER;
					EXCEPTION WHEN OTHERS THEN
						NULL;
					END;
				
					BEGIN
						SELECT assigned_to
						INTO last_owner
						FROM edm_service_request_history_t
						WHERE request_number = :P8_REQUEST_NUMBER
						AND history_id = (
							SELECT MAX(history_id) - 1
							FROM edm_service_request_history_t
							WHERE request_number = :P8_REQUEST_NUMBER
						)
						ORDER BY history_id DESC
						LIMIT 1;
					EXCEPTION WHEN OTHERS THEN
						NULL;
					END;
				
					IF cur_owner IN ('Helpdesk_Operator2', 'Helpdesk_Operator1') THEN
						UPDATE edm_service_request_t
						SET assigned_to = v_created_by,
							request_status = 'Send Back',
							additional_information = :P8_ADDITIONAL_INFORMATION
						WHERE request_number = :P8_REQUEST_NUMBER;
				
					ELSIF cur_owner NOT IN ('Helpdesk_Operator2', 'Helpdesk_Operator1') THEN
						UPDATE edm_service_request_t
						SET assigned_to = COALESCE(last_owner, v_created_by),
							request_status = 'Send Back',
							additional_information = :P8_ADDITIONAL_INFORMATION
						WHERE request_number = :P8_REQUEST_NUMBER;
					END IF;
				END $$;

-- 2. History:
select 
	'<p> Work Note : '||ADDITIONAL_INFORMATION||'</P></n><p> Notes : ' ||HELPDESK_NOTES||'</p>' HELPDESK_NOTES,
    '<p > Updated By :'||(select b.name from edm_login_tb b where b.user_id =  a.CREATED_BY)||'</p></n><p> Updated On :'|| TO_CHAR(CREATED_DATE + NUMTODSINTERVAL(5 * 60 + 30, 'MINUTE'), 'DD/MM/YYYY HH:MI PM') ||'</p>'updatee,
    'Updated By : '||(select b.name from edm_login_tb b where b.user_id =  a.CREATED_BY)||chr(10)||'Updated On : '||CREATED_DATE Updateby
from EDM_SERVICE_REQUEST_HISTORY_T a
where REQUEST_NUMBER = :P8_REQUEST_NUMBER
order by HISTORY_ID desc;

-- P79_STATUS(Static Values : New, Open, In-Progress, On-Hold,Resolved,Closed)
--P79_ASSIGNED_TO (Ashwin : Helpdesk Admin1, 
--				   Gerhara Gowri R : Assistant System Engineer, 
--				   Manju : Helpdesk_Operator1, 
--				   Mohan Raj : Helpdesk_Operator4, 
--				   Mohan Ravikumar : Helpdesk_Operator3, 
--				   Thendral : Helpdesk Admin2,
--                 Vishva VR : Helpdesk_Operator2, 
--				   CMS : Helpdesk_Operator5, 
--				   Kabalishwaran : Helpdesk_Operator7)

-- All Request with Re-Assaign Option:
--Function:
SELECT * FROM hdo_service_request_reassign_fn(p_status, p_mobile);
--SELECT * FROM hdo_service_request_reassign_fn(Null, '8667637037');

-- When Click on Request number it move to concern form page:  8
SELECT * FROM edm_service_request_form_fn(p_request_no);

-- New Request:
--P64_REQ_NUMBER  
--Function:
--SELECT * FROM hdo_service_request_new_fn(p_reqno, p_mobile);
SELECT * FROM hdo_service_request_new_fn(Null, '6380988375');
SELECT * FROM hdo_service_request_new_fn('EDM/2025-05-07/6347', '6380988375');

-- When Click on Request number it move to concern form page:  8
SELECT * FROM edm_service_request_form_fn(p_request_no);
 
-- In Progress Report:
--Function:
SELECT * FROM hdo_service_request_fn(p_status, p_mobile);
--SELECT * FROM hdo_service_request_fn('In-Progress', '6380988375');

-- When Click on Request number it move to concern form page:  8
SELECT * FROM edm_service_request_form_fn(p_request_no);

--Resolved Request Report:
--Function:
SELECT * FROM hdo_service_request_fn(p_status, p_mobile);
--SELECT * FROM hdo_service_request_fn('Resolved', '6380988375');
  
-- When Click on Request number it move to concern form page:  8
SELECT * FROM edm_service_request_form_fn(p_request_no);
--All datas are visible only. Unable to Edit any fields values.  

-- Reopened Request:
--Funtion:
SELECT * FROM hdo_service_request_fn(p_status, p_mobile);
--SELECT * FROM hdo_service_request_fn('Reopen', '6380988375');

-- When Click on Request number it move to concern form page:  8
SELECT * FROM edm_service_request_form_fn(p_request_no);

-- Closed Request Report:
--Function:
SELECT * FROM hdo_service_request_fn(p_status, p_mobile);
--SELECT * FROM hdo_service_request_fn('Closed', '6380988375');
  
-- Reassaigned Requests:
--Function:
SELECT * FROM hdo_service_request_reassigned_fn(p_user_id);
--SELECT * FROM hdo_service_request_reassigned_fn('EDM0383');

-- When Click on Request Number it move to Form page 44:
-- Opeators Details : Page 50:
select 
       ESEVAI_ID,
       CENTRE_ADDRESS,
       AGENCYC_ODE,
       DISTRICT_NAME,
       TALUK_NAME,
       NAME,
       MOBILENO,
       EMAIL
  from MASTER_OPERATOR_DETAILS
  
--function:
SELECT * FROM operator_details_fn(Null, Null);


-- When click on edit button then save button Run Below Query:
Do $$
begin
	update MASTER_OPERATOR_DETAILS 
	set CENTRE_ADDRESS = :P51_CENTRE_ADDRESS,
		AGENCY_CODE = :P51_AGENCY_CODE,
		DISTRICT_NAME = :P51_DISTRICT_NAME,
		TALUK_NAME = :P51_TALUK_NAME,
		NAME       = :P51_NAME ,
		MOBILENO   =  :P51_MOBILENO,
		EMAIL        = :P51_DISTRICT_NAME
	where ESEVAI_ID = :P51_ESEVAI_ID;
end;
End $$;


--Dairy for EDM Inspection Report
--This page contains many search fields
P75_MONTH		-- Statis Values (January, February, March, April, May, June, July, August, September, October, November, December)
P75_DISTRICT 	-- SELECT DISTRICT d, DISTRICT r FROM EDM_DISTRICT_TB ORDER BY ID ASC;
P75_EDM			-- SELECT DESIGNATION d, DESIGNATION r FROM EDM_LOGIN_TB WHERE DISTRICT = :P75_DISTRICT AND DESIGNATION IN ('eDistrict Manager', 'eDistrict Manager 1', 'eDistrict Manager 2');
P75_ACTIVITY	-- SELECT DISTINCT TS_ACTIVITY D, TS_ACTIVITY R FROM TIME_SHEET_DETAILS ORDER BY 1 ASC

-- Dairy for EDM
-- FUNCTION:
SELECT * FROM time_sheet_details_edmall_fn(p_edm_id, p_date,p_status);
--SELECT * FROM time_sheet_details_edmall_fn(Null, Null, Null);
	
--  EDM Instruction Request
P80_DISTRICT		--SELECT DISTINCT DISTRICT d, DISTRICT r FROM EDM_LOGIN_TB ORDER BY 1 ASC;
P80_ASSIGNED_TO		--SELECT DISTINCT DESIGNATION d, DESIGNATION r FROM EDM_LOGIN_TB WHERE DESIGNATION  LIKE 'eDistrict%' AND DISTRICT = :P80_DISTRICT;
P80_INSTRUCTION_TYPE--(Overcharging issues ,Id activation request , Others)


INSERT INTO EDM_SERVICE_ASSAIGN_TB(
	DISTRICT, 
	ASSIGNED_TO, 
	INSTRUCTION_TYPE, 
	SHORT_DESCRIPTION, 
	REQUEST_CREATED_DTTM, 
	REQUESTED_BY, 
	ATTACHMENT, 
	FULL_DESCRIPTION)
Values(
	:P80_DISTRICT, 
	:P80_ASSIGNED_TO, 
	:P80_INSTRUCTION_TYPE, 
	:P80_SHORT_DESCRIPTION, 
	:P80_REQUEST_CREATED_DTTM, 
	:P80_REQUESTED_BY, 
	:P80_ATTACHMENT, 
	:P80_FULL_DESCRIPTION);

--1st Tab: Open Requests
-- Function:
SELECT * FROM edm_service_assign_edmall_fun('New', Null);

--2nd Tab:	Closed Requests
--Function:
SELECT * FROM edm_service_assign_edmall_fun('Closed', Null);

-- Ticket Updates:(Front end pivot Table) : Page 76
--SELECT    REQUEST_STATUS , (SELECT NAME FROM EDM_LOGIN_TB WHERE DESIGNATION = e.ASSIGNED_TO) NAME, NVL2(ASSIGNED_TO, 1,0) ASSIGNED_TO,
--Function:
SELECT * FROM edm_ticket_updates_fn();

-- Helpdesk Ticket Updates: Page 96
--Funtion:
SELECT * FROM helpdesh_ticket_updates_fn();

--	Helpdesk Ticket Report
P86_ASSIGNED_TO		--	Display Value			Return Value
					-- Gerhara Gowri R			Assistant System Engineer
					-- Manju					Helpdesk_Operator1
					-- Mohan Raj				Helpdesk_Operator4
					-- Mohan Ravikumar			Helpdesk_Operator3
					-- Vishva VR				Helpdesk_Operator2
					-- Kabalishwaran			Helpdesk_Operator7
--Helpdesk Instructions Open Report:
--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn(p_status, p_edm_id);
SELECT * FROM hd_edm_service_assaign_edmall_fn('New', 'EDM0183');

-- When click on Request Number it move to Form page 87:
P87_DISTRICT		--SELECT DISTINCT DISTRICT d, DISTRICT r FROM EDM_LOGIN_TB ORDER BY 1 ASC;
P87_ASSIGN_TO_1		--SELECT DISTINCT DESIGNATION d, DESIGNATION r FROM EDM_LOGIN_TB WHERE DESIGNATION  LIKE 'eDistrict%' AND DISTRICT = :P87_DISTRICT UNION ALL SELECT NAME	d, DESIGNATION r FROM EDM_LOGIN_TB WHERE Designation IN ('Helpdesk_Operator3', 'Helpdesk_Operator4',  'Helpdesk_Operator2',  'Helpdesk_Operator1', 'Helpdesk_Operator7','Assistant System Engineer2');
--Function:
SELECT * FROM edm_service_assign_form_fun(p_request_number);
  
-- This page contains 3 Buttons:
-- When click on Re-Assign Button Running Below Query:
IF :P87_ASSIGN_TO_1 IN (    'Helpdesk_Operator3', 'Helpdesk_Operator4',     'Helpdesk_Operator2', 'Helpdesk_Operator1',     'Helpdesk_Operator7', 'Assistant System Engineer2') THEN
    IF :P87_DISTRICT IS NULL THEN
        UPDATE HD_EDM_SERVICE_ASSAIGN_TB
        SET EDM_NOTES  = :P87_EDM_NOTES,
            EDM_ID = (SELECT User_ID FROM EDM_LOGIN_TB WHERE DESIGNATION = :P87_ASSIGN_TO_1 AND ROWNUM = 1),
            DISTRICT   = :P87_DISTRICT,
            ASSIGN_TO_1 = :P87_ASSIGN_TO_1,
            REQUEST_STATUS = 'New'
        WHERE REQUEST_NUMBER = :P87_REQUEST_NUMBER;
    ELSE
        UPDATE HD_EDM_SERVICE_ASSAIGN_TB
        SET EDM_NOTES  = :P87_EDM_NOTES,
            EDM_ID = (SELECT User_ID FROM EDM_LOGIN_TB WHERE DESIGNATION = :P87_ASSIGN_TO_1 AND DISTRICT = :P87_DISTRICT AND ROWNUM = 1),
            DISTRICT   = :P87_DISTRICT,
            ASSIGN_TO_1 = :P87_ASSIGN_TO_1,
            REQUEST_STATUS = 'New'
        WHERE REQUEST_NUMBER = :P87_REQUEST_NUMBER;
    END IF;
ELSE
    UPDATE HD_EDM_SERVICE_ASSAIGN_TB
    SET EDM_NOTES  = :P87_EDM_NOTES,
        DISTRICT   = :P87_DISTRICT,
        ASSIGN_TO_1 = :P87_ASSIGN_TO_1,
        REQUEST_STATUS = 'Assisned to Edm'
    WHERE REQUEST_NUMBER = :P87_REQUEST_NUMBER;
END IF;

-- When Press button "Close Ticket" Running Below Query:
UPDATE HD_EDM_SERVICE_ASSAIGN_TB
SET REQUEST_STATUS = 'Closed', 
	EDM_NOTES_1 = :P87_EDM_NOTES_1_2
WHERE REQUEST_NUMBER = :P87_REQUEST_NUMBER;

-- When press button In-Progress	Running Below Query:
UPDATE HD_EDM_SERVICE_ASSAIGN_TB
SET REQUEST_STATUS = 'In-Progress'
WHERE REQUEST_NUMBER = :P87_REQUEST_NUMBER;

	 
--Helpdesk Instructions In-Progress Report:
--Function:
--SELECT * FROM hd_edm_service_assaign_edmall_fn('In-Progress', 'EDM0183');
SELECT * FROM hd_edm_service_assaign_edmall_fn('In-Progress', 'EDM0183');

-- When click on Request Number it move to form page 87:
SELECT * FROM edm_service_assign_form_fun(p_request_number);

--Helpdesk Instructions Closed Report
--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn(p_status, p_edm_id);
--SELECT * FROM hd_edm_service_assaign_edmall_fn('Closed', 'EDM0183');	  
	  
--eSevai Operator Change Request Form
P92_DISTRICT		-- SELECT DISTINCT DISTRICT d, DISTRICT r FROM Edm_Login_tb ORDER BY 1 ASC;
INSERT INTO EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB(
            ( DISTRICT, ESEVAI_ID, CURRENT_OPERATOR_NAME, CURRENT_OPERATOR_MOBILE_NUMBER, CURRENT_MAIL_ID, REASON_FOR_OPERATOR_CHANGE, NEW_OPERATOR_NAME, NEW_OPERATOR_AADHAR_NUMBER, NEW_OPERATOR_PHONE_NUMBER,
			  NEW_MAIL_ID, PHOTO_ATTACHMENT, MIME_TYPE, FILE_NAME)
	  VALUES(:P92_DISTRICT, :P92_ESEVAI_ID, :P92_CURRENT_OPERATOR_NAME, :P92_CURRENT_OPERATOR_MOBILE_NUMBER, :P92_CURRENT_MAIL_ID, :P92_REASON_FOR_OPERATOR_CHANGE, :P92_NEW_OPERATOR_NAME, :P92_NEW_OPERATOR_AADHAR_NUMBER, 
	         :P92_NEW_OPERATOR_PHONE_NUMBER, :P92_NEW_MAIL_ID, :P92_PHOTO_ATTACHMENT, :P92_MIME_TYPE, :P92_FILE_NAME);


-- eSevai Operator Change Request Report
-- 2 Buttons (Change Operator,  Reject Request)
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(null, null);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- When Press button "Change Operator" Running Below Query:
BEGIN
IF :P84_COM_ID IS NOT NULL THEN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'A'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID, '[^|]+', 1, LEVEL) IS NOT NULL);
ELSE
 --APEX_UTIL.SET_SESSION_STATE( 'Please select at least 1 request');
 RAISE_APPLICATION_ERROR(-20001, 'Please select at least 1 request');
 END iF;
END;

-- When Press button "Reject Request" Run Below Query:
BEGIN
IF :P84_COM_ID IS NOT NULL THEN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'N'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID, '[^|]+', 1, LEVEL) IS NOT NULL);
ELSE
 --APEX_UTIL.SET_SESSION_STATE( 'Please select at least 1 request');
 RAISE_APPLICATION_ERROR(-20001, 'Please select at least 1 request');
 END iF;
END;

--Action Taken Overall eSevai Operator Approved Report
-- 3 Buttons: (Close_Request, Back to Report, Reject Report)

-- Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('A', null);

-- When Press Button "Back to Report" Running Below Query:	  

BEGIN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'Y'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID_1, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID_1, '[^|]+', 1, LEVEL) IS NOT NULL);

END;

-- When Press Button "Reject Report" Running Below Query:
BEGIN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'N'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID_1, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID_1, '[^|]+', 1, LEVEL) IS NOT NULL);

END;

--eSevai Operator Reject Request
-- 3 Buttons (Close Request, Back to Report, Approve Request)
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn('N', null);

-- When press Button "Close Request" Running Below Query:
BEGIN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'R'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL) IS NOT NULL);

END;


-- When press Button "Back to Report" Running Below Query:
BEGIN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'Y'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL) IS NOT NULL);

END;


-- When press Button "Approve Request" Running Below Query:
BEGIN
UPDATE EDM_ESEVAI_OPERATOR_CHANGE_REQUEST_TB
SET STATUS = 'A'
    WHERE ID IN (SELECT REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL)
    FROM DUAL
    CONNECT BY REGEXP_SUBSTR(:P84_COM_ID_2, '[^|]+', 1, LEVEL) IS NOT NULL);

END;



-- Approve/Reject Operator Change Report:
--1. Closed Operator change Report
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('C', Null);
-- SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);  

--2. Rejected Operator change Report
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('R', Null);
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- Public Petitions :
-- Function:
SELECT * FROM  hdo_public_pettition_fn();	

-- When Click on Edit/ Create it move to Page 98:
  
INSERT INTO EDM_Public_petitions_TB(PETITION_DATE, CITIZEN_NAME, MOBILE_NUMBER, ISSUE_RELATED_TO, ISSUE_HANDLED_BY, REMARKS, ISSUE_TYPE)
                        VALUES (:P98_PETITION_DATE, :P98_CITIZEN_NAME, :P98_MOBILE_NUMBER, :P98_ISSUE_RELATED_TO, :P98_ISSUE_HANDLED_BY, :P98_REMARKS, :P98_ISSUE_TYPE;
						
-- EDM Dairy : Page as per 77						
--Function:
SELECT * FROM TIME_SHEET_DETAILS_edmall_fn(p_edm_id , p_date ,  p_status );
SELECT * FROM TIME_SHEET_DETAILS_edmall_fn('9940660466', '07/05/2024','New' );						


--   #*#*#*#**#*#*#*#*#*#*#**##*   Call Center Person #*#**#*#*#*#**#*#*##*#**#*#*#*#*#

-- Ticket Raise Ticket:
P83_DISTRICT 		-- SELECT DISTRICT d, DISTRICT r FROM EDM_DISTRICT_TB;
P83_ASSIGNED_TO		-- SELECT DISTINCT Name d, Designation r FROM EDM_LOGIN_TB WHERE DESIGNATION   IN( 'Helpdesk_Operator7', 'Helpdesk_Operator3', 'Helpdesk_Operator4', 'Assistant System Engineer1', 'Assistant System Engineer2', 'Assistant System Engineer', 'Helpdesk_Operator1', 'Helpdesk_Operator2') ORDER BY 1 ASC;
P83_INSTRUCTION_TYPE-- Overcharging issues - Inspection request, Id activation request - Inspection, Others

INSERT INTO HD_EDM_SERVICE_ASSAIGN_TB(DISTRICT, ASSIGNED_TO, INSTRUCTION_TYPE, SHORT_DESCRIPTION, FULL_DESCRIPTION, ATTACHMENT, MIME_TYPE, FILE_NAME, REQUEST_CREATED_DTTM, REQUESTED_BY)
                               VALUES(:P83_DISTRICT, :P83_ASSIGNED_TO, :P83_INSTRUCTION_TYPE, :P83_SHORT_DESCRIPTION, :P83_FULL_DESCRIPTION, :P83_ATTACHMENT, :P83_MIME_TYPE, :P83_FILE_NAME, :P83_REQUEST_CREATED_DTTM, :P83_REQUESTED_BY);


--1. Open Requests							   
select REQUEST_NUMBER,
       DISTRICT,
       ASSIGNED_TO,
       EDM_ID,
       INSTRUCTION_TYPE,
       PRIORITY,
       SHORT_DESCRIPTION,
       FULL_DESCRIPTION,
       EDM_NOTES,
        ATTACHMENT,
       MIME_TYPE,
       FILE_NAME,
       LAST_UPDATE,
       CHARSET,
       REQUEST_CREATED_DTTM,
       REQUESTED_BY,
       STATUS,
       CREATED_BY,
       CREATED_DTTM,
       UPDATED_BY,
       UPDATED_DTTM,
       REQUEST_STATUS,
       EDM_UPLOAD,
       EDM_FILE_NAME,
       EDM_MIME_TYPE,
       EDM_LAST_UPDATE,
       EDM_CHARSET,
       PRODUCT_RATING,
       SHORT,
       EDM_SEC_COMMENTS,
       APPLICATION_ID
from HD_EDM_SERVICE_ASSAIGN_TB
WHERE REQUEST_STATUS = 'New'
AND STATUS = 'Y';



--2. Closed Requests
select REQUEST_NUMBER,
       DISTRICT,
       ASSIGNED_TO,
       EDM_ID,
       INSTRUCTION_TYPE,
       PRIORITY,
       SHORT_DESCRIPTION,
       FULL_DESCRIPTION,
       EDM_NOTES,
       ATTACHMENT,
       MIME_TYPE,
       FILE_NAME,
       LAST_UPDATE,
       CHARSET,
       REQUEST_CREATED_DTTM,
       REQUESTED_BY,
       STATUS,
       CREATED_BY,
       CREATED_DTTM,
       UPDATED_BY,
       UPDATED_DTTM,
       REQUEST_STATUS,
       EDM_UPLOAD,
       EDM_FILE_NAME,
       EDM_MIME_TYPE,
       EDM_LAST_UPDATE,
       EDM_CHARSET,
       PRODUCT_RATING,
       SHORT,
       EDM_SEC_COMMENTS
from HD_EDM_SERVICE_ASSAIGN_TB
WHERE REQUEST_STATUS = 'Closed'
AND STATUS = 'Y';

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('Closed', Null);
	
	
javascript:  $s('P83_ASSIGNED_TO', '#ASSIGNED_TO#');  $s('P83_INSTRUCTION_TYPE', '#INSTRUCTION_TYPE#');  $s('P83_CREATED_DTTM', '#CREATED_DTTM#');  $s('P83_REQUESTED_BY', '#REQUESTED_BY#');  $s('P83_ATTACHMENT', '#ATTACHMENT#');  $s('P83_FULL_DESCRIPTION', '#FULL_DESCRIPTION#');  $s('P83_SHORT_DESCRIPTION', '#SHORT_DESCRIPTION#');  $s('P83_DISTRICT', '#DISTRICT#');  $s('P83_APPLICATION_ID', '#APPLICATION_ID#');	
javascript:  $s('P83_DISTRICT','#DISTRICT#'); $s('P83_ASSIGNED_TO','#ASSIGNED_TO#'); $s('P83_INSTRUCTION_TYPE','#INSTRUCTION_TYPE#'); $s('P83_CREATED_DTTM','#CREATED_DTTM#'); $s('P83_REQUESTED_BY','#REQUESTED_BY#'); $s('P83_ATTACHMENT','#ATTACHMENT#'); $s('P83_FULL_DESCRIPTION','#FULL_DESCRIPTION#');  $s('P83_SHORT_DESCRIPTION','#SHORT_DESCRIPTION#');

-- Helpdesk Ticket Report
--1. Helpdesk Instructions Open Report
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
       edm_sec_comments,
       (EXTRACT(DAY FROM (Current_timestamp - CREATED_DTTM)) * 24 + EXTRACT(HOUR FROM (Current_timestamp - CREATED_DTTM)) + EXTRACT(MINUTE FROM (Current_timestamp - CREATED_DTTM)) / 60 + 
        EXTRACT(SECOND FROM (Current_timestamp - CREATED_DTTM)) / 3600 ) AS HOURS_SINCE_CREATION
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status IN ('New', 'Assisned to Edm')
AND STATUS = 'Y'
ORDER BY CREATED_DTTM DESC;

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn(ARRAY['New', 'Assigned to Edm'], null);

	   
-- When click on Request Number it move to Form page 87:

--2. Helpdesk Instructions In-Progress Report
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
        (EXTRACT(DAY FROM (Current_timestamp - Created_dttm)) * 24 + EXTRACT(HOUR FROM (Current_timestamp - Created_dttm)) + EXTRACT(MINUTE FROM (Current_timestamp - Created_dttm)) / 60 + 
        EXTRACT(SECOND FROM (Current_timestamp - Created_dttm)) / 3600 ) AS HOURS_SINCE_CREATION,
       edm_sec_comments
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status IN ( 'In-Progress')
AND STATUS = 'Y';

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('In-Progress', null);
	   
-- When click on Request Number it move to Form page 87:


-- 3.Helpdesk Instructions Closed Report:
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
       edm_sec_comments,
       edm_Notes_1
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status = 'Closed'
AND STATUS = 'Y';
	  	  
--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('Closed', null);
SELECT * FROM hd_edm_service_assaign_edmall_fn(p_status, null);

--eSevai Operator Change Request Form: ,
-- eSevai Operator Change Request Report:					 (Same like Helpdesk Person)
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(null, null);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- Citizens Issue Report:
select REQUEST_NUMBER
      ,e.NAME
      ,e.MOBILE
      ,e.EMAIL
      ,e.DISTRICT
      ,e.TALUK
      ,e.PINCODE
      ,e.ISSUE
      ,e.ISSUE_SUB_CATEGORY
      ,e.REMARKS
      ,e.ISSUE_ATTACHMENT
      ,e.ISSUE_ATTACHMENT_MIMETYPE
      ,e.ISSUE_ATTACHMENT_FILENAME
      ,e.SOLUTION
      ,e.STATUS
      ,e.CREATED_BY
      ,e.CREATED_DTTM
      ,e.UPDATED_BY
      ,e.UPDATED_DTTM
      ,e.REQUEST_STATUS
      ,e.ASSIGNED_TO
      ,e.HELPDESK_NOTES
      ,sys.dbms_lob.getlength(e.HELPDESK_UPLOAD)HELPDESK_UPLOAD
      ,e.HELPDESK_FILENAME
      ,e.HELPDESK_MIMETYPE
from CITIZEN_SERVICE_REQUEST_T e, EDM_LOGIN_TB l
where     l.designation=e.assigned_to 
  and l.mobile= :app_user 
  order by e.CREATED_DTTM desc;

-- fUNCTION:
SELECT * FROM citizen_service_request_fn(NUll, '9751601990');
SELECT * FROM citizen_service_request_fn(p_status, p_mobile);


-- Chen click on Request number it move to Form page:

UPDATE CITIZEN_SERVICE_REQUEST_T 
SET SOLUTION = P105_SOLUTION,
    HELPDESK_UPLOAD = :P105_HELPDESK_UPLOAD
	HELPDESK_FILENAME = :P105_HELPDESK_FILENAME
	HELPDESK_MIMETYPE = :P105_HELPDESK_MIMETYPE
WHERE REQUEST_NUMBER = :P105_REQUEST_NUMBER;


---------------------------------------------------------------------------------------------------
-- OPERATORS Reset PAssword:

UPDATE Edm_Login_tb
SET PAssword = :P_NEW_Pssword
WHERE MOBILE = :P_Operator_ID








--   #*#*#*#**#*#*#*#*#*#*#**##*   ADMIN	 #*#**#*#*#*#**#*#*##*#**#*#*#*#*#
-- All Request
select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD,
    REQ_INPROGRESS_DATE,
    REQ_RESOLVE_DATE
from EDM_SERVICE_REQUEST_T e,EDM_LOGIN_TB b
where e. ASSIGNED_TO  = b.DESIGNATION
order by e.created_date desc;

-- Function:
SELECT * FROM hdo_service_request_fn(Null, Null);
SELECT * FROM hdo_service_request_fn(p_status, p_mobile);

-- All Request with Re-Assaign Option: 	(Same like Helpdesk Person)
select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD,
    (EXTRACT(DAY FROM (Current_timestamp - e.CREATED_DATE)) * 24 + EXTRACT(HOUR FROM (Current_timestamp - e.CREATED_DATE)) + EXTRACT(MINUTE FROM (Current_timestamp - e.CREATED_DATE)) / 60 + 
    EXTRACT(SECOND FROM (Current_timestamp - e.CREATED_DATE)) / 3600 ) AS HOURS_SINCE_CREATION
from EDM_SERVICE_REQUEST_T e,edm_login_tb b
where e.assigned_to = b.designation
and e.request_status = 'New'
order by e.CREATED_DATE desc;
  
--Function:
SELECT * FROM hdo_service_request_reassign_fn(Null, Null)
SELECT * FROM hdo_service_request_reassign_fn(p_status, p_mobile);
  
-- When Click on Request Number it move to Form page 8:


-- In Progress Request:
select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name  ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD,
    (EXTRACT(DAY FROM (current_timestamp - e.CREATED_DATE)) * 24 + 
	 EXTRACT(HOUR FROM (current_timestamp - e.CREATED_DATE)) + 
	 EXTRACT(MINUTE FROM (current_timestamp - e.CREATED_DATE)) / 60 + 
	 EXTRACT(SECOND FROM (current_timestamp - e.CREATED_DATE)) / 3600 ) AS HOURS_SINCE_CREATION
from EDM_SERVICE_REQUEST_T e,edm_login_tb b
where request_status = 'In-Progress'
and e.assigned_to = b.designation
order by e.created_date desc;

--Function:
SELECT * FROM hdo_service_request_fn('In-Progress', Null);
SELECT * FROM hdo_service_request_fn(p_status, Null);


-- When Click on Request Number it move to Form page 8:

-- Resolved Requests:
select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD
from EDM_SERVICE_REQUEST_T e,edm_login_tb b
where request_status = 'Resolved'
and  e.assigned_to = b.designation
order by created_date desc;

--Function:
SELECT * FROM hdo_service_request_fn('Resolved', Null);
SELECT * FROM hdo_service_request_fn(p_status, Null);

-- When Click on Request Number it move to Form page 44:

-- Reopened Requests:
select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD
from EDM_SERVICE_REQUEST_T e,edm_login_tb b
where request_status = 'Reopen'
and e.assigned_to = b.designation
order by created_date desc;

--Function:
SELECT * FROM hdo_service_request_fn('Reopen', Null);
SELECT * FROM hdo_service_request_fn(p_status, Null);

-- When Click on Request Number it move to Form page 8:


-- Closed Requests;

select 
	e.REQUEST_NUMBER,
    e.OPERATOR,
    e.LOCATION,
    e.ISSUE_TYPE,
    e.IMPACTED_APPLICATION,
    e.PRIORITY,
    e.short   SHORT_DESCRIPTION,
    e.FULL_DESCRIPTION,
    e.ADDITIONAL_INFORMATION,
    e.HELPDESK_NOTES,
    e.HISTORY,
    e.UPLOAD,
    e.ATTACH_MIMETYPE,
    e.ATTACH_FILENAME,
    e.ATTACH_LAST_UPDATE,
    e.ATTACH_CHARSET,
    e.REQUEST_CREATED,
    e.REQUESTED_BY,
    e.REQUESTED_DISTRICT,
    e.REQUESTED_GROUP,
    e.CONTACT_TYPE,
    e.ASSIGNMENT_GROUP,
    b.name ASSIGNED_TO,
    e.STATUS,
    e.CREATED_BY,
    e.CREATED_DATE,
    e.UPDATED_BY,
    e.UPDATED_DATE,
    e.REQUEST_STATUS,
    e.HELPDESK_FILENAME,
    e.HELPDESK_CHARSET,
    e.HELPDESK_LASTUPDATE,
    e.HELPDESK_MIMETYPE,
    e.HELPDESK_UPLOAD
from EDM_SERVICE_REQUEST_T e,edm_login_tb b
where request_status = 'Closed'
and e.assigned_to = b.designation
order by created_date desc;

--Function:
SELECT * FROM hdo_service_request_fn('Closed', Null);
SELECT * FROM hdo_service_request_fn(p_status, Null);

-- When Click on Request Number it move to Form page 44:


-- Reassigned Requests:
SELECT history_id,
       request_number,
       operator,
       location,
       issue_type,
       impacted_application,
       priority,
       short_description,
       full_description,
       additional_information,
       helpdesk_notes,
       history,
       upload,
       attach_mimetype,
       attach_filename,
       attach_last_update,
       attach_charset,
       request_created,
       requested_by,
       requested_district,
       requested_group,
       contact_type,
       assignment_group,
       COALESCE(
           (SELECT name FROM edm_login_tb WHERE designation = assigned_to),
           requested_by
       ) AS assigned_to_name,
       status,
       created_by,
       created_date,
       updated_by,
       updated_date,
       request_status,
       helpdesk_upload,
       helpdesk_filename,
       helpdesk_mimetype,
       helpdesk_lastupdate,
       helpdesk_charset,
       product_rating,
       "short",  -- Quoted reserved word
       helpdesk_sec_comments
FROM   edm_service_request_history_t
WHERE  created_by IN (
           SELECT user_id
           FROM edm_login_tb
           WHERE designation IN (
               'Helpdesk_Operator1',
               'Helpdesk_Operator3',
               'Helpdesk_Operator4',
               'Helpdesk_Operator5',
               'Assistant System Engineer'
           )
       )
AND assigned_to != (
           SELECT designation
           FROM edm_login_tb
           WHERE user_id = $1  -- replace $1 with bind param as per your app framework
       )
ORDER BY created_date DESC;




-- When Click on Request number it move to Form page 44:


--Operators Details
select 
       ESEVAI_ID,
       CENTRE_ADDRESS,
       AGENCY_CODE,
       DISTRICT_NAME,
       TALUK_NAME,
       NAME,
       MOBILENO,
       EMAIL
from MASTER_OPERATOR_DETAILS;
--Function:
SELECT * FROM operator_details_fn(Null, Null);



--Dairy for EDM Inspection Report (Page as per 75)
-- FUNCTION:
SELECT * FROM time_sheet_details_edmall_fn(p_edm_id, p_date,p_status);
--SELECT * FROM time_sheet_details_edmall_fn(Null, Null, Null);

--EDM Instruction Request (Page as Per 80)
-- Function:
SELECT * FROM edm_service_assign_edmall_fun('New', Null);
SELECT * FROM edm_service_assign_edmall_fun('Closed', Null);
 
-- Ticket Updates:(Front end pivot Table) : Page as per 76
--Function:
SELECT * FROM edm_ticket_updates_fn();


-- Helpdesk Ticket Updates: Page as per 96
--Funtion:
SELECT * FROM helpdesh_ticket_updates_fn();


--	Helpdesk Ticket Report
P86_ASSIGNED_TO		--	Display Value			Return Value
					-- Gerhara Gowri R			Assistant System Engineer
					-- Manju					Helpdesk_Operator1
					-- Mohan Raj				Helpdesk_Operator4
					-- Mohan Ravikumar			Helpdesk_Operator3
					-- Vishva VR				Helpdesk_Operator2
					-- Kabalishwaran			Helpdesk_Operator7
--Helpdesk Instructions Open Report:
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
       edm_sec_comments,
       (EXTRACT(DAY FROM (CURRENT_TIMESTAMP - CREATED_DTTM)) * 24 + 
	    EXTRACT(HOUR FROM (CURRENT_TIMESTAMP - CREATED_DTTM)) + 
		EXTRACT(MINUTE FROM (CURRENT_TIMESTAMP - CREATED_DTTM)) / 60 + 
        EXTRACT(SECOND FROM (CURRENT_TIMESTAMP - CREATED_DTTM)) / 3600 ) AS HOURS_SINCE_CREATION
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status IN ('New', 'Assisned to Edm')
AND STATUS = 'Y'
ORDER BY CREATED_DTTM DESC;

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('New', Null);	   

-- When click on Request Number it move to Form page 87:

 
--Helpdesk Instructions In-Progress Report:
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
       (EXTRACT(DAY FROM (CURRENT_TIMESTAMP - created_dttm)) * 24 +
        EXTRACT(HOUR FROM (CURRENT_TIMESTAMP - created_dttm)) +
        EXTRACT(MINUTE FROM (CURRENT_TIMESTAMP - created_dttm)) / 60.0 +
        EXTRACT(SECOND FROM (CURRENT_TIMESTAMP - created_dttm)) / 3600.0) AS HOURS_SINCE_CREATION,
       edm_sec_comments
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status IN ( 'In-Progress')
AND STATUS = 'Y';

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('In-Progress', Null);

-- When click on Request Number it move to form page 87:


--Helpdesk Instructions Closed Report
SELECT request_number,
       district,
       assigned_to,
       edm_id,
       instruction_type,
       priority,
       short_description,
       full_description,
       edm_notes,
       ATTACHMENT,
       mime_type,
       file_name,
       last_update,
       charset,
       request_created_dttm,
       requested_by,
       status,
       created_by,
       created_dttm,
       updated_by,
       updated_dttm,
       request_status,
       EDM_UPLOAD,
       edm_file_name,
       edm_mime_type,
       edm_last_update,
       edm_charset,
       product_rating,
       short,
       edm_sec_comments,
       edm_Notes_1
FROM   HD_EDM_SERVICE_ASSAIGN_TB
WHERE request_status = 'Closed'
AND STATUS = 'Y';

--Function:
SELECT * FROM hd_edm_service_assaign_edmall_fn('Closed', Null);	  
	  
	  
--eSevai Operator Change Request Form : (Page as per 92)

-- eSevai Operator Change Request Report Page as Per 84 : As per Helpdesk Person
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(null, null);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- Approve/Reject Operator Change Report: As per Page 91:
--1. Closed Operator change Report
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('C', Null);
-- SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);  
--2. Rejected Operator change Report
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('R', Null);
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- Public Petitions : As per Page 97:   -- When Click on Edit/ Create it move to Page 98:
-- Function:
SELECT * FROM  hdo_public_pettition_fn();	

  
-- EDM Dairy : Page as per 77
-- FUNCTION:
SELECT * FROM time_sheet_details_edmall_fn(p_edm_id, p_date,p_status);
--SELECT * FROM time_sheet_details_edmall_fn(Null, Null, Null);

--Timesheet Details : Page 40
P40_DATE		: -- SELECT TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -LEVEL + 1), 'MON') d,TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -LEVEL + 1), 'MM' ) r FROM DUAL CONNECT BY LEVEL <= 12 ORDER BY r;
P40_REQUEST_BY	: -- select distinct district d ,district r from edm_login_tb order by district

select * from (select (APEX_ITEM.CHECKBOX(1,TS_ID,'UNCHECKED')) "select",
       TS_ID,
       to_char(TS_DATE,'dd/mm/yyyy')TS_DATE,
       TS_REQ_NAME,
       TS_STATUS,
       TS_CURRENT_USER,
       TS_TOTAL_WRK_HRS,
       (select district from edm_login_tb where mobile = TS_CURRENT_USER)district
from TIME_SHEET_MASTER
where  (to_char(TS_DATE,'mm') = :P40_DATE or :P40_DATE is null) )
where ( district = :P40_REQUEST_BY or :P40_REQUEST_BY is null)
order by TS_DATE desc
 /* where TS_CURRENT_USER in (select MOBILE from EDM_LOGIN_TB where DESIGNATION IN ( 'Helpdesk Admin1', 'Helpdesk Admin2') and status = 'Y' )
  and (TS_DATE = :P40_DATE or :P40_DATE is null) 
  and (TS_CREATED_BY = :P40_REQUEST_BY or :P40_REQUEST_BY is null ) ;*/
  
  
-- When click on Date, It move to concern date page:
select TS_EDM_ID,
       TS_NO,
       to_char(TS_DATE,'dd/mm/yyyy')TS_DATE,
       TS_ACTIVITY,
       TS_NOTES,
       TS_CREATED_BY,
       TS_HRS||' : '|| TS_MINS Total_Spending_Hrs    
from TIME_SHEET_DETAILS  
WHERE to_char(TS_DATE,'dd/mm/yyyy') = :P38_DATE
AND TS_CREATED_BY = :P38_TS_CREATED_BY;                  



---#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#**#*#*#*#*#*#*#**#*#*#*#*#**#*#*#**#*#*#*#*#*#*#*#*#**#*#*#*#*#**#*#


--					Citizens Tickets

---#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#**#*#*#*#*#*#*#**#*#*#*#*#**#*#*#**#*#*#*#*#*#*#*#*#**#*#*#*#*#**#*#

-- Helpdesk Tickets Form Page:
INSERT INTO CITIZEN_SERVICE_REQUEST_T(NAME
								     ,MOBILE
									 ,EMAIL
									 ,DISTRICT
									 ,TALUK
									 ,PINCODE
									 ,ISSUE
									 ,ISSUE_SUB_CATEGORY
									 ,REMARKS
									 ,ISSUE_ATTACHMENT
									 ,ISSUE_ATTACHMENT_MIMETYPE
									 ,ISSUE_ATTACHMENT_FILENAME
									 ,SOLUTION
									 ,HELPDESK_NOTES
									 ,HELPDESK_UPLOAD
									 ,HELPDESK_FILENAME
									 ,HELPDESK_MIMETYPE)
						     VALUES(  :P101_NAME
								     ,:P101_MOBILE
									 ,:P101_EMAIL
									 ,:P101_DISTRICT
									 ,:P101_TALUK
									 ,:P101_PINCODE
									 ,:P101_ISSUE
									 ,:P101_ISSUE_SUB_CATEGORY
									 ,:P101_REMARKS
									 ,:P101_ISSUE_ATTACHMENT
									 ,:P101_ISSUE_ATTACHMENT_MIMETYPE
									 ,:P101_ISSUE_ATTACHMENT_FILENAME
									 ,:P101_SOLUTION
									 ,:P101_HELPDESK_NOTES
									 ,:P101_HELPDESK_UPLOAD
									 ,:P101_HELPDESK_FILENAME
									 ,:P101_HELPDESK_MIMETYPE);


-- Same page Helpdesk Tickets Report:		(Citizen Service Request Report)
select REQUEST_NUMBER,
       NAME,
       MOBILE,
       EMAIL,
       DISTRICT,
       TALUK,
       PINCODE,
       ISSUE,
       ISSUE_SUB_CATEGORY,
       REMARKS,
       ISSUE_ATTACHMENT,
       ISSUE_ATTACHMENT_MIMETYPE,
       ISSUE_ATTACHMENT_FILENAME,
       SOLUTION,
       STATUS,
       CREATED_BY,
       CREATED_DTTM,
       UPDATED_BY,
       UPDATED_DTTM,
       REQUEST_STATUS,
       ASSIGNED_TO,
       HELPDESK_NOTES,
       HELPDESK_UPLOAD,
       HELPDESK_FILENAME,
       HELPDESK_MIMETYPE
  from CITIZEN_SERVICE_REQUEST_T
  WHERE CREATED_BY = :P101_MOBILE ;								
  
  
  
  

  