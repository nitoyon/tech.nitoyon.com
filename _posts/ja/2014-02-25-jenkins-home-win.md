---
layout: post
title: Windows の Jenkins で JENKINS_HOME を別のフォルダーに変更する方法
tags: Windows
lang: ja
thumbnail: http://farm4.staticflickr.com/3705/12749957535_2aea32f28d_o.png
seealso:
- 2014-02-20-vagrant-win-guest
- 2014-02-06-rdp-port
- 2014-01-17-chef-win-path
- 2013-12-09-setctime
- 2013-11-14-jekyll-win
---
Jenkins を Windows 環境に MSI ファイルで導入すると、デフォルトでは `C:\Program Files (x86)` にインストールされる (64 ビットの場合)。

Java の実行環境を同梱してくれていたり、自動でサービスに登録してくれたりして嬉しいのだけど、気になるのが `JENKINS_HOME` が `C:\Program Files (x86)\Jenkins` になってしまう点。ジョブやワークスペース、プラグインなどのデータなどが `Program Files` の下に置かれてしまう。Windows 的な作法では「アプリケーションのデータは `ProgramData` や `AppData` に置きましょう」となっているので少し気持ち悪い。

`JENKINS_HOME` を変更するには環境変数を設定したらいけそうなんだけど、MSI から導入した場合は環境変数ではなく `jenkins.xml` の値が優先されるようだ (jar から直接実行する場合は未確認)。

ということで、「MSI から導入した Jenkins で `JENKINS_HOME` を変更する手順」をまとめておく。Jenkins のバージョンは 1.550。

ここでは、`JENKINS_HOME` を `C:\ProgramData\Jenkins` に変更するものとする。

1. Jenkins サービスをとめる。
2. インストール フォルダーの `jenkins.xml` を開いて

    ```xml
      <env name="JENKINS_HOME" value="%BASE%"/>
    ```

   を次のように書き換える (改行コードが LF なので、メモ帳ではできなくはないが探すのが少し大変)。

    ```xml
      <env name="JENKINS_HOME" value="%ProgramData%\Jenkins"/>
    ```
3. インストール フォルダーの次のファイル・フォルダー**以外**を `%ProgramData%\Jenkins` に**移動**する (コピーだと、`jobs` 内にシンボリックリンクがあった場合に壊れてしまうので、必ず「移動」すること)。
   * `jre` フォルダー
   * `jenkins.err.log`
   * `jenkins.exe`
   * `jenkins.exe.config`
   * `jenkins.out.log`
   * `jenkins.war`
   * `jenkins.war.bak`
   * `jenkins.war.tmp`
   * `jenkins.wrapper.log`
   * `jenkins.xml`
4. Jenkins サービスを開始する。
5. `http://localhost:8080/systemInfo` から `JEKNINS_HOME` が設定した値になっていることを確認する。ジョブやプラグインなどの情報が引き継がれているかどうかも合わせて確認する。

とっても簡単ですね。インストーラーで設定できるようになっていると、より嬉しいので、気が向いたら pull request してみよう・・・。
