package com.brickfarm.dao.pointsaccurallog;

import java.util.List;
import java.util.Map;

import com.brickfarm.dto.admin.kmh.AdminLogDTO;
import com.brickfarm.vo.admin.kmh.AdminPointLogVO;
import com.brickfarm.vo.user.psj.UserPointsAccrualLogVO;

public interface PointsAccuralLogDAO {

	// ==[송지영]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[김미형]==========================================================================================================================================
		
		// 포인트 적립 로그
		List<AdminPointLogVO> selectPointAccrualLog(AdminLogDTO pointLog);
	// ==================================================================================================================================================

	
	// ==[이경민]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[염세환]==========================================================================================================================================
	// ==================================================================================================================================================
	
	// ==[박상진]==========================================================================================================================================
		// 포인트 적립 로그 조회
		List<UserPointsAccrualLogVO> selectPointsAccrualLog(int memberNo) throws Exception;
		// 포인트 적립 로그 추가(구매확정)
		int insertPointsAccrualLogByOrderConfirm(Map<String, Object> confirmOrderInfo) throws Exception;
		// 포인트 적립 로그 추가(일반 리뷰 작성)
		int insertPointsAccrualLogByWriteReview(int memberNo, String merchant_uid) throws Exception;
		// 포인트 적립 로그 추가(포토 리뷰 작성)
		int insertPointsAccrualLogByWritePhotoReview(int memberNo, String merchant_uid) throws Exception;
	// ==================================================================================================================================================
	
	// ==[송영태]==========================================================================================================================================
		int insertPointAccrualLogByCompletion(List<String> haveToMerchantUidList) throws Exception;
	// ==================================================================================================================================================
	
	// ==[김용진]==========================================================================================================================================
	// ==================================================================================================================================================
}