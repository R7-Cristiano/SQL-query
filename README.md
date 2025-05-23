# 📘 SQL 실습 프로젝트

MariaDB 기반 SQL 실습을 위한 예제 테이블 생성, 더미 데이터 삽입, 실습 쿼리를 포함합니다.

## 📁 파일 구성

- `sql_practice_problems.sql`  
  └ 테이블 생성, INSERT문, 문제 1~10 SQL 쿼리 포함

## ✅ 실습 주제

| 문제 번호 | 주제 |
|-----------|------|
| 문제 3 | 상품별 총 판매 수량 조회 |
| 문제 4 | Gold 등급 고객이 구매한 상품 및 수량 |
| 문제 6 | 카테고리별 평균 단가 계산 |
| 문제 7 | 주문하지 않은 고객 조회 (`LEFT JOIN`, `NOT EXISTS`) |
| 문제 9 | 할인율 반영 최종 지불 금액 계산 |
| 문제 10 | 매출 상위 상품 조회 (TOP1 + 동률 포함) |

## 🛠️ 계획
- 쿼리 심화문제 풀이
- ERD 설계도
- 쿼리별 설명 문서 `.md`로 분리 정리

## 🙋 작성자
- GitHub: [R7-Cristiano](https://github.com/R7-Cristiano)

## 📘 테이블 정의서 

### 1. `grades` – 고객 등급 정보

| 컬럼명        | 타입          | 제약조건    | 설명       |
|---------------|---------------|-------------|------------|
| grade_id      | INT           | PK          | 등급 ID    |
| grade_name    | VARCHAR(20)   | NOT NULL    | 등급명     |
| discount_rate | DECIMAL(5,2)  |             | 할인율 (%) |

---

### 2. `customers` – 고객 정보

| 컬럼명     | 타입         | 제약조건            | 설명         |
|------------|--------------|---------------------|--------------|
| customer_id| INT          | PK                  | 고객 ID      |
| name       | VARCHAR(50)  | NOT NULL            | 고객 이름    |
| gender     | CHAR(1)      | CHECK ('M','F')     | 성별         |
| age        | INT          |                     | 나이         |
| grade_id   | INT          | FK → grades         | 고객 등급 ID |

---

### 3. `products` – 상품 정보

| 컬럼명    | 타입          | 제약조건 | 설명     |
|-----------|---------------|----------|----------|
| product_id| INT           | PK       | 상품 ID  |
| name      | VARCHAR(50)   | NOT NULL | 상품명   |
| category  | VARCHAR(20)   |          | 카테고리 |
| price     | DECIMAL(10,2) | NOT NULL | 단가     |

---

### 4. `orders` – 주문 정보

| 컬럼명       | 타입          | 제약조건              | 설명           |
|--------------|---------------|-----------------------|----------------|
| order_id     | INT           | PK                    | 주문 ID        |
| customer_id  | INT           | FK → customers        | 주문 고객 ID   |
| order_date   | DATE          | NOT NULL              | 주문 날짜      |
| order_amount | DECIMAL(10,2) |                       | 주문 총액      |

---

### 5. `order_items` – 주문 상세

| 컬럼명        | 타입         | 제약조건               | 설명         |
|---------------|--------------|------------------------|--------------|
| order_item_id | INT          | PK                     | 주문 상세 ID |
| order_id      | INT          | FK → orders            | 주문 ID      |
| product_id    | INT          | FK → products          | 상품 ID      |
| quantity      | INT          | NOT NULL               | 주문 수량    |



