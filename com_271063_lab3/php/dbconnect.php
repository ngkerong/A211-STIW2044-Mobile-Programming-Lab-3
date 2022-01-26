<?php
$servername = "localhost";
$username   = "ngcom_annburgeradmin";
$password   = "l9uaxztIWuvF";
$dbname     = "ngcom_annburger";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>