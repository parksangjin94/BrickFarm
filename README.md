# BrickFarm_project 

### 제작기간 : 11.07 ~ 12.19 
### 맡은 부분 
  > 마이 페이지 - 배송지 관리, 주문 내역, 주문 상세 조회, 취소/교환/반품 신청, 취소/교환/반품 내역, 리뷰 작성/수정, 쿠폰 내역, 적립금 내역<br>
  > 장바구니
### 개발 스택 
1. Frontend : html, css, js
2. Backend : mybatis, sts
3. Database : mariaDB

### 사이트 맵 
  - 사이트 맵

![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/19ef346c-7ea1-4970-900e-a3ecb7afaf5d)

---
#### DB 설계 
   - 개념적 ERD
     
 ![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/0dd21414-74a8-441f-9b4c-7593250a0e89)


   - 공학적 ERD
     
 ![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/0b41a920-7057-426e-a240-b59da79e3202)




---

### 장바구니(shopping_cart)

![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/c9a6e23f-5553-4ca6-86e8-d0c154fba0f7)

> BrickFarm의 장바구니 기능의 경우는 "BrickFarm의 회원"이 장바구니에 원하는 품목을 담아 두는 기능 입니다.<br><br>
> 즉, BrickFarm에 가입된 이용자만이 사용할 수 있는 기능입니다.<br><br>
> 회원이 장바구니 내에서 선택한 물품을 결제 페이지로 넘겨줘야 하기 때문에 식별하기 위한 shopping_cart_no 를 PK로 사용 하였고<br>
> 어느 회원의 장바구니 인지 식별하기 위해 member 테이블의 PK를 FK로 설정했습니다.<br><br>
> 장바구니 페이지 View에 물품의 정보를 출력하기 위해 product 테이블의 PK를 FK로 설정했습니다. 

---
### ShoppingCart 코드 설계

  ShoppingCartVO

