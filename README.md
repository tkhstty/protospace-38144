# README



# テーブル設計

## users テーブル
| Column             | Type        | Option             |
| ------------------ | ----------- | ------------------ |
| email              | string      | null:false, UNIQUE |
| encrypted_password | string      | null:false         |
| name               | string      | null:false         |
| profile            | text        | null:false         |
| occupation         | text        | null:false         |
| position           | text        | null:false         |

### Association
- has_many :prototypes
- has_many :comments


## prototypes テーブル
| Column             | Type        | Option                       |
| ------------------ | ----------- | ---------------------------- |
| title              | string      | null:false                   |
| catch_copy         | text        | null:false                   |
| concept            | text        | null:false                   |
| user               | reference   | null:false, foreign_key:true |

### Association
- has_many :comments
- belongs_to :user


## comments テーブル
| Column             | Type        | Option                       |
| ------------------ | ----------- | ---------------------------- |
| content            | text        | null:false                   |
| prototype          | reference   | null:false, foreign_key:true |
| user               | reference   | null:false, foreign_key:true |

### Association
- belongs_to user
- belongs_to prototype