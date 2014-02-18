---
layout: post
title: Vagrant＋VirtualBox で Windows をゲスト OS として利用する方法
tags: Windows
lang: ja
publish: false
---
[Vagrant](http://www.vagrantup.com/)＋VirtualBox を使って、**Windows の環境を作ったり壊したり**できるようにしてみた。

完成図はこんな感じ。`vagrant up` で立ち上げた Windows にリモート デスクトップしている。

`C:\vagrant` にホスト側の `Vagrantfile` がマウントされているのが分かるだろうか。

Linux と同じように、`Vagrantfile` を書き換えれば、こんなこともできる。

  * ホスト名を変更する
  * IP アドレスを指定してネットワーク アダプターを追加する
  * ホスト側で書いた Chef のレシピを `vagrat provision` を使って、ゲスト上で走らせたりできる


目次
====

最初に目次をお見せしよう。

  1. VirtualBox をインストールする
  2. Vagrant をインストールする
  3. ゲスト OS をインストールする
  4. Vagrant-Windows 用の設定を行う
  5. Base Box を作成する
  6. Base Box を試す

正直いって長い。Linux だと、ネットに転がっている Box を拾ってくればいいんだけど、Windows の場合は自分で Box を作らなきゃいけないので、こんな長い手順になってしまう。

ゲスト OS は Windows 8.1 Pro 64bit と Windows Server 2012 R2 Standard を試してみた。

ホスト OS は Windows 8.1 Pro x64 を使っているが、他のバージョンでも動くだろうし、試してないけど Windows 以外の OS でも VirtualBox と Vagrant が動くならいけると思う。

なるべく一次情報を併記しつつ手順を示すので、バージョンが違うときにも応用はきくはずだ。また、裏側で何が起こっているのかを調べてみたので、うまくいかないときには参考にしてほしい。

では、さっそく行ってみよう。


1. VirtualBox をインストールする
================================

VirtualBox を次の場所からダウンロードする。

  * https://www.virtualbox.org/wiki/Downloads

執筆時点で最新の 4.3.6 をインストールした。

すべてデフォルトでインストールしたら、`C:\Program Files\Oracle\VirtualBox` にインストールされた。


### 補足

Vagrant が対応している VirtualBox をインストールしなきゃいけない。

[VirtualBox Provider - Vagrant Documentation](http://docs.vagrantup.com/v2/virtualbox/index.html) に Vagrant が要求する VirtualBox のバージョンが書いてある。執筆時点 (2014年2月) は次のようになっている。

> The VirtualBox provider is compatible with VirtualBox versions 4.0.x, 4.1.x, 4.2.x, and 4.3.x.


パスを通す
----------

Vagrant さんは `C:\Program Files\Oracle\VirtualBox\VBoxManage.exe` を使って VirtualBox に色んな指令をだす。

パスが通ってないとエラーになるので、`C:\Program Files\Oracle\VirtualBox` にパスを通しておく。


2. Vagrant をインストールする
=============================

Vagrant のインストーラーを次の場所から取得して、すべてデフォルトでインストールする。

  * http://www.vagrantup.com/downloads.html

執筆時点で最新の 1.4.3 を利用した。

Vagrant は `C:\HashiCorp\Vagrant` にインストールされる。自動で、`C:\HashiCorp\Vagrant\bin` にパスが通る。`C:\HashiCorp\Vagrant\embedded` に ruby や mingw などの UNIX 環境が入る。


Vagrant-Windows プラグイン
--------------------------

Vagrant で Windows をゲスト OS として扱うために、[Vagrant-Windows] プラグインを導入しておく。

コマンドプロンプトから次のコマンドを実行する。

```
>vagrant plugin install vagrant-windows
Installing the 'vagrant-windows' plugin. This can take a few minutes...
Installed the plugin 'vagrant-windows (1.5.1)'!
```

Vagrant-Windows の 1.5.1 がインストールされた。

### 補足

プラグインの gem は `C:\Users\username\.vagrant.d\gems\gems` に展開される。


3. ゲスト OS をインストールする
===============================

UNIX 系の OS だと、[Vagrantbox.es] から Base Box (Vagrant 用のイメージ) を拾ってくればいいんだけど、Windows だとそうもいかない。自分で Base Box を作るところから始まる。

Base Box を作るときの注意点は [Creating a Base Box - Vagrant Documentation](http://docs.vagrantup.com/v2/boxes/base.html) にある。ざっと要約すると

  * ディスク サイズは大きめにしてね。VirtualBox なら [可変サイズ] のディスクを大きめのサイズで作ってね。
  * メモリーは大きすぎない値にしてね。ユーザーは `Vagrantfile` で変更できるんだから、512MB ぐらいにしておいてね。
  * オーディオとか USB は無効にしてね。
  * `vagrant` というユーザー (パスワードも `vagrant`) を作ってね。`authorized_keys` に追加してね。`sudoers` に追加してね。`root` のパスワードも `vagrant` にしてね。

といったことが書いてある。これに従って作業してみる。

仮想マシンの作成
----------------

次の手順で実施した。インストールメディアの ISO ファイルがあるものとする。

1. VirtualBox を起動する。
2. メニューから [仮想マシン] > [新規] で新しい仮想マシンを作る。
3. 名前とバージョンを選択して、[次へ] を押す。
  * Windows Server 2012 R2 のとき: 名前は [Windows 2012 R2]、バージョンは [Windows 2012 (64bit)]。
  * Windows 8.1 のとき: 名前は [Windows 8.1]、バージョンは [Windows 8.1 (64bit)]。
4. メモリーは 2048MB を提案されるので、1024MB に減らして [次へ] を押す。
  * 512MB まで減らすと、Windows 8.1 で 0xc0000017、Windows Server 2012 R2 で 0xE0000100 エラーが出て先に進めなかった。
5. ハードドライブはデフォルトで 25GB の可変サイズで [作成]、[次へ] を押していく。
6. 新しくできた仮想マシン [Windows 2012 R2] を選択して、メニューから [仮想マシン] > [設定] を選ぶ。
7. オーディオと USB を無効にする。
  * [オーディオ] を選択して、[オーディオを有効化] のチェックを外す。
  * [USB] を選択して、[USB コントローラーを有効化] のチェックを外す。
8. ISO イメージを割り当てる。
  * [ストレージ] を選択する。
  * [コントロｰラー: IDE] の下の [空] を選択する。
  * [CD/DVD ドライブ] の右側のディスクのアイコンをクリックして、[仮想CD/DVDディスクファイルの選択...] を選ぶ。
  * インストールメディアの ISO ファイルを選ぶ。
9. [OK] を押して閉じる。


OS のインストール
-----------------

引き続き、OS のインストールを行う。

1. メニューから [仮想マシン] > [起動] で仮想マシンを起動する。
2. ISO イメージから起動するので、デフォルトの設定でインストールを始める。
3. (2012 R2 のみ) OS の種類は [Windows Server 2012 R2 Standard (GUI 使用サーバー)] を選択して、[次へ]。
4. インストールの種類は [カスタム: Windows のみをインストールする (詳細設定)] を選ぶ。
  * インストールが始まるので、しばらく待つ。
6. アカウントのパスワードを設定する。
  * Windows Server 2012 R2: Administrator アカウントのパスワードを決める画面になるので、適当に入力する (この時点では "vagrant" は「簡単すぎる」と怒られるので設定できない)。
  * Windows 8.1: Microsoft アカウントは登録しない。ローカルアカウントをユーザー名 vagrant、パスワード vagrant で登録する。
7. ログオン画面になるので、作成したアカウントでログオンする。
  * Ctrl + Alt + Del は「右 Ctrl + Del」で入力する。メニューから [仮想マシン] > [Ctrl-Alt-Delを送信] でもよい。
8. Guest Additions をインストールする。
  * メニューから [デバイス] > [Guest Additions のCDイメージを挿入...] を選ぶ。
  * D: ドライブを開いて、Guest Additions のセットアップを行う。
  * 作業が終わったら、[デバイス] > [CD/DVD デバイス] > [仮想ドライブからディスクを除去] でディスクを抜いておく。


4. Vagrant-Windows 用の設定を行う
=================================

ゲスト OS 側にいろんな設定を行う。

Linux 側の手順でいうところの

  * `vagrant` というユーザー (パスワードも `vagrant`) を作ってね。`authorized_keys` に追加してね。`sudoers` に追加してね。`root` のパスワードも `vagrant` にしてね。

の作業をやるのだが、Windows の場合は SSH ではなく WinRM を使う。

詳しい手順は [Vagrant-Windows] のページに書いてあるので、この手順に従って、ちまちまと作業を行う。

>  - Create a vagrant user, for things to work out of the box username and password should both be "vagrant".
>  - Turn off UAC (Msconfig)
>  - Disable complex passwords
>  - [Disable Shutdown Tracker](http://www.jppinto.com/2010/01/how-to-disable-the-shutdown-event-tracker-in-server-20032008/) on Windows 2008/2012 Servers (except Core).
>  - [Disable "Server Manager" Starting at login](http://www.elmajdal.net/win2k8/How_to_Turn_Off_The_Automatic_Display_of_Server_Manager_At_logon.aspx) on Windows 2008/2012 Servers (except Core).
>  - Enable and configure WinRM (see below)


パスワードの複雑性を無効にする
------------------------------

Windows Server 2012 R2 のみ。

1. サーバー マネージャーのメニューから [ツール] > [ローカル セキュリティー ポリシー] を選択する。
2. [アカウント ポリシー] > [パスワードのポリシー] > [複雑さの要件を満たす必要があるパスワード] をダブルクリックして [無効] に設定する。
3. Ctrl-Alt-Del から Administrator のパスワードを `vagrant` に変更しておくとよい。


ユーザー vagrant を作成する
---------------------------

Windows Server 2012 R2 のみ。

1. サーバー マネージャーのメニューから [ツール] > [コンピューターの管理] を選択する。
2. [システム ツール] > [ローカル ユーザーとグループ] > [ユーザー] を選択する。
3. 右クリックから [新しいユーザー] を選択する。
4. ユーザーを作成する。
  * ユーザー名、パスワードを `vagrant` にする。
  * [ユーザーは次回ログオン時にパスワードの変更が必要] のチェックを外す。
  * [パスワードを無期限にする] をチェックする。
  * [作成] ボタンを押す。
5. 管理者に変更する。
  * 新しく作成した `vagrant` 右クリックして [プロパティ] を選択する。
  * [所属するグループ] タブを開く。
  * `Administrators` を追加して、[Users] を削除する。
  * [OK] ボタンを押す。


UAC を無効にする
----------------

Windows Server 2012 R2、Windows 8.1 共通。

1. msconfig を起動する。たとえば、Windows + R で [ファイル名を指定して実行] を開いて、`msconfig` と入力して [OK] を押す。
2. [ツール] タブを開いて、[UAC 設定の変更] を選択して、[起動] ボタンを押す。
3. スライダーを一番下の [通知しない] にして、[OK] ボタンを押す。


Shutdown Tracker を無効にする
-----------------------------

Windows Server 2012 R2 のみ。

1. [ローカル グループ ポリシー エディター] を起動する。たとえば、Windows + R で [ファイル名を指定して実行] を開いて、`gpedit.msc` と入力して [OK] を押す。
2. ツリーから [コンピューターの構成] > [管理者用テンプレート] > [システム] を選択する。
3. 右側のペインから [シャットダウン イベントの追跡ツールを表示する] をダブルクリックする。
4. [未構成] を [無効] に変更して、[OK] ボタンを押す。


ログオン後にサーバー マネージャーが表示されないようにする
---------------------------------------------------------

Windows Server 2012 R2 のみ。

1. [ローカル グループ ポリシー エディター] を起動する。たとえば、Windows + R で [ファイル名を指定して実行] を開いて、`gpedit.msc` と入力して [OK] を押す。
2. ツリーから [コンピューターの構成] > [管理者用テンプレート] > [システム] > [サーバー マネージャー] を選択する。
3. 右側のペインから [ログオン時にサーバー マネージャーを自動的に表示しない] をダブルクリックする。
4. [未構成] を [有効] に変更して、[OK] ボタンを押す。
5．コマンドプロンプトから `gpupdate` を実行して、その場でポリシーを反映する。


WinRM を有効にする
------------------

Windows Server 2012 R2、Windows 8.1 共通。

コマンドプロンプト上で次のコマンドを実行する。

```
winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
sc config WinRM start= auto
```

Windows Server 2008 では追加の設定が必要になるようなので、[Vagrant-Windows] を参照のこと。


設定しておいたほうが便利そうなこと
----------------------------------

[Vagrant-Windows] の手順には書いてなかったが、やっておいたほうがよいかもしれないのは次の手順。

  * リモートデスクトップを有効にする: ヘッドレスで利用する場合は、リモートデスクトップでつなぐことになる。いずれにしても有効にしておいたほうが便利だろう。
  * Windows Update をとめる: 自動でダウンロードしたりインストールしたりする設定は OFF にしておくと、いきなり端末が重くなって悩まされない。


4. Base Box を作成する
======================

ここまでで準備は完了。ゲスト OS は電源を切っておく。

ホスト OS 側でイメージを Base Box としてパッケージ化していく。


デフォルトの Vagrantfile を用意
-------------------------------

Box に `Vagrantfile` を同梱したいので、次の中身を `Vagrantfile.txt` として保存しておく。

```ruby
Vagrant.configure("2") do |config|
  config.vm.guest = :windows
end
```

「ゲスト OS は Windows だよ」「Vagrant-Windows を使ってゲスト OS に指令をだしてね」という意味だ。

この手順は省略してもよいんだけど、省略した場合は、プロジェクトを作るたびに上の設定を `Vagrantfile` に書く必要がある (忘れてしまうと、電源起動以外がうまく動かない)。


### 参考情報

  * [Vagrantfile - Vagrant Documentation](http://docs.vagrantup.com/v2/vagrantfile/): `Vagrantfile` の優先順位について書いてある。プロジェクトごとの `Vagrantfile` に設定がない場合は、Box の `Vagrantfile` を見に行くそうだ。



vagrant package で Box を作成
-----------------------------

コマンドプロンプトで次のように入力するだけ。

```
C:\Users\username>vagrant package --base "Windows 2012 R2" --vagrantfile Vagrantfile.txt
[Windows 2012 R2] Clearing any previously set forwarded ports...
[Windows 2012 R2] Exporting VM...
[Windows 2012 R2] Compressing package to: C:/Users/username/package.box```
```

カレントディレクトリに `package.box` というファイル名で出力される。`Win2012R2.box` や `Win81.box` などにリネームしておくと分かりやすいだろう。


### 補足

  * `Windows 2012 R2` の部分は VirtualBox の仮想マシン名なので、別名で作った場合は適宜変更すべし。
  * Vagrantfile.txt が別のディレクトリーにあるときは、そこへのパスを入力すべし。
  * Vagrantfile を同梱しない場合は、`--vagrantfile` の指定は不要。


### 裏側の挙動

それなりの時間がかかる。内部的には次のような処理をしている様子。

  1. ディスクイメージ (この時点で約 8GB) を `C:\Users\username\.vagrant.d\tmp` の下に圧縮した vmdk として出力する (4GB に圧縮)。
  2. `box.ovf` と `Vagrantfile` も同じ場所に設置。
  3. tar でカレントディレクトリに `package.box` として固めて出力。


### 参考情報

 * [Creating a Base Box - VirtualBox Provider - Vagrant Documentation](http://docs.vagrantup.com/v2/virtualbox/boxes.html): パッケージ化の方法
 * [vagrant package - Command-Line Interface - Vagrant Documentation](http://docs.vagrantup.com/v2/cli/package.html): `vagrant package` のコマンドライン オプション。


5. Base Box を試す
==================

ここからは他の OS の Base Box を試す手順とかなり似てくる。

vagrant box add
---------------

次のコマンドで Box を作成する。

```
> vagrant box add Win2012R2 path\to\package.box
Downloading box from URL: file:C:/Users/username/package.box
Extracting box...ate: 124M/s, Estimated time remaining: --:--:--)
Successfully added box 'Win2012R2' with provider 'virtualbox'!
```

`path\to\package.box` の部分は 4. で作成した box ファイルへのパスに置き換えて実行してね。

### 補足

`package.box` を Web サーバー上に置いた場合は `vagrant box add BoxName http://example.com/package.box` のように指定できる。Web 上に公開された Box ファイルの情報を寄せ集めたのが [Vagrantbox.es] である。

### 裏側の挙動

`C:\Users\username\.vagrant.d\boxes\Win2012R2\virtualbox` に box ファイルの中身が展開される。



vagrant init
------------

プロジェクトのディレクトリーを適当に作って、`vagrant init` する。

```
>cd C:\Users\username\Documents
>mkdir Win2012R2
>cd Win2012R2
>vagrant init Win2012R2
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```

`Vagrantfile` がカレントディレクトリーに出力される。

ゲスト OS の画面を表示する方法を

  * VirtualBox のウインドウを表示する
  * リモートデスクトップする

のいずれを選ぶかに応じて、`Vagrantfile` の設定手順が変わる。


VirtualBox のウインドウを表示する場合は、次のように `# Don't boot with headless mode` の部分のコメントを取り除いておく。

```ruby
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true
  
    # Use VBoxManage to customize the VM. For example to change memory:
    #vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
```

リモートデスクトップを利用する場合は、次のような設定を書いておく。

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Port forward RDP
  config.vm.network :forwarded_port, guest: 3389, host: 13389

  # ここより下は省略...
end
```

ゲストの電源を入れたあと、ホスト上のリモートデスクトップ クライアントを立ち上げて `localhost:13389` に繋ぎに行けばよい。詳しくは {% post_link 2014-02-06-rdp-port %} を参照してほしい。なお、[Vagrant-Windows] にはホスト側を `3389` とする設定例が載っていたが、それではうまく動かなかった。


vagrant up
----------

いよいよ起動。

```
> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
[default] Clearing any previously set forwarded ports...
[default] Clearing any previously set network interfaces...
[default] Preparing network interfaces based on configuration...
[default] Forwarding ports...
[default] -- 3389 => 13389 (adapter 1)
[default] Booting VM...
[default] Waiting for machine to boot. This may take a few minutes...
[default] Machine booted and ready!
[default] Mounting shared folders...
[default] -- /vagrant
[default] VM already provisioned. Run `vagrant provision` or use `--provision` t
o force it
```

`vagrant up` すると端末が上がってくる。

### 補足

  * コピーが発生するので初回は少し待つ。
  * VirtualBox を起動しておくと、イメージが登録されて起動してくる様子を確認できる。
  * ログオンしてみると、`C:\vagrant` にホスト側のプロジェクト ディレクトリーが見えているのが確認できる。


### 裏側の挙動

  * `C:\Users\username\.vagrant.d\boxes\Win2012R2\virtualbox` の中身を `C:\Users\username\VirtualBox VMs` にコピーする。
  * 上記イメージを VirtualBox に登録して、電源が入る。
  * プロジェクト ディレクトリーが `C:\vagrant` で見えているのは「VirtualBox の共有フォルダーの機能」と「[Vagrant-Windows] が共有へのシンボリックリンクを作る機能」の合わせ技で実現している。シンボリックリンクは WinRM で [`mount_volume.ps1`](https://github.com/WinRb/vagrant-windows/blob/v1.5.1/lib/vagrant-windows/scripts/mount_volume.ps1.erb) を実行して作成している。


まとめ
======

以上で手順の解説は終わる。このあとは `Vagrantfile` を編集していろいろ試すとよい。

[Vagrant-Windows] が頑張ってくれているおかげで、Linux と同じように Vagrant の機能を使えることがわかった。手順が面倒だったのは、ライセンス上の問題で Windows の Box がネットに落ちていないから。

実際に使ってみると、VirtualBox がたまに落ちたり、ゲスト OS 内で `VirtualBoxService.exe` や `rundll32.exe aepdu.dll,AePduRunUpdate` が CPU を消費しまくっている現象が起きたりして悲しい。VirtualBox や Windows の問題なので、Vagrant は悪くない。

[Vagrant-Windows]: https://github.com/WinRb/vagrant-windows
[Vagrantbox.es]: http://www.vagrantbox.es/
