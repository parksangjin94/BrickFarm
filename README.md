# BrickFarm_project 

### 제작기간 : 10.07 ~ 12.01 
### 맡은 부분 
  > 마이 페이지 - 배송지 관리, 주문 내역, 주문 상세 조회, 취소/교환/반품 신청, 취소/교환/반품 내역, 리뷰 작성/수정, 쿠폰 내역, 적립금 내역
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

> BrickFarm의 장바구니 기능의 경우는 "BrickFarm의 회원"이 장바구니에 원하는 품목을 담아 두는 기능 입니다.
> 즉, BrickFarm에 가입된 이용자만이 사용할 수 있는 기능입니다.
> 회원이 장바구니 내에서 선택한 물품을 결제 페이지로 넘겨줘야 하기 때문에 식별하기 위한 shopping_cart_no 를 PK로 사용 하였고
> 어느 회원의 장바구니 인지 식별하기 위해 member 테이블의 PK를 FK로 설정했습니다.
> 장바구니 페이지 View에 물품의 정보를 출력하기 위해 product 테이블의 PK를 FK로 설정했습니다. 