```

public class ShoppingCartVO {

	private int member_no; 
	private int shopping_cart_no;
	private String product_code;
	private int quantity;
	private String product_name;
	private int product_price;
	private	int parts_quantity;
	private String recommend_age;
	private String product_main_image;
	private int upper_category_no;
	private String product_category_name;
	private int stock_quantity;

	private int event_no;
	private String event_name;
	private Date event_start; 
	private Date event_end; 
	private float discount_rate;

}

```
Controller
---
```

 @GetMapping("/shoppingcart")
	public String cart(HttpSession session, HttpServletRequest request, Model model) throws InterruptedException {
		logger.info("마이페이지 - 장바구니 요청");
		session = request.getSession();
		UserMemberVO loginMember = (UserMemberVO) session.getAttribute("loginMemberInfo");
		int memberNo = loginMember.getMember_no();
		try {
			// 장바구니 목록(List)
			List<UserShoppingCartDTO> shoppingCartList = myPageService.getShoppingCartList(memberNo);
			
			if (shoppingCartList.size() == 0) {
				// 장바구니가 비어있을 경우
				return "user/mypage/shoppingcartempty";
			} else {
				model.addAttribute("shoppingCartList", shoppingCartList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "user/mypage/shoppingcart";
	}

```
### 겪었던 문제
1) 장바구니 페이지에서 체크여부에 따라 체크된 품목의 가격 * 수량 이 상품 금액란에 출력 되게 해야 한다.
> 체크된 품목의 총 가격의 합, 체크 해제 시 해당 가격은 상품 금액에서 빠져야 했다. forEach를 이용해 출력 했기 때문에 반복되어 출력된 물품을 구분해줄 무언가가 필요했다. <br>
>
> 해결 > <c:forEach var="shoppingCart" items="${shoppingCartList}" varStatus = "status"> 의 status.index 를 이용, 해당 태그의 id 뒤에${status.index} 를 붙여 구분하도록 했다. 
```

<td>
	<div class="check-box">
		<input id="shoppingCartItem${status.index}" type="checkbox" name="shoppingCartItem" value="${shoppingCart.shopping_cart_no}" onclick="checkedBox(this)">
			<div class="check-box__state check-box__state--primary">
				<label class="check-box__label" for="free-shipping"></label>
			</div>
	</div>
</td>

```
2) 장바구니 페이지에서 수량 변경 후 페이지를 이동했을 시 변경 된 수량이 그대로 남아 있어야 한다.
> 해결 방법으로 2가지 방법을 고려해 보았다.<br>
> 방법 1. 수량 변경이 일어날 때 마다 DB에 해당 변경 값을 저장한다. -> 수량 변경 이벤트 마다 DB를 호출하는 것이 과연 옳을까..? DB에 부담이 될 것이 너무나 당연하다. <br>
> 방법 2. 수량 변경 후 저장하는 버튼을 따로 두어 저장 버튼을 눌렀을 때에 DB에 변경 값을 저장한다. -> 저장 버튼을 누르지 않았을 때에는 저장이 되지 않는다. 저장 버튼을 누르는 수고조차 없애고 싶다.<br>
> 
> 부분적 해결 > 위에 대해 고민 하던 중 수량이 저장되어야 하는 순간은 바로 페이지를 떠나는 순간임을 생각(구매 페이지로 이동하는 것도 해당 되기 때문) 해당 document가 unload 되는 이벤트를 감지하는
> beforeunload 이벤트 사용 결정 하였고 원하는 대로 동작하는 줄 알았으나 페이지를 reload 하는 것에는 대응하지 못하는 문제 발생. <br>
> unload 이벤트를 감지하여 ajax 방식으로 컨트롤러를 호출, 로직을 수행하는 시간과 페이지가 reload되는 시간의 차이에서 문제가 발생했다. 장바구니 페이지를 호출하는 순간 DB의 데이터를 조회해 view에 출력하게 되는데<br>
> 변경된 수량 정보를 DB에 업데이트 하는 로직을 수행하는 속도보다 reload 되는 속도가 더 빨라 DB의 수량은 변경되나 변경되기 이전의 수량을 view에 출력하는 것. <br>
> 이에 대한 해결 방법으로 현재 로컬 스토리지를 이용해 로그인시 로컬 스토리지에 장바구니 테이블의 정보를 조회해 저장하고 이를 이용하는 방법을 모색 중
```

window.addEventListener("beforeunload", function (event) {
  const shoppingCartNoList = [];
  const shoppingCartQuantityList = [];
   for(i = 0 ; i < shoppingCartListlength ; i++) {
	  if($("#shoppingCartItem" + i).val() != null){   
        shoppingCartNoList.push($("#shoppingCartItem" + i).val())
        shoppingCartQuantityList.push($("#productCnt" + i).val())
	  }
   }
    $.ajax({
           type: 'POST',
           url: '/mypage/changeShoppingCartProductCnt',
           data: {
              shoppingCartNoList : shoppingCartNoList,
              shoppingCartQuantityList : shoppingCartQuantityList,
           },
           success: function(response) {
               console.log('데이터 전송 성공: ' + response);
           },
           error: function() {
               console.error('데이터 전송 실패');
           },  
       });
});

```

## View

![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/304c9be2-4321-4a79-9e7e-d20ab30e78fe)

---

### 배송지 관리(member_address_book)

![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/a3e99f71-886c-4199-b2e4-263fa29bdba7)

> 회원이 구매 단계에서 수신지 설정의 편의성을 위한 기능으로 자주 사용하는 수신지를 배송지로 등록하여 관리 할 수 있다.<br><br>
> 가입 단계에서 입력한 주소지가 기본 배송지가 되며 배송지 관리 단계에서 기본 배송지를 변경할 수 있다.<br><br>
> 기본 배송지는 삭제가 불가능 하며, 이외의 배송지를 기본 배송지로 설정한 후 삭제 가능하다.<br><br>
> 배송지 등록/ 수정 / 삭제가 가능하다. 단 기본 배송지로 설정된 한 개의 배송지는 삭제가 불가능 하므로 반드시 1개 이상의 배송지가 존재하게 된다.


