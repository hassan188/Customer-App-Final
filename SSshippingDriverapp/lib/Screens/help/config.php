<?php
try{
$connection=new PDO('mysql:host=localhost;dbname=ss_shipping','root','');
$connection ->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
echo "yes connected";
}catch(PDOException $exc){
echo $exc->insertdata();
die("could not connected");
}


?>