# jsonparse
스프링 전자정부프레임워크


## JsonParse 

이더리움 계좌조회 json파일을 
DB에 저장하여 출력 


#### history

##### Development environment

    OS : CentOS Linux release 7.5.1804
    
    Tomcat : 8.53

    MariaDB : 10.4

    JDK : OpenJDK Runtime Environment (build 1.8.0.161-1)
    
    FrameWork : 전자정부프레임워크 3.7(eGovFrameDev-3.7.0-64bit.exe)
    
    character set : UTF-8
    
    Lombok : 1.18.10


##### openjdk, tomcat
    리눅스 버전
    wget https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.161-1/java-1.8.0-openjdk-1.8.0.161-3.b14.el6_9.x86_64.zip

    바이너리
    wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.53/bin/apache-tomcat-8.5.53.tar.gz
   
    
##### install PATH

    #echo $JAVA_HOME
    /usr/local/java/1.8.0.161-1
    
    #let's SSL
    /usr/local/src/letsencrypt
    
    #TOMCAT 
    /usr/local/apache-tomcat-8.5.53
    
    
    
##### vi etc/profile

    JAVA_HOME=/usr/local/java/jdk1.8.0.161
    JRE_HOME=/usr/local/java/jdk1.8.0.161
    CATALINA_HOME=/usr/local/apache-tomcat-8.5.53
    CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$CATALINA_HOME/lib/jsp-api.jar:$CATALINA_HOME/lib/servlet-api.jar
    PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
    export JAVA_HOME PATH JRE_HOME CLASSPATH CATALINA_HOME

    
    
##### MariaDB설치

    CREATE TABLE `JSONTEST` (
      `NUM` int(11) NOT NULL AUTO_INCREMENT COMMENT '글번호',
      `HASH` varchar(64) NOT NULL COMMENT '해쉬',
      `CONTENTS` text NOT NULL COMMENT '내용',
      `REG_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '최초등록일',
      PRIMARY KEY (`NUM`)
    ) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='JSON테스트';

    MariaDB [(none)]>create database jsonparse;
    MariaDB [(none)]>use jsonparse;
    MariaDB [docuchain]>create user 'ictdb_json'@'%' identified by '2020a@json';
    MariaDB [docuchain]>GRANT ALL PRIVILEGES ON jsonparse.* TO 'ictdb_json'@'%';
    MariaDB [docuchain]>flush privileges;


    
    
##### TEST

http://localhost:8080/jsontest

 

    
    
<img src="https://user-images.githubusercontent.com/46703698/95946105-cfa25300-0e26-11eb-8592-9a2da86759c8.jpg"></img>
    
    파싱할 json값 
    https://ropsten.etherscan.io/api?module=account&action=txlist&address=0xFf0797D06e8F9897B1D5066C10D9497Ed7054A47&startblock=0&endblock=99999999&page=1&offset=1&sort=desc