### AddressBook 코드 설계

	AddressBookVO

```

public class UserAddressBookVO {
	private int member_address_book_no;
	private int member_no;
	private String address_name;
	private String address;
	private String zip_code;
	private String recipient;
	private String phone_number;
	private String is_default;
}

```
Controller
---

```

	@PostMapping("/addaddresslist")
	public String addaddressPost(@RequestParam("recipient") String recipient, @RequestParam(value = "address_name") String addressName,
			@RequestParam("mobile1") String mobile1, @RequestParam("mobile2") String mobile2, @RequestParam("mobile3") String mobile3,
			@RequestParam("recipient_address") String recipientAddress, @RequestParam("recipient_zip_code") String recipientZipCode,
			@RequestParam("recipient_detail_address") String recipient_detail_address,@RequestParam(name="is-default", required = false) boolean isDefault,
			HttpServletRequest request, HttpSession session
			) {
		logger.info("마이페이지 - (POST)배송지 추가 호출");
		int result = -1;
		session = request.getSession();
		UserMemberVO loginMember = (UserMemberVO)session.getAttribute("loginMemberInfo");
		UserAddressBookVO addedAddress = new UserAddressBookVO();
		// 멤버 no
		addedAddress.setMember_no(loginMember.getMember_no());
		// 배송지 이름
		addedAddress.setAddress_name(addressName);
		// 배송지 주소
		addedAddress.setAddress(recipientAddress+", " + recipient_detail_address);
		// 휴대전화 번호
		addedAddress.setPhone_number(mobile1+"-"+mobile2+"-"+mobile3);
		// 수신자 
		addedAddress.setRecipient(recipient);
		// 배송지 우편번호
		addedAddress.setZip_code(recipientZipCode);
		if(isDefault) {
			addedAddress.setIs_default("Y");
		} else {
			addedAddress.setIs_default("N");
		}
		try {
			result = myPageService.addAddressBook(addedAddress,loginMember.getMember_no());
			if(result > 0) {
				logger.info("주소지 등록 실패");
			} else {
				logger.info("주소지 등록");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/mypage/addresslist";
	}

```

ServiceImpl
---

```

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int addAddressBook(UserAddressBookVO userAdressBookVO, int memberNo) throws Exception {
		int result = -1;
		UserMemberVO loginMember = myPageDAO.selectMemberInfo(memberNo);
		String loginMemberName = loginMember.getMember_name();
		String addressName = userAdressBookVO.getAddress_name();

		if (addressName.equals("")) {
			userAdressBookVO.setAddress_name(loginMemberName + "님 배송지");
		}
		if (userAdressBookVO.getIs_default().equals("Y")) {
			if (addressBookDAO.selectDefaultAddress(memberNo) >= 0) {
				addressBookDAO.updateDefaultAddress(addressBookDAO.selectDefaultAddress(memberNo));
				result = addressBookDAO.insertAddressBook(userAdressBookVO);
			}
		} else {
			result = addressBookDAO.insertAddressBook(userAdressBookVO);
		}
		return result;
	}

```
> 수신지 이름을 설정하지 않은 경우 회원의 이름 + 님 배송지 로 설정되도록 했다.
> 기본 배송지로 설정했을 경우 기존의 기본 배송지의 기본배송지 여부 컬럼을 'N' 으로 변경 후 배송지 정보를 저장한다.
> 기본 배송지로 설정하지 않았을 경우 그냥 저장 한다.


### 겪었던 문제 
1. 도로명 주소 검색 API를 사용하여 구현했으나 도로명 검색 팝업창이 뜬 후 세션이 변경되는 문제가 발생 -> 해당 API 문의 내역을 본 결과 API 에서 제공하는 팝업창을 사용할 시 해당 문제 해결 방법이 없음.<br>
또한 해당 API는 x, y 좌표를 제공하지 않아 추가적인 승인이 필요했음. (주소를 검색할 시 해당 주소의 약도를 출력할 예정)

