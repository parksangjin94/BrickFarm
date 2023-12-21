# BrickFarm_project 

### 제작기간 : 10.07 ~ 12.01 
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
> 해결 방법으로 2가지 방법을 고려해 보았다.
> 방법 1. 수량 변경이 일어날 때 마다 DB에 해당 변경 값을 저장한다. -> 수량 변경 이벤트 마다 DB를 호출하는 것이 과연 옳을까..? DB에 부담이 될 것이 너무나 당연하다.
> 방법 2. 수량 변경 후 저장하는 버튼을 따로 두어 저장 버튼을 눌렀을 때에 DB에 변경 값을 저장한다. -> 저장 버튼을 누르지 않았을 때에는 저장이 되지 않는다. 저장 버튼을 누르는 수고조차 없애고 싶다.
> 
> 부분적 해결 > 위에 대해 고민 하던 중 수량이 저장되어야 하는 순간은 바로 페이지를 떠나는 순간임을 생각(구매 페이지로 이동하는 것도 해당 되기 때문) 해당 document가 unload 되는 이벤트를 감지하는 <br>
> beforeunload 이벤트 사용 결정 하였고 원하는 대로 동작하는 줄 알았으나 페이지를 reload 하는 것에는 대응하지 못하는 문제 발생. <br>
> unload 이벤트를 감지하여 ajax 방식으로 컨트롤러를 호출, 로직을 수행하는 시간과 페이지가 reload되는 시간의 차이에서 문제가 발생했다. 장바구니 페이지를 호출하는 순간 DB의 데이터를 조회해 view에 출력하게 되는데<br>
> 변경된 수량 정보를 DB에 업데이트 하는 로직을 수행하는 속도보다 reload 되는 속도가 더 빨라 DB의 수량은 변경되나 변경되기 이전의 수량을 view에 출력하는 것. 
> 이에 대한 해결 방법을 모색하고 있으나 현재 해결하지 못한 상황. 의도와 같이 수행되고 있는 페이지는 쿠팡의 장바구니가 있다.
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


