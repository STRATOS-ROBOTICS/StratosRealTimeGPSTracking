<?php
//data.php

//Database setttings
include "./dbinfo.php";

//Connect to DB Server

$conn = new mysqli($dbhost, $dbuser, $dbpassword, $dbname);
if($conn->connect_errno) {
    echo "<p class='errMsg'>could not connect to db server.".$conn->connect_error."</p>\n";
    exit();
}


//SQL syntax
$query = "SELECT * FROM colleges2;";

//Execute the sql
$result = $conn->query($query);

//Count  
$rowCount = $result->num_rows;


//test
//echo $rowCount;


if($rowCount > 0) {
while($row = $result->fetch_array()){
    //Assign output variables
    $fid = $row[0];
    $latitude = $row[1];
    $longitude = $row[2];
    $altitude = $row[3];
    $ggasolution = $row[4];
    $gpsID = $row[5];

    //Store results into JSON array
    $rows[] = array (
    "fid" => $fid,
    "latitude" => $latitude,
    "longitude" => $longitude,
    "altitude" => $altitude,
    "ggasolution" => $ggasolution,
    "gpsID" => $gpsID
    );    
   } 

   //Encode results to JSON format 
   $jsonOutput = json_encode($rows);

   //Display the JSON data
   echo $jsonOutput;



   //Free SQL  
   $result->free();   
}else{
   //If query returned zero result
   $value = array(
       "status" => "0"
   );
   echo json_encode($value);
}

//Close DB connection

$conn->close();