>해결 > 세션에 영향을 주지 않는 kakao 주소검색 API로 대체. kakao 주소검색 API는 추가적인 승인 없이 x,y 좌표를 제공하기 때문에 약도 출력에도 용이함.

### View
![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/d4ab9b42-0fee-4ec8-984f-917ff1935766)

---

### 주문 상세보기(detailed_order)
![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/1efa37f2-799c-4967-b99e-7cf6450bb42c)

> 각 주문(ordersheet)은 상세 주문(detailed_order)으로 구성되어 있다. 각 상세 주문은 취소, 교환, 반품 신청이 가능하다.<br>
> 특정 주문을 상세 조회 했을 시 해당 주문에 속해있는 상세 주문이 교환, 취소, 반품 여부와 상관없이 출력 되어야 한다. <br>
> 때문에 취소,반품 테이블과 교환 테이블의 정보 역시 조회해 주문 상세보기 view에 출력해 주어야 한다. <br><br>

### UserOrderDetailVO 코드 설계

	UserOrderDetailVO

```

public class UserOrderDetailVO {
	// 주문번호
	private String merchant_uid;
	// 물품 별 상세 주문 번호
	private int detailed_order_no;
	// 주문 일
	private Date order_day;
	// 주문자 송장번호
	private String ordersheet_post_no;
	// 수신자
	private String recipient;
	// 수신지
	private String recipient_address;
	// 수신자 전화번호
	private String recipient_phone;
	// 배송 상태
	private String delivery_state;
	// 총 물품 가격
	private int total_product_price;
	// 할인 적용된 가격
	private int total_discounted_price;
	// 각 상품 가격
	private int detail_price;
	// 각 상품 이름
	private String product_name;
	// 각 상품 이미지
	private String product_main_image;
	// 각 상품 갯수
	private int quantity;
	// 결제 상태
	private String payment_state;
	// 완료 날짜
	private Date order_detailed_complete_date;
	// 각 상품 가격
	private int product_price;
	// 배송비
	private int post_money;
	// 카드 결제 금액
	private int card_pay_money;
	// 현금 결제 금액
	private int cash_pay_money;
	// 포인트 결제 금액
	private int point_pay_money;
	// 환불 금액 
	private int pay_cancel_money;
	// 사용된 쿠폰 이름
	private String coupon_policy_name;
	// 사용된 쿠폰 할인율
	private float discount_rate;
	// 구매자 등급 
	private String member_grade_name;
	// 교환 번호
	private int exchange_no;
	// 교환 운송장 번호
	private String exchange_post_number; 
	// 교환 신청 일
	private Date exchange_application_date;
	// 교환 신청 확인 일
	private Date exchange_check_date;
	// 교환 신청 진행일
	private Date exchange_process_date;
	// 교환 완료일
	private Date exchange_complete_date;
	// 교환 상태
	private String exchange_state;
	// 취소, 반품 사유
	private String cancel_reason;
	// 취소, 반품 금액
	private int cancel_cancel_money;
	// 취소 인지 반품인지
	private String cancel_what;
	// 취소 반품 상태
	private String cancel_state;
	// 취소 반품 신청일
	private Date cancel_application_date;
	// 취소 반품 신청 확인 일
	private Date cancel_check_date;
	// 취소 반품 완료 일
	private Date cancel_complete_date;
}

```

Controller
---

