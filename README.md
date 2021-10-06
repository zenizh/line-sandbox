# README

## 認可フロー

### 1-a. 一般的に想定される認可フロー

```plantuml
@startuml

autonumber

actor ユーザー as User
participant アプリ as App
database 認可サーバー as Server

User -> App ++ : ログインボタンをクリック
App -> Server ++ : 認可用URLにアクセス
User <- Server : ログイン画面を表示
User -> Server : ログイン
App <- Server : コールバックURLにリダイレクト
App -> Server : アクセストークンをリクエスト
App <- Server -- : アクセストークンを返却
User <- App -- : 画面を表示

@enduml
```

### 1-b. 悪意のあるアプリによる攻撃フロー

```plantuml
@startuml

autonumber

actor ユーザー as User
participant アプリ as App
participant 悪意のあるアプリ as Malware #ffaaaa
database 認可サーバー as Server

User -> App ++ : ログインボタンをクリック
App -> Server --++ : 認可用URLにアクセス
User <- Server : ログイン画面を表示
User -> Server : ログイン
Malware <- Server ++ #ffaaaa : コールバックURLにリダイレクト
autonumber stop
App x-- Server : リダイレクトされない
autonumber resume
Malware -> Server : アクセストークンをリクエスト
Malware <- Server -- : アクセストークンを返却
User <- Malware -- : 画面を表示

@enduml
```

### 2-a. PKCE対応の認可フロー

```plantuml
@startuml

autonumber

actor ユーザー as User
participant アプリ as App
database 認可サーバー as Server

User -> App ++ : ログインボタンをクリック
App -> App : code_verifier, code_challengeを生成
App -> Server --++ : 認可用URLにアクセス
Server -> Server : code_challengeを保管
User <- Server : ログイン画面を表示
User -> Server : ログイン
App <- Server ++ : コールバックURLにリダイレクト
App -> Server : アクセストークンをリクエスト
note right App : 2で生成したcode_verifierを含める
Server -> Server : code_verifierを検証
App <- Server -- : アクセストークンを返却
User <- App : 画面を表示

@enduml
```

### 2-b. PKCE対応における攻撃フロー

```plantuml
@startuml

autonumber

actor ユーザー as User
participant アプリ as App
participant 悪意のあるアプリ as Malware #ffaaaa
database 認可サーバー as Server

User -> App ++ : ログインボタンをクリック
App -> App : code_verifier, code_challengeを生成
App -> Server --++ : 認可用URLにアクセス
Server -> Server : code_challengeを保管
User <- Server : ログイン画面を表示
User -> Server : ログイン
Malware <- Server ++ #ffaaaa : コールバックURLにリダイレクト
Malware -> Server : アクセストークンをリクエスト
Server -> Server : code_verifierを検証
note left Server
code_verifierが不正なので
検証に失敗する
end note
Malware x-- Server -- : アクセストークンの取得失敗

@enduml
```

### Usage

```ruby
code_verifier = SecureRandom.alphanumeric(64)
code_challenge = Base64.urlsafe_encode64(OpenSSL::Digest::SHA256.digest(code_verifier), padding: false)
```

See: https://qiita.com/nobuo_hirai/items/0fdd27d3a43161815da5