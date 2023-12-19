package com.brickfarm.dao.inactivemember;

import java.util.List;

import com.brickfarm.dto.admin.kmh.AdminMemberDTO;
import com.brickfarm.dto.admin.kmh.AdminNoActiveMemberDTO;
import com.brickfarm.vo.admin.kmh.AdminInactiveMemberVO;

public interface InactiveMemberDAO {

	   // ==[송지영]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 

	   // ==[김미형]======================================================================================================================================== 
	   
			// 휴먼 회원 조회
			List<AdminInactiveMemberVO> selectInactiveMember(AdminNoActiveMemberDTO tmpMember) throws Exception;

			// 휴먼 회원 전환
			int insertInactiveMember(List<Integer> member_no) throws Exception;

			// 휴먼 회원 활성화
			boolean updateActiveMember(String member_id) throws Exception;
			
	   // ================================================================================================================================================== 

	   // ==[이경민]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 

	   // ==[염세환]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 

	   // ==[박상진]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 

	   // ==[송영태]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 

	   // ==[김용진]======================================================================================================================================== 
	   
	   // ================================================================================================================================================== 
}