```

	// 주문 상세조회
	@GetMapping("/orderdetail")
	public String orderdetail(HttpServletRequest request, HttpSession session, Model model) throws Exception {
		logger.info("마이페이지 - 주문목록 상세보기 요청");
		// 상세 조회 될 주문의 주문번호
		String merchant_uid = request.getParameter("merchant_uid");
		session = request.getSession();
		UserMemberVO loginMember = (UserMemberVO) session.getAttribute("loginMemberInfo");
		int loginMemberNo = loginMember.getMember_no();

		// 상세 조회 될 주문 (주문, 취소,교환,환불) 모두 맵의 형태로 묶음.
		Map<String, Object> orderInfoMap = myPageService.getMemberTotalOrderInfo(loginMemberNo, merchant_uid);
		
		// 주문 정보
		model.addAttribute("orderInfo", orderInfoMap.get("orderInfo"));
		// 주문 진행중인 목록
		model.addAttribute("orderList", orderInfoMap.get("orderList"));
		// 취소, 반품 진행중인 목록
		model.addAttribute("orderCancelAndReturnList", orderInfoMap.get("orderCancelAndReturnList"));
		// 교환 진행중인 목록
		model.addAttribute("orderExchangeList", orderInfoMap.get("orderExchangeList"));
		
		return "user/mypage/orderdetail";
	}

```

주문번호, 구매자 정보, 결제 정보 와 같은 포괄적인 정보는 주문 정보로 Map에 바인딩 시켜 주었고, 상세 주문 정보, 취소, 교환, 반품 주문 정보는 각 이름에 맞춰 Map에 바인딩 시켜 View에 전달해 주었다. 

주문 정보 조회
---

	DetailedOrderMapper.xml

```

<!-- 상세 주문의 정보(취소,교환,환불 미포함) -->
	<select id="selectOrder" resultType="com.brickfarm.dto.user.psj.UserOrderDTO">
		SELECT 	
		od.merchant_uid,
		od.detailed_order_no, 
		od.discounted_price, 
		od.quantity, 
		od.payment_state, 
		od.complete_date,
	        od.product_price,
	        od.product_code,
		p.product_name, 
		p.product_main_image,
	        pr.detailed_order_no AS review_detailed_order_no
        FROM
        	detailed_order od LEFT JOIN product p
		ON od.product_code = p.product_code
        LEFT JOIN product_review pr ON
		od.detailed_order_no = pr.detailed_order_no
        WHERE
		od.merchant_uid = #{merchant_uid} AND
		od.payment_state NOT IN('취소', '반품','교환');
	</select>

```

취소, 반품 정보 조회
---

 	CancellationReturnMapper.xml

```

<!-- 상세주문 정보(취소,반품) -->
	<select id="selectCancelAndReturnOrderInfo"
		resultType="com.brickfarm.dto.user.psj.UserCancelAndReturnOrderDTO">
		SELECT
		od.merchant_uid,
		od.detailed_order_no, 
		od.discounted_price, 
		od.quantity, 
		od.payment_state, 
		od.complete_date,
	        od.product_price,
	        od.product_code,
		p.product_name, 
		p.product_main_image,
		pay.post_money,
		pay.point_pay_money,
		pay.total_pay_money,
		pay.total_discounted_price,
	        c.reason AS cancel_reason,
	        c.state AS cancel_state,
	        c.application_date AS cancel_application_date,
	        c.check_date AS cancel_check_date,
	        c.complete_date AS cancel_complete_date,
	        c.add_post_money AS cancel_add_post_money,
		c.cancel_money,
	        c.what,
	        c.negligence
        FROM
	        detailed_order od
	        INNER JOIN payment pay ON od.merchant_uid = pay.merchant_uid
        LEFT JOIN product p
		ON od.product_code = p.product_code
		LEFT JOIN cancellation_return c ON
		od.detailed_order_no = c.detailed_order_no
        WHERE
		od.merchant_uid = #{merchant_uid} and
		od.payment_state IN('취소', '반품'); 
	</select>

```

교환 정보 조회
---

	ExchangeMapper.xml

