package com.brickfarm.dao.pointsusagelog;

import java.util.List;

import com.brickfarm.dto.admin.kmh.AdminLogDTO;
import com.brickfarm.dto.admin.syt.AdminCancelDataDTO;
import com.brickfarm.vo.admin.kmh.AdminPointLogVO;
import com.brickfarm.vo.admin.syt.AdminSchedulerPaymentDataVO;
import com.brickfarm.vo.user.psj.UserPointsUsageLogVO;
import com.brickfarm.dto.user.syt.UserPointsUsageLogDTO;

public interface PointsUsageLogDAO {

	// ==[송지영]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[김미형]==========================================================================================================================================

		// 포인트 사용 이력 조회
		List<AdminPointLogVO> selectPointUseLog(AdminLogDTO pointLog) throws Exception;
	// ==================================================================================================================================================
	
	// ==[이경민]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[염세환]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[박상진]==========================================================================================================================================
	// 회원의 포인트 변동 내역 조회
	List<UserPointsUsageLogVO> selectPointsUsageLog(int memberNo) throws Exception;
	// ==================================================================================================================================================
	
	// ==[송영태]==========================================================================================================================================
	// 구매시 포인트 사용 로그 남기기
	int insertPointsUsageLog(UserPointsUsageLogDTO pointsUsageLog) throws Exception;
	// 취소시 포인트 반품된것 로그남기기
	int insertCancelPoint(AdminCancelDataDTO adminCancelData) throws Exception;
	// [스케줄러] 입금만료 취소 포인트 반환
	int insertSchedulerPointLog(AdminSchedulerPaymentDataVO schedulerPaymentData) throws Exception;
	// ==================================================================================================================================================


	
	// ==[김용진]==========================================================================================================================================
	// ==================================================================================================================================================
}
