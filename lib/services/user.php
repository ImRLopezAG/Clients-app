<?php
$hostname = 'localhost';
$database = 'clients';
$username = 'root';
$password = '';

$connection = new mysqli($hostname, $username, $password, $database);

if ($connection->connect_errno) {
    echo "Sorry, this website is experiencing problems.";
}

$create_table_query = "CREATE TABLE IF NOT EXISTS client (
    id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age VARCHAR(255) NOT NULL,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

$connection->query($create_table_query);

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['get_all'])) {
        $query = $connection->prepare("SELECT * FROM client");
        $query->execute();
        $result = $query->get_result();
        $clients = array();
        while ($client = $result->fetch_assoc()) {
            $clients[] = $client;
        }
        $query->close();
        header('Content-Type: application/json');
        echo json_encode($clients);
    }
    else if (isset($_GET['id'])) {
        $id = $_GET['id'];
        $query = $connection->prepare("SELECT * FROM client WHERE id = ?");
        $query->bind_param("i", $id);
        $query->execute();
        $result = $query->get_result();
        if ($client = $result->fetch_assoc()) {
            header('Content-Type: application/json');
            echo json_encode($client);
        } else {
            http_response_code(404);
        }
        $query->close();
    }else if (isset($_GET['init'])) {
        $init = "SELECT * FROM client WHERE name = 'admin'";
        $result = $connection->query($init);
        if ($result->num_rows === 0) {
            $admin = "INSERT INTO client (name, age) VALUES ('admin', 18)";
            $connection->query($admin);
        }
        header('Content-Type: application/json');
        echo json_encode($result->fetch_assoc());
    }
} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $name = $data['name'];
    $age = $data['age'];
    $query = $connection->prepare("INSERT INTO client (name, age) VALUES (?, ?)");
    $query->bind_param("ss", $name, $age);
    $query->execute();
    $query->close();
    http_response_code(201);
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $id = $_GET['id'];
    $name = $data['name'];
    $age = $data['age'];
    $query = $connection->prepare("UPDATE client SET name = ?, age = ? WHERE id = ?");
    $query->bind_param("ssi", $name, $age, $id);
    $query->execute();
    $query->close();
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    $query = $connection->prepare("DELETE FROM client WHERE id = ?");
    $query->bind_param("i", $id);
    $query->execute();
    $query->close();
}
$connection->close();
?>