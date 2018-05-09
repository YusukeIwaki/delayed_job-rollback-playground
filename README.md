# Delayed::Job playground.

モデルのafter_createでベタに通知をしちゃうと、モデルがロールバックされた時に通知はロールバックできなくて詰む。

```
class User 
  after_create :notify_created
  
  def notify_created
    # 通知を送る機能
    # 作るのが面倒なので、RequestBinに `type: notify_created` でアクセスするようにした
  end
  
  def verify
    # 本人確認機能
    # 作るのが面倒なので、RequestBinに `type: identity_verification` でアクセスするようにした
    
    # 成功時には、UserにひもづいてUserIdentityVerificationレコードを作る
    # 失敗時には、例外を投げる
  end
end

class UsersController
  def create
    User.transaction do
      user = User.create!(params.require(:user).permit(...))
      user.verify
    end
  end
end
```

たとえばこれだと、

```
      user = User.create!(params.require(:user).permit(...))
```

の時点で、after_createが呼ばれるので、本人確認に失敗して、最終的にトランザクションのロールバックをしたとしても

`type: notify_created` のリクエストがRequestBinに記録されてしまう。

## Delayed::Job使うとどうなる？

ふつうに考えればafter_commitでやるようにするとか、サービスクラス作るとか、いろいろ手段はあるけど、とりあえず今回はDelayed::Jobの検証が目的なのでDelayed::Jobを使う。

```
class User
  after_create do |record|
    record.delay.notify_created  
  end
```

これにより `notify_created` はいつ実行されるようになるのか？
本人確認に５秒かかったとしても、そのあとで通知されるようになるの？？というのを検証したかった。

結論から言うと、確実に本人確認が済んでトランザクションを抜けた後に、notify_createdが呼ばれるようになった。
本人確認でコケたときには、notify_createdは実行されなくなった。


予想だけど、Delayed::Jobのデキューがafter_commit的な契機で行われているのではないかなと。