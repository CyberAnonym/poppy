create
############



create|创建数据库
=========================
::

    create database clear;
    create database alvinlife  DEFAULT CHARACTER SET utf8;

create|创建表
======================
::

    create table emp (id int , name varchar(20));
    create table treasurer (id int(10) not null auto_increment primary key,name char(10),math int(10));

    create table 表名（字段1名称 数据类型（宽度） 修饰字符1  修饰字符2，字段2）；

::

    CREATE TABLE `user` (
        `id` VARCHAR (32) NOT NULL,
        `inviteCode` VARCHAR (255) NOT NULL,
        `loginName` VARCHAR (255) NOT NULL,
        `mobile` VARCHAR (255) NOT NULL,
        `password` VARCHAR (255) NOT NULL,
        `role` INT (11) NOT NULL,
        `enableManualInput` TINYINT (2) DEFAULT '0',
        `adress` VARCHAR (255) DEFAULT NULL,
        `brithday` VARCHAR (255) DEFAULT NULL,
        `medicare` VARCHAR (255) DEFAULT NULL,
        `name` VARCHAR (255) DEFAULT NULL,
        `nickName` VARCHAR (255) DEFAULT NULL,
        `sex` VARCHAR (255) DEFAULT NULL,
        `summary` VARCHAR (255) DEFAULT NULL,
        `titles` VARCHAR (255) DEFAULT NULL,
        `workplace` VARCHAR (255) DEFAULT NULL,
        `section` VARCHAR (32) DEFAULT NULL,
        `section_type` TINYINT (1) DEFAULT '1' COMMENT '科室类型 1:内分泌科',
        `healthHistoryId` VARCHAR (255) DEFAULT NULL,
        `imageId` VARCHAR (255) DEFAULT NULL,
        `equipmentId` VARCHAR (255) DEFAULT NULL,
        `sn` DOUBLE DEFAULT '0',
        `ew` DOUBLE DEFAULT '0',
        `expertise` text,
        `experience` text,
        `phoneType` VARCHAR (128) DEFAULT '',
        `bloodfat` FLOAT DEFAULT '0',
        `bloodpressureH` INT (11) DEFAULT '0',
        `bloodpressureL` INT (11) DEFAULT '0',
        `height` INT (11) DEFAULT '0',
        `weight` FLOAT DEFAULT '0',
        `heartrate` INT (11) DEFAULT '0',
        `status` INT (11) DEFAULT '0',
        `openId` VARCHAR (128) DEFAULT '',
        `firstTryTime` BIGINT (20) DEFAULT '0',
        `province` VARCHAR (32) DEFAULT '',
        `city` VARCHAR (32) DEFAULT '',
        `contact` VARCHAR (32) DEFAULT '',
        `contactPhone` VARCHAR (32) DEFAULT '',
        `newUser` INT (4) DEFAULT '1',
        `triedDays` INT (11) DEFAULT '0',
        `lastTryTime` BIGINT (20) DEFAULT '0',
        `lastFreePaperTime` BIGINT (20) DEFAULT '0',
        `medicineType` INT (4) DEFAULT '0',
        `tryNum` INT (11) DEFAULT '5',
        `eventKey` INT (11) DEFAULT '0',
        `smoke` INT (11) DEFAULT '0',
        `drink` INT (11) DEFAULT '0',
        `createDate` TIMESTAMP NULL DEFAULT NULL,
        `isBHUser` INT (11) DEFAULT '0',
        `wechatImgUrl` VARCHAR (512) DEFAULT NULL,
        `hba1c` INT (11) DEFAULT '1',
        `hbA1cUpdateTime` TIMESTAMP NOT NULL DEFAULT '2014-12-31 16:00:00',
        `sourceChannel` INT (11) DEFAULT '0',
        `hospitalId` VARCHAR (32) DEFAULT NULL,
        `groupId` INT (11) DEFAULT '0',
        `lastSessionId` VARCHAR (32) DEFAULT NULL,
        `appVersion` VARCHAR (32) DEFAULT NULL,
        `qrCodeImgUrl` VARCHAR (512) DEFAULT NULL,
        `qrCodeSeq` INT (11) DEFAULT '0',
        `testStatusTranslated` INT (11) DEFAULT '0',
        `patientType` INT (11) DEFAULT '0',
        `isHotline` TINYINT (4) DEFAULT '0' COMMENT '是否可以做热线医生 0:不可以 1:可以',
        `is_test` INT (2) DEFAULT '0',
        `isQuitProject` TINYINT (4) DEFAULT '0' COMMENT '是否退组 0:未退组 1:退组',
        `saleName` VARCHAR (255) DEFAULT '' COMMENT '销售人员名称',
        `saleMobile` VARCHAR (255) DEFAULT '' COMMENT '销售人员手机号',
        `privilegeCode` INT (11) NOT NULL DEFAULT '0',
        `plCode` INT (11) NOT NULL DEFAULT '0',
        `realMobile` VARCHAR (32) DEFAULT NULL,
        `registerDate` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '注册时间',
        `userType` VARCHAR (255) DEFAULT NULL COMMENT '用户类型',
        `thirdPartyId` VARCHAR (255) DEFAULT NULL COMMENT '第三方id',
        PRIMARY KEY (`id`),
        UNIQUE KEY `mobile` (`mobile`),
        UNIQUE KEY `loginName` (`loginName`),
        KEY `inviteCode` (`inviteCode`),
        KEY `user_index_of_hospitalId` (`hospitalId`)
    ) ENGINE = INNODB DEFAULT CHARSET = utf8