---
layout: post
title: "Jenkins: How to change JENKINS_HOME on Windows"
tags: Windows
lang: en
thumbnail: http://farm4.staticflickr.com/3705/12749957535_7568f3c3c2_o.png
alternate:
  lang: ja_JP
  url: /ja/blog/2014/02/25/jenkins-home-win/
seealso:
- 2014-01-29-chef-win-path
- 2013-10-02-node-watch-impl
- 2013-07-09-symlink-dir-diff-on-windows
- en/2013-02-27-livereloadx
---
If you install Jenkins using MSI installer, it copies files to `C:\Program Files (x86)\jenkins` and uses the install directory as `JENKINS_HOME` (on 64bit machine).

This means that Jenkins stores all data (including plugins, workspace and job data) to `C:\Program Files (x86)\jenkins`. On windows, it is recommended that application data is stored to `ProgramData` and `AppData`. So, I wanted to change `JENKINS_HOME`.

First, I added `JENKINS_HOME` to environment value, but it doen't make any sense. Jenkins prefers the value set on `jenkins.xml` when we use MSI installer.

Now, let's change `JENKINS_HOME` to `C:\ProgramData\Jenkins` (Jenkins version: 1.550).

1.  Stop Jenkins service.

2.  Open `jenkins.xml` in the install folder, and edit

    ```xml
      <env name="JENKINS_HOME" value="%BASE%"/>
    ```

    as follows:

    ```xml
      <env name="JENKINS_HOME" value="%ProgramData%\Jenkins"/>
    ```

3.  **Move** all files in install folder **except for** the following files (Don't copy because it brokes symbolic links in `jobs` folder):
   * `jre` folder
   * `jenkins.err.log`
   * `jenkins.exe`
   * `jenkins.exe.config`
   * `jenkins.out.log`
   * `jenkins.war`
   * `jenkins.war.bak`
   * `jenkins.war.tmp`
   * `jenkins.wrapper.log`
   * `jenkins.xml`

4.  Start Jenkins service.

5.  Open `http://localhost:8080/systemInfo` and check `JEKNINS_HOME` has been changed.

Enjoy!
