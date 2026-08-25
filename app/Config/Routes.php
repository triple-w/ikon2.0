<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// We get a performance increase by specifying the default
// route since we don't have to scan directories.
$routes->get('/', 'Dashboard::index');

//custom routing for custom pages
//this route will move 'about/any-text' to 'domain.com/about/index/any-text'
$routes->add('about/(:any)', 'About::index/$1');

//add routing for controllers
$excluded_controllers = array("About", "App_Controller", "Security_Controller");
$controller_dropdown = array();
$dir = "./app/Controllers/";
if (is_dir($dir)) {
    if ($dh = opendir($dir)) {
        while (($file = readdir($dh)) !== false) {
            $controller_name = substr($file, 0, -4);
            if (is_file($dir . $file) && pathinfo($file, PATHINFO_EXTENSION) === "php" && !in_array($controller_name, $excluded_controllers)) {
                $controller_dropdown[] = $controller_name;
            }
        }
        closedir($dh);
    }
}

// add route for Collect_leads controller differently with the CORS filter for AJAX requests / API calls
$routes->post('collect_leads/save', 'Collect_leads::save', ['filter' => 'cors']);
$routes->options('collect_leads/save', 'Collect_leads::save', ['filter' => 'cors']);
$routes->post('invoices/close_sale/(:num)', 'Invoices::close_sale/$1', ['filter' => 'csrf']);

// C2.3.1-R1: Estimate acceptance has an explicit read-only modal GET and a POST mutation.
// Keep these before the legacy controller catch-all routes so method arguments are unambiguous.
$routes->get('estimate/accept_estimate_modal_form/(:num)', 'Estimate::accept_estimate_modal_form/$1');
$routes->get('estimate/accept_estimate_modal_form/(:num)/(:segment)', 'Estimate::accept_estimate_modal_form/$1/$2');
$routes->post('estimate/accept_estimate', 'Estimate::accept_estimate', ['filter' => 'csrf']);
$routes->get('estimate/update_estimate_status/(:num)/(:segment)/(:segment)', 'Estimate::update_estimate_status/$1/$2/$3');
$routes->get('estimates/update_estimate_status/(:num)/(:segment)', 'Estimates::update_estimate_status/$1/$2');

foreach ($controller_dropdown as $controller) {
    $routes->get(strtolower($controller), "$controller::index");
    $routes->get(strtolower($controller) . '/(:any)', "$controller::$1");
    $routes->post(strtolower($controller) . '/(:any)', "$controller::$1");
}

// Fiscal routes are intentionally explicit and currently register no endpoints.
// Keep this include separate from RISE's legacy controller discovery.
require APPPATH . 'Config/FiscalRoutes.php';

//add uppercase links

$routes->get("Updates", "Updates::index");
$routes->get("Updates/(:any)", "Updates::$1");
$routes->post("Updates/(:any)", "Updates::$1");

/*
 * --------------------------------------------------------------------
 * Additional Routing
 * --------------------------------------------------------------------
 *
 * There will often be times that you need additional routing and you
 * need it to be able to override any defaults in this file. Environment
 * based routes is one such time. require() additional route files here
 * to make that happen.
 *
 * You will have access to the $routes object within that file without
 * needing to reload it.
 */
if (is_file(APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php')) {
    require APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php';
}
