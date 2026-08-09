<?php
//DBConnection
$DBURL = "sql5.freesqldatabase.com";
$DBUsername = "sql5834481";
$DBPassword = "gRWCi3eqSC";
$DBName = "sql5834481";
$DBPort = 3306;

$DBReq = new mysqli($DBURL, $DBUsername, $DBPassword, $DBName, $DBPort);

if ($DBReq->connect_error) {
    die("Connection failed: " . $DBReq->connect_error);
}
