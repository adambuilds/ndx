<?php
error_reporting(E_ALL);
ini_set("display_errors", "On");

require_once __DIR__ . '/vendor/autoload.php';

# load in the environment variables
# https://github.com/vlucas/phpdotenv
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$title = "Information Management System";

require 'includes/main-include.php';
// require 'includes/app-include.php';
require 'includes/panel-header.php';
?>

<div><a href="board.php" target="_blank">Start Production Board</a></div>

<?php
if (isset($_GET['job'])) {
	require 'views/job.php';
} elseif (isset($_GET['edit'])) {
	require 'views/job-edit.php';
} elseif (isset($_GET['search'])) {
  $title = "Search: ".$_GET['search'];
  $list = db("SELECT * FROM Jobs WHERE Description LIKE '%".$_GET['search']."%' OR Title LIKE '%".$_GET['search']."%' ORDER BY ID DESC");
  require 'views/job-list.php';
} else {
if (!isset($_GET['all'])) {
    $title = "Active Jobs";
    $list = db("SELECT * FROM Jobs INNER JOIN StatusCodes ON Jobs.Status=StatusCodes.Value WHERE Status > 0 AND Status < 100 ORDER BY Status ASC");
  } else {
    $title = "All Jobs Ever";
    $list = db("SELECT * FROM Jobs INNER JOIN StatusCodes ON Jobs.Status=StatusCodes.Value ORDER BY ID DESC");
	}
  require 'views/job-list.php';
}

require 'includes/panel-footer.php'; 
