<?php
# comment here
require_once('/var/www/opencart/test/Page.php');
$page = new Page ('Test Page Title');
echo $page->display("Quick Brown Fox Jumped over the lazy dog 1234567890 times");
?>
