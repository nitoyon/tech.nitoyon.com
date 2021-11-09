---
layout: post
title: Japanese-English translation table of Game Builder Garage
lang: en
tags: game-builder-garage
alternate:
  lang: ja_JP
  url: /ja/blog/2021/11/10/game-builder-garage-glossary/
---
I have summarized the terms of "Game Builder Garage for Nintendo Switch" in a Japanese-English translation table.

I referred to the following pages, but neither was perfect. So in the end, I summarized this table by checking my Switch.

* [ナビつき！ つくってわかる　はじめてゲームプログラミング：ノードン機能一覧 | Nintendo Switch | 任天堂](https://www.nintendo.co.jp/switch/awuxa/reference/contents/index.html)
* [Nodon | Game Builder Garage Wiki | Fandom](https://game-builder-garage.fandom.com/wiki/Nodon)

# Basic Terms

| Japanese | English |
|--------|-----|
|ナビつき! つくってわかる はじめてゲームプログラミング | Game Builder Garage |
|ノードン|Nodon|
|ナビつきレッスン|Interactive Lessons|
|フリープログラミング|Free Programming|
|ノードンガイド|Alice's Guide|

The following is a summary of terms related to Nordon.

# 入力 : Input

## 定数ノードン : Constant Nodon

| Japanese | English |
|--------|-----|
|いくつを出力する？|Output Value|

## ボタンノードン : Button Nodon

| Japanese | English |
|--------|-----|
|おしたか|If pressed|
|出力するタイミング (おしたしゅんかん / おしていたらずっと)|Output Timing (On press / While pressed)|
|コントローラーばんごう (じどう)|Controller Number (Auto)|

## スティックノードン : Stick Nodon

| Japanese | English |
|--------|-----|
|上下|Up/Down|
|左右|Left/Right|
|たおした量|Amount tilted|
|コントローラーばんごう (じどう)|Controller Number (Auto)|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|はんのうする方向|Direction of Response|
|どちらでも|Any|
|どちらのスティック？|Which Stick|

## タッチスクリーン : Touch Screen
### タッチしたらノードン : If-Touched Nodon

| Japanese | English |
|--------|-----|
|タッチしたか|If touched|
|出力するタイミング (タッチしたしゅんかん / タッチしていたらずっと)|Output Timing (On touch / While touched)|
|どこをタッチしたときに出力する？ (このノードン / どこでも)|Touch Where to Output? (This Nodon / Anywhere)|

### タッチ位置ノードン : Touch-Position Nodon

| Japanese | English |
|--------|-----|
|X|X|
|Y|Y|

## モーション : Motion
### ふりノードン : Shake Nodon

| Japanese | English |
|--------|-----|
|ふりの勢い|Momentum|
|どれをチェックする？ (じどう)|Check What? (Auto)|
|コントローラーばんごう|Controller Number|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|はんのうする方向 (どちらでも)|Direction of Response (Any Direction)|

### かたむきノードン : Tilt Nodon

| Japanese | English |
|--------|-----|
|Yリセット|Y reset|
|かたむき角度|Tilt angle|
|どれをチェックする？|Check What?|
|コントローラーばんごう|Controller Number|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|回転軸|Axis of Rotation|
|モード (かたむき / 回転角度)|Mode (Tilt / Angle of rotation)|

### オモテ面が上を向いたらノードン : If-Face-Up Nodon

| Japanese | English |
|--------|-----|
|上向き量|Facing up|
|どれをチェックする？|Check What?|
|コントローラーばんごう|Controller Number|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|オモテとする面 (左 / 右 / 前 / 後 / 上 / 下)|Which Side Should Face Up? (Left/ Right / Front / Back / Top / Bottom)|

### 回転速度ノードン : Rotation-Speed Nodon

| Japanese | English |
|--------|-----|
|まわした速さ|Rotation speed|
|どれをチェックする？|Check What?|
|コントローラーばんごう|Controller Number|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|回転軸 (X / Y / Z / どちらでも)|Axis of Rotation (X / Y / Z / Any)|
|はんのうする方向 (＋ / － / ±)|Direction of Response ( + / - / +/-)

### モーションIRカメラノードン : IR Motion Camera Nodon

| Japanese | English |
|--------|-----|
|うつった数|Captured portions|
|コントローラーばんごう|Controller Number|
|にんしきキョリ (赤外線オフ / ちかくだけ / ふつう / とおくまで)|Distance to Recognize (IR off / Near / Normal / Near & far)|

## ゲーム内の変化 : State Change
### モノがこわれたしゅんかんノードン : Object-Break Nodon

| Japanese | English |
|--------|-----|
|こわれた数|Broken count|
|何をチェックする？|Check What?|

### スタートしたしゅんかんノードン : On-Start Nodon

| Japanese | English |
|--------|-----|
|スタートしたか|If started|

# 中間 : Middle
## けいさんノードン : Calculator Nodon

| Japanese | English |
|--------|-----|
|入力１|Input 1|
|入力２|Input 2|
|けいさん結果|Result|
|けいさん方法|Calculation Method|
|＋|＋|
|－|－|
|×|×|
|÷|÷|

## へんかん : Convert
### マッピングノードン : Map Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|出力|Output|
|入力はんい|Input Range|
|出力はんい|Output Range|
|はんい制限 (はんい制限する / はんい制限しない)|Range Restriction (Enable / Disable)|

### デジタル化ノードン : Digitize Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|出力|Output|
|1.00 をいくつにわける？|Number of Stages|

### ルートノードン : Square-Root Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|出力|Output|

### 絶対値ノードン : Absolute-Value Nodon

Same as square-root nodon.

### ＋－反転 : +− Inversion Nodon

Same as square-root nodon.

### ０から変わったしゅんかんノードン : Trigger-from-0 Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|変わったか|If changed|

## 角度のけいさん : Angle Calculation

### 位置を角度にノードン : Position → Angle Nodon

| Japanese | English |
|--------|-----|
|横位置|Horizontal position|
|縦位置|Vertical position|
|角度|Angle|

### 角度を位置にノードン : Position → Angle Nodon

Same as position → angle nodon.

### 角度の差ノードン : Angle-Difference Nodon

| Japanese | English |
|--------|-----|
|角度１|Angle 1|
|角度２|Angle 2|
|差|Difference|

## くらべるノードン : Comparison Nodon

| Japanese | English |
|--------|-----|
|入力１|Input 1|
|入力２|Input 2|
|くらべた結果|Result|
|どうやってくらべる？ (= / > / < / ≧ / ≦)|Comparison Method (= / > / < / ≥ / ≤)|

## ロジック : Logic

### AND ノードン : AND Nodon

| Japanese | English |
|--------|-----|
|入力１|Input 1|
|入力２|Input 2|
|出力|Output|

### NOT ノードン : NOT Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|出力|Output|

## フラグ・カウンター・ランダム : Flag/Counter/Random

### フラグノードン : Flag Nodon

| Japanese | English |
|--------|-----|
|オン|On|
|オフ|Off|
|フラグがオンか|Flag is on|

### カウンターノードン : Counter Nodon

| Japanese | English |
|--------|-----|
|増やす|Count up|
|減らす|Count down|
|リセット|Reset|
|カウント|Count|
|スタートのときのカウント|Starting Value|
|モード (制限なし / はんい制限 / ループ / おうふく))|Mode (No limit /Count range Loop / Bounce)|
|カウントはんい|Count Range|
|カウントするタイミング (０から変わったしゅんかん / ０以外のときずっと)|Count Timing (On change from 0 / While not 0)|

### ランダムノードン : Random Nodon

| Japanese | English |
|--------|-----|
|？|?|
|リセット|Reset|
|ランダムな数|Random number|
|数を更新するタイミング  (０から変わったしゅんかん / ０以外のときずっと)|Update Timing (On change from 0 / While not 0)|
|出力はんい|Output Range|

## タイマーノードン : Timer Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|出力|Output|
|何秒後に出力するか|Output after How Many Seconds?|
|出力しつづける秒数|Continue Output for How Long?|

## スポイトノードン : Bull's-Eye Nodon

| Japanese | English |
|--------|-----|
|マーカー量|Marker amount|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|スポイントのかたち (円 / 長方形)|Bull's-Eye Shape (Circle / Rectangle)|

## プログラムのせいり : Program Layout

### ワイヤーワープ入口ノードン : Wormhole-Entrance Nodon

| Japanese | English |
|--------|-----|
|入口|Entrance|
|ワープID|Wormhole ID|

### ワイヤーワープ出口ノードン : Wormhole-Exit Nodon

| Japanese | English |
|--------|-----|
|出口|Exit|
|ワープID|Wormhole ID|

### 自分メモノードン : Comment Nodon

| Japanese | English |
|--------|-----|
|自分メモ|Comment|

# 出力 : Output

## 音をならすノードン : Play-Sound Nodon

| Japanese | English |
|--------|-----|
|効果音を鳴らす|Play SFX|
|楽器を鳴らす|Play Instrument|
|再生|Play|
|音量|Volume|
|高さ|Pitch|
|鳴らす音|Sound Played|

## BGMノードン : Background-Music Nodon

| Japanese | English |
|--------|-----|
|効果音を鳴らす|Play SFX|
|楽器を鳴らす|Play Instrument|
|再生|Play|
|音量|Volume|
|高さ|Pitch|
|曲|Theme|
|メロディ|Melody|
|メイン伴奏|Main Accompaniment|
|サブ伴奏|Sub Accompaniment|
|リズム|Rhythm|

## しんどうノードン : Vibration Nodon

| Japanese | English |
|--------|-----|
|しんどう強さ|Vibration strength|
|コントローラーばんごう|Controller Number|
|どっちのコントローラー？|Which Controller|
|出力しつづける秒数|Continue Output for How Long?|
|周波数|Frequency|

## ワールドを変化 : Change World

### 重力をへらすノードン : Reduce-Gravity Nodon

| Japanese | English |
|--------|-----|
|へらす量|Reduction|

### 時間を止めるノードン : Slow-Time Nodon

| Japanese | English |
|--------|-----|
|止める量|Slowdown amount|

## リトライ・おわる・きりかえ : Retry/End/Swap

### リトライノードン : Retry Nodon

| Japanese | English |
|--------|-----|
|リトライ|Retry|
|ワイプのみため (ふつう / まばたき / まんまる)|Transition Effect (Default / Blink / Shot)|

### ゲームおわるノードン : End-Game Nodon

| Japanese | English |
|--------|-----|
|おわる|Exit|

### ゲームきりかえノードン : Swap-Game Nodon

| Japanese | English |
|--------|-----|
|きりかえる|Swap|
|きりかえ元より|Swap from value|
|きりかえ方法 (キーワード / きりかえ元へもどる)|Swap Type (Keyword / Back to previous)|
|きりかえ先のキーワード|Swap-Target Keyword|
|このゲームのキーワード|Game Keyword|
|きりかえのみため (タイトルあり / タイトルなし)|Transition Appearance (With title / Without title)|

## その他 : Other

### マーカー表示ノードン : Marker-Display Nodon

| Japanese | English |
|--------|-----|
|入力|Input|
|表示方法 (動く / のびる / 線 / まわる / 円グラフ / 透明度 / 点滅)|Light Up How? (Move / Extend / Line / Rotate / Pie chart / Opacity / Flash)|
|スポイト反応 (スポイトできる / スポイトできない)|Activates Bull's-Eye Nodon? (Bull's-eye compatible / Bull's-eye incompatible)|

### 2Dマーカー表示ノードン : 2D-Marker-Display Nodon

| Japanese | English |
|--------|-----|
|X|X|
|Y|Y|
|スポイト結果|Result|
|出力 (デジタル / アナログ)|Output (Digital / Analog)|
|はんい|Range|
|おおきさ|Size|
|スポイト反応 (スポイトできる / スポイトできない)|Activates Bull's-Eye Nodon? (Bull's-eye compatible / Bull's-eye incompatible)|

### ずっとマーカー表示ノードン : Continuous-Marker-Display Nodon

| Japanese | English |
|--------|-----|
|スポイト反応 (スポイトできる / スポイトできない)|Activates Bull's-Eye Nodon? (Bull's-eye compatible / Bull's-eye incompatible)|

### 赤外線ライトをひからせるノードン : IR-Light Nodon

| Japanese | English |
|--------|-----|
|ひからせる|Light up|
|コントローラーばんごう|Controller Number|
|出力しつづける秒数|Continue Output for How Long?|

# モノ : Objects

Common terms are listed here.

| Japanese | English |
|--------|-----|
|ふるまい|Properties|
|見える|Visible|
|当たる|Solid|
|動く|Movable|
|こわれる|Destructible|
|こわす|Destructive|
|その他|Other|
|当たった/こわれたときに音を鳴らす？ (鳴らす / 鳴らさない)|Play Sound When Hit/Destroyed? (Play / Don't Play)|
|てノードンでつかめる？ (つかめる / つかめない)|Can Be Grabbed by Hand Nodon? (Can be grabbed / Can't be grabbed)|
|そざい (ふつう / ポヨポヨ / ツルツル / ふわふわ / 無重力)|Material (Normal / Bouncy / Slippery / Floaty / Zero gravity)|
|れんけつかたさ (ふつう / バネバネ / 180°回転)|Connection Type (Normal / Springy / 180° Rotation)|
|れんけつ面 (じどう / くわしく)|Connection Point (Auto / Manual)|
|自分のれんけつ面 (じどう)|Own Connection Point (Auto)|
|れんけつ先の面 (じどう)|Own Connection Point (Auto)|
|いどうきじゅん (ワールド / ローカル / カメラ)|Frame of Reference for Motion (World / Local / Camera)|
|いどうスピード|Movement Speed|
|ジャンプ力|Jump Strength|
|おおきさ|Size|
|位置|Position|
|回転|Rotation|

## キャラクター : Characters

### ヒトノードン : Person Nodon

| Japanese | English |
|--------|-----|
|前後|⬍Forward/Backward|
|左右|⬌Left/Right|
|ジャンプ|Jump|
|アクション|Action|
|やったぜ|Celebrate|
|パンチ|Punch|
|キック|Kick|
|ターン|Turn|
|せんかい速度|Turning Speed|

### クルマノードン : Car Nodon

| Japanese | English |
|--------|-----|
|アクセル|⬍Accelerate|
|ハンドル|⬌Steering wheel |
|ジャンプ|Jump|

### UFOノードン : UFO Nodon

| Japanese | English |
|--------|-----|
|前後|⬍Forward/Backward|
|左右|⬌Left/Right|
|上下|⬍Up/Down|
|水平スピード|Horizontal Speed|
|上下スピード|Vertical Speed|

## モノノードン : Object Nodon

| Japanese | English |
|--------|-----|
|モノのかたち (直方体 / 円柱 / 球)|Object Shape (Box / Cylinder / Sphere)|

## オシャレなモノノードン : Fancy-Object Nodon

| Japanese | English |
|--------|-----|
|しかくいオシャレ|Rectangular Fancy Objects|
|ハコ|Crate|
|コンテナ|Shipping Container|
|サイコロ|Dice|
|パネル|Panel|
|たからばこ|Treasure Chest|
|テレビ|Television|
|Joy-Con (R)|Joy-Con (R)|
|Joy-Con (L)|Joy-Con (L)|
|まるいオシャレ|Round Fancy Objects|
|サッカーボール|Soccer Ball|
|ゴルフボール|Golf Ball|
|ふうせん|Balloon|
|リンゴ|Apple|
|カブ|Turnip|
|サカナ|Fish|
|けだまる|Fluffball|
|エイリアン|Alien|
|えんちゅうなオシャレ|Cylindrical Fancy Objects|
|おじさん|Traveler|
|チアリーダー|Cheerleader|
|ダイバー|Diver|
|にんぎょ|Mermaid|
|ロボット|Robot|
|まじょ|Sorceress|
|ゆきおとこ|Yeti|
|スモウレスラー|Sumo Wrestler|
|いろんなオシャレ|Other Fancy Objects|
|リング|Hoop|
|やじるし|Arrow|
|ミサイル|Rocket|
|えんぴつ|Pencil|
|マグロ|Tuna|
|ヒヨコ|Chick|
|カバ|Hippo|
|くまちゃん|Bear|

## とくしゅなモノ : Special Objects

### うごかせるモノノードン : Moving-Object Nodon

| Japanese | English |
|--------|-----|
|X|X|
|Y|Y|
|Z|Z|
|モード (加速度 / 速度)|Mode (Acceleration / Speed)|

### まわせるモノノードン : Rotating-Object Nodon

| Japanese | English |
|--------|-----|
|X軸|X-axis|
|Y軸|Y-axis|
|Z軸|Z-axis|

### のばせるモノノードン : Extending-Object Nodon

| Japanese | English |
|--------|-----|
|X|X|
|Y|Y|
|Z|Z|

### エフェクトノードン : Effect Nodon

| Japanese | English |
|--------|-----|
|出す|Trigger|
|みため (はなび / ばくはつ / しゃぼんだま / けむり / クラッカー / ダメージ / 3カウント / しっぱい / ライト)|Appearance (Fireworks / Explosion / Bubbles / Smoke / Party Popper / Damage / Countdown / Failure / Light)|
|エフェクトを出すタイミング (０から変わったしゅんかん / ０以外のときずっと)|Effect Timing (On change from 0 / While not 0)|
|エフェクトが出る位置 (カメラ / ワールド)|Effect Location (Camera / World)|

### ことばつきモノノードン : Text-Object Nodon

| Japanese | English |
|--------|-----|
|表示することば|Display Text|
|もじのいろ|Text Color|
|表示方向|Text Display Side|

### 数つきモノノードン : Number-Object Nodon

| Japanese | English |
|--------|-----|
|数|Number|
|もじのいろ|Text Color|
|表示方向|Text Display Side|
|整数ケタ|Whole Number Digits|
|小数ケタ|Decimal Digits|

### テクスチャノードン : Texture Nodon

| Japanese | English |
|--------|-----|
|見える|Visible|
|貼りつける面|Texture Face|

## センサー : Sensors

Common terms are listed here.

| Japanese | English |
|--------|-----|
|センサーのかたち (直方体 / 円柱 / 球)|Seonsor Shape (Box / Cylinder / Sphere)|
|X|X|
|Y|Y|
|Z|Z|
|X軸|X-axis|
|Y軸|Y-axis|
|Z軸|Z-axis|

### さわっているセンサーノードン : Touch-Sensor Nodon

| Japanese | English |
|--------|-----|
|さわっている数|Touching count|
|出力するタイミング (さわったしゅんかん / さわっていたらずっと)|Output Timing (On touch / While touched)|
|何をチェックする？|Check What?|

### こわしたしゅんかんセンサーノードン : Destroying-Sensor Nodon

| Japanese | English |
|--------|-----|
|こわした数|Broken count|

### こわれているセンサーノードン : Destroyed-Sensor Nodon

| Japanese | English |
|--------|-----|
|こわれているか|If broken|

### つかまれているセンサーノードン : Grabbed-Sensor Nodon

| Japanese | English |
|--------|-----|
|つかまれているか|If grabbed|
|出力するタイミング (つかまれたしゅんかん / つかまれていたらずっと)|Output Timing (On grip / While gripped)|

### 位置センサーノードン : Location-Sensor Nodon

Only common terms.

### 速度センサーノードン : Speed-Sensor Nodon

Only common terms.

### 加速度センサーノードン : Acceleration-Sensor Nodon

Only common terms.

### 角度センサーノードン : Angle-Sensor Nodon

Only common terms.

### 回転速度センサーノードン : Rotation-Speed-Sensor Nodon

Only common terms.

## れんけつパーツ : Connections

### スライドれんけつノードン : Slide-Connector Nodon

| Japanese | English |
|--------|-----|
|スライド量|Slide amount|
|スライドのいどうきじゅん (X / Y / Z)|Slide Axis (X / Y / Z)|
|はんい|Range|

### フリースライドれんけつノードン : Free-Slide-Connector Nodon

| Japanese | English |
|--------|-----|
|スライドのいどう入力 (X / Y / Z)|Slide Motion Input (X / Y / Z)|

### ヒンジれんけつノードン : Hinge-Connector Nodon

| Japanese | English |
|--------|-----|
|まわす量|Rotation amount|
|ヒンジの回転きじゅん (X / Y / Z)|Axis of Rotation (X / Y / Z)|
|はんい|Range|

### ヒモれんけつノードン : String-Connector Nodon

| Japanese | English |
|--------|-----|
|ヒモのかたさ|String Stiffness|
|ヒモのながさ|String Length|

## だす・けす・引力 : Launch/Destroy/Attract

### モノを発射ノードン : Launch-Object Nodon

| Japanese | English |
|--------|-----|
|発射|Launch|
|発射方向|Launch Direction|
|発射スピード|Launch Speed|
|発射間隔|Launch Interval|

### モノをこわすノードン : Destroy-Object Nodon

| Japanese | English |
|--------|-----|
|こわす|Destroy|
|何をこわす？|Destroy What?|

### モノワープ入口ノードン : Teleport-Object-Entrance Nodon

| Japanese | English |
|--------|-----|
|ワープ|Teleport|
|ワープID|Teleport ID|
|何をワープする？|Teleport What?|

### モノワープ出口ノードン : Teleport-Object-Exit Nodon

| Japanese | English |
|--------|-----|
|ワープID|Teleport ID|
|ワープしせい (そのまま / リセット)|Teleport Physics (Preserve / Reset)|
|発射方向|Launch Direction|
|発射スピード|Launch Speed|
|発射間隔|Launch Interval|

### 引力ノードン : Attract-Object Nodon

| Japanese | English |
|--------|-----|
|力|Force|
|引力位置|Center of Attraction|
|何を引きよせる？|Attract Which Objects?|

## ワールドノードン : World Nodon

| Japanese | English |
|--------|-----|
|ワールドのかたち (なし / 球 / ユカ / ドーム / 直方体/円柱)|World Shape (None / Plane / Dome / Cubold / Cylinder / Sphere)|
|ワールドのみため (ふつう / しばふ / タイル / きんぞく / すな)|World Appearance (Default / Grass / Tiles / Metal / Sand)|
|ワールドのライト (ひる / ゆうがた / よる / くらやみ / うちゅう)|World Lighting (Noon / Evening / Night / Pitch black / Outer space)|
|太陽の方向|Sun Direction|
|太陽の高度|Sun Height|
|ワールドのそざい (ふつう / ポヨポヨ / ツルツル)|World Material (Normal / Bouncy / Slippery)|
|モノのみため (ふつう / きんぞく / ネオン)|Object Appearance (Default / Metallic / Neon)|
|ふるまい (こわさない / こわす)|Properties (Non-destructive / Destructinve)|
|ワールドでモノがこわれる速度|Object-Destruction Speed|

## ゲーム画面とカメラ : Game Screen / Camera

### ゲーム画面ノードン : Game-Screen Nodon

| Japanese | English |
|--------|-----|
|水平追従率|Horizontal Tracking Rate|
|上下追従率|Vertical Tracking Rate|
|カメラ画角|Camera Field of View|
|視点 (横から視点 / 上から視点)|Viewpoint (Side view / Overhead view)|

### カメラノードン : Camera Nodon

| Japanese | English |
|--------|-----|
|上下|⬍Up/Down|
|水平|⬌Horizontal|
|リセット|Reset|
|水平追従率|Horizontal Tracking Rate|
|上下追従率|Vertical Tracking Rate|
|カメラ画角|Camera Field of View|
|キャラクターY軸回転追従 (追従しない / 追従する)|Track Character's Y Rotation (Disable / Enable)|
|ずらすキョリ|Offset Distance|
|X軸回転|X-Axis Rotation|
|Y軸回転|Y-Axis Rotation|

### カメラ位置ノードン : Camera-Position Nodon

| Japanese | English |
|--------|-----|
|水平追従率|Horizontal Tracking Rate|
|上下追従率|Vertical Tracking Rate|
|ずらすキョリ|Offset Distance|

### カメラ注視点ノードン : Camera-Target Nodon

| Japanese | English |
|--------|-----|
|水平追従率|Horizontal Tracking Rate|
|上下追従率|Vertical Tracking Rate|
|ずらすキョリ|Offset Distance|

### カメラ方向ノードン : Camera-Direction Nodon

| Japanese | English |
|--------|-----|
|上下|⬍Up/Down|
|水平|⬌Horizontal|

### カメラ画角ノードン : Camera-Angle Nodon


| Japanese | English |
|--------|-----|
|カメラ画角|Camera Field of View|

### あたまノードン : Head Nodon

No terms.

### てノードン : Hand Nodon


| Japanese | English |
|--------|-----|
|つかむ|Grab|
|前後|⬍Forward/Backward|
|コントローラーばんごう (じどう)|Controller Number (Auto)|
|どっちのコントローラー？|Which Controller|
|モード (ホールド / トグル)|Mode (Hold / Toggle)|
|持ち方 (そのまま / ピッタリ)|Carrying Style (Precise / Snappy)|
|れんけつキョリ|Snap Distance|
|回転きじゅん (てくび / ひじ / かた)|Center of Rotation (Wrist / Elbow / Shoulder)|
|発射スピード|Launch Speed|