```

<!-- 상세 주문 정보(환불) -->
	<select id="selectExchangeOrderInfo"
		resultType="com.brickfarm.dto.user.psj.UserExchangeOrderDTO">
		SELECT
		od.merchant_uid,
		od.detailed_order_no, 
		od.discounted_price, 
		od.quantity, 
		od.payment_state, 
		od.complete_date,
	        od.product_price,
	        od.product_code,
		p.product_name, 
		p.product_main_image,
		ex.reason AS exchange_reason,
	        ex.post_number AS exchange_post_number,
	        ex.state AS exchange_state,
		ex.application_date AS exchange_application_date,
	        ex.check_date AS exchange_check_date,
	        ex.process_date AS exchange_process_date,
	        ex.complete_date AS exchange_complete_date
        FROM
        	detailed_order od LEFT JOIN product p
		ON od.product_code = p.product_code
		LEFT JOIN exchange ex ON
		od.detailed_order_no = ex.detailed_order_no
        WHERE
		od.merchant_uid = #{merchant_uid} AND
		od.payment_state = '교환';      
	</select>

```

---
### View
![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/4c967adf-530a-4470-bfe2-f4052d28eac1)


### 구매 확정

![image](https://github.com/parksangjin94/BrickFarm/assets/89382405/e8428a04-7d50-48f7-bef8-cbc5cb4813c4)

> 쿠폰, 적립금이 주문 테이블에 컬럼으로 존재하는데 
> 상세 주문에는 존재하지 않아서 식별 불가, 결제테이블의 컬럼을 가지고 적립금을 지금해야 하는데 결제<br><br>
> 테이블은 주문과 연결, 상세 주문건에 대해 적립금을 지급해야하는 것이 아니라 주문에 연결된 
> 결제테이블을 기준으로 적립금을 지급해야 하는 문제 발생 <br><br>

> 구매 확정시 수행될 로직<br>
> 1. 해당 상세 주문의 상태 변경(완료) <br>
> 2. 해당 상세 주문이 속한 주문의 이외 상세 주문들의 상태가 완료 인지 조회 <br>
> 3-1. 이외의 상세 주문 중 완료가 아닌 상세 주문이 있을 경우 포인트 적립 X <br>
> 3-2. 이외의 상세 주문의 상태가 모두 완료인 경우 포인트 적립 <br>

Controller
---

```

// 상품 구매 확정
	@PostMapping("/order/confirmorder")
	public ResponseEntity<String> confirmorder(@RequestParam("modalProductDetailedOrderNo") int detailedOrderNo,
			@RequestParam("priceNumber") int priceNumber, @RequestParam("merchantUid") String merchantUid,
			HttpSession session, HttpServletRequest request) {
		logger.info("마이페이지 - 주문확정 요청");
		session = request.getSession();
		UserMemberVO loginMember = (UserMemberVO) session.getAttribute("loginMemberInfo");
		Map<String, Object> confirmOrderInfo = new HashMap<String, Object>();
		int loginMemberNo = loginMember.getMember_no();
		// 상품의 상태, 회원의 포인트 처리에 필요한 데이터를 맵에 바인딩
		confirmOrderInfo.put("loginMemberNo", loginMemberNo);
		confirmOrderInfo.put("detailedOrderNo", detailedOrderNo);
		confirmOrderInfo.put("priceNumber", priceNumber);
		confirmOrderInfo.put("merchantUid", merchantUid);
		try {
			// 구매 확정시 수행될 로직 처리
			int result = myPageService.modifyOrderConfirm(confirmOrderInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<String>("success", HttpStatus.OK);
	}

```

> 상세 주문의 상태, 포인트 적립을 위한 parameter들을 Map에 바인딩 해준 후 Service단에 넘김.


ServiceImpl
---

```

@Override
	@Transactional(rollbackFor = Exception.class)
	public int modifyOrderConfirm(Map<String, Object> confirmOrderInfo) throws Exception {
		int result = -1;
		// 주문확정 된 상품의 상태 변경
		result = detailedOrderDAO.updateDetailedOrderPaymentStateByOrderConfirm(confirmOrderInfo);
		if (result > 0) {
			// 해당 주문의 상세 주문번호 조회
			List<Integer> detailedOrderNoList = detailedOrderDAO.selectDetailedOrderNoList(confirmOrderInfo);
			System.out.println("해당 주문의 상세 주문 번호 목록 : " + detailedOrderNoList.toString());
			System.out.println("해당 주문의 모든 상세 주문 개수 : " + detailedOrderNoList.size());
			
			// 해당 주문의 구매 확정 상세주문 개수 조회
			int completeDetailedOrderCount = detailedOrderDAO.selectCompleteDetailedOrderCount(confirmOrderInfo);
			System.out.println("해당 주문의 확정 상태 상세 주문 개수 : " + completeDetailedOrderCount);
			
			// 해당 주문의 취소,반품 완료 상세 주문 개수 조회 
			int completeCancelDetailedOrderCount = detailedOrderDAO.selectCompleteCancelDetailedOrderCount(detailedOrderNoList);
			System.out.println("해당 주문의 취소, 반품 완료 주문 개수 : " + completeCancelDetailedOrderCount);
			
			// 해당 주문의 교환 완료 상세 주문 개수 조회
			int completeExchangeDetailedOrderCount = detailedOrderDAO.selectCompleteExchangeDetailedOrderCount(detailedOrderNoList);
			System.out.println("해당 주문의 교환 완료 주문 개수 : " + completeExchangeDetailedOrderCount);
			
			// 해당 주문의 상태가 완료인 모든 상세 주문의 개수
			int totalCompleteDetailedOrderCount = completeDetailedOrderCount + completeCancelDetailedOrderCount + completeExchangeDetailedOrderCount;
			System.out.println("완료 상태인 모든 상세 주문의 개수 : " + totalCompleteDetailedOrderCount);
			// 해당 주문의 실 결제 금액(현금 + 카드)
			int actualPaymentAmount = paymentDAO.selectActualPaymentAmount(confirmOrderInfo);
			System.out.println("총 결제 금액 : " + actualPaymentAmount);
			confirmOrderInfo.put("actualPaymentAmount", actualPaymentAmount);
			if (actualPaymentAmount > 0) {
				if (detailedOrderNoList.size() == totalCompleteDetailedOrderCount) {
					// 주문한 회원의 포인트 변동 로그 작성
					result = pointsAccuralLogDAO.insertPointsAccrualLogByOrderConfirm(confirmOrderInfo);
					if (result > 0) {
						// 주문한 회원의 총 보유 포인트 변경
						result = memberDAO.updateMemberAccrualAmountByConfirmOrder(confirmOrderInfo);
						if (result > 0) {
							// 주문의 총 완료날짜 업데이트
							result = orderSheetDAO.updateOrdersheetTotalCompleteDate(confirmOrderInfo);
							if (result <= 0) {
								System.out.println("주문의 총 완료날짜 업데이트 실패");
							}
						} else {
							System.out.println("주문한 회원의 총 보유 포인트양 변경 실패 ");
						}
					} else {
						System.out.println("주문한 회원의 포인트 변동 로그 작성 실패");
					}
				} else {
					System.out.println("상태가 확정이 아닌 주문이 존재함");
				}
			} else {
				System.out.println("전 액 포인트로 결제한 주문");
			}

		} else {
			System.out.println("주문확정 된 상품의 상태 변경 실패");
		}
		return result;
	}

```

> 주문 확정 요청이 들어온 상세 주문의 상태를 변경 한 후, 해당 상세 주문이 속해 있는 주문번호의 총 상세 주문 갯수를 조회 한다. <br>
> 이 후 상태가 완료인 상세 주문 갯수, 취소 / 교환 / 반품 주문 정보 갯수를 조회해 상태가 완료인 상세 주문 총 갯수를 해당 주문 번호의 상세 주문 갯수와 비교한다. <br>
> 해당 주문 번호의 총 상세 주문 갯수 == 완료 상태인 상세 주문의 총 갯수 라면 포인트 적립 로직을 수행한다.


아쉬운 점
--- 
API적인 관점에서는 내가 원하는 방향으로 정상적으로 작동을 하나, 아쉬운 점은 DB설계가 미숙해 효율적이지 않은 테이블 구조와, 코드적인 부분에서 만족스럽지 않은 로직들이 생겨난 점이 아쉽다. 
