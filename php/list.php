<?php
header('Content-Type: application/json');
include "conn.php";

$stmt = $conn->prepare("SELECT id, judul, pengarang, penerbit, kategori, sinopsis, tahun_terbit FROM film");
$stmt->execute();
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);
?>