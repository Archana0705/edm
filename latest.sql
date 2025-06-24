SELECT * FROM edm_esevai_operator_change_request_edmall_fn(null, null);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

Approved - 'A'
Overall - 'Y'
closed -'C'

-- eSevai Operator Change Request Report
-- 2 Buttons (Change Operator,  Reject Request)
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(null, null);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);

-- When Press button "Change Operator" Running Below Query:
SELECT upt_change_operator_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);

-- When Press button "Reject Request" Run Below Query:
CREATE OR REPLACE FUNCTION upt_reject_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);

--Action Taken Overall eSevai Operator Approved Report
-- 3 Buttons: (Close_Request, Back to Report, Reject Report)

-- Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn('A', null);

-- When Press Button "Back to Report" Running Below Query:	  
CREATE OR REPLACE FUNCTION upt_back_to_rpt_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);

-- When Press Button "Reject Report" Running Below Query:
--Function:
CREATE OR REPLACE FUNCTION upt_reject_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING)

--eSevai Operator Reject Request
-- 3 Buttons (Close Request, Back to Report, Approve Request)
--Function:
SELECT * FROM edm_esevai_operator_change_request_edmall_fn(p_status, p_edm_id);
--SELECT * FROM edm_esevai_operator_change_request_edmall_fn('N', null);

-- When press Button "Close Request" Running Below Query:
CREATE OR REPLACE FUNCTION upt_cls_rqst_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);


-- When press Button "Back to Report" Running Below Query:
CREATE OR REPLACE FUNCTION upt_back_to_rpt_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);


-- When press Button "Approve Request" Running Below Query:
CREATE OR REPLACE FUNCTION upt_change_operator_mulsel_fn(
	p_com_id CHARACTER VARYING,
	p_user_id CHARACTER VARYING);