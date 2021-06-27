<?php
require('config.php');
$makeQuery="SELECT * FROM myAppTable";
$statement=$connection-> prepare(makeQuery);
$statement->execute();
$myarray=array();
while($resultsFrom=$statement->fetch()){
       array_push(
        $myarray,array(
          "id"=>$resultsFrom['id'],
          "heading"=>$resultsFrom['heading'],
          "body"=>$resultsFrom['body']
        )
       );

}
    echo json_encode($myarray);
    ?>