<?php
header('Content-Type: application/json');
include "conn.php";

$id = (int) $_POST['id'];
$stmt = $conn->prepare("DELETE FROM film WHERE id = ?");
$result = $stmt->execute([$id]);

echo json_encode([
    'id' => $id,
    'success' => $result
]);
?>