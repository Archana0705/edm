----------------------Dairy for EDM Inspection Report--------------- Menu

--Dairy for EDM Inspection Report
--This page contains many search fields
P75_MONTH		-- Statis Values (January, February, March, April, May, June, July, August, September, October, November, December)
P75_DISTRICT 	-- SELECT DISTRICT d, DISTRICT r FROM EDM_DISTRICT_TB ORDER BY ID ASC;
P75_EDM			-- SELECT DESIGNATION d, DESIGNATION r FROM EDM_LOGIN_TB WHERE DISTRICT = :P75_DISTRICT AND DESIGNATION IN ('eDistrict Manager', 'eDistrict Manager 1', 'eDistrict Manager 2');
P75_ACTIVITY	-- SELECT DISTINCT TS_ACTIVITY D, TS_ACTIVITY R FROM TIME_SHEET_DETAILS ORDER BY 1 ASC

-- Dairy for EDM 
-- FUNCTION:
SELECT * FROM time_sheet_details_edmall_fn(p_edm_id, p_date,p_status);


--------------------------Operator Details Menu ----------------------------
--function:
SELECT * FROM operator_details_fn(Null, Null);

--save button

SELECT upt_master_operator_fn(
	P_esevai_id ,
	p_CENTRE_ADDRESS,
	p_AGENCY_CODE ,
	p_DISTRICT_NAME ,
	p_TALUK_NAME ,
	p_NAME ,
	p_MOBILENO,
	p_EMAIL ,
	p_updated_by)
--------------------------New Request toooo Reassgined ---------------------

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