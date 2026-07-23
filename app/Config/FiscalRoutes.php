<?php

/**
 * Explicit route registration boundary for the future fiscal domain.
 *
 * Increment 0 intentionally registers no route. Future routes must be added
 * here with their HTTP verb, controller, filters, and permissions stated
 * explicitly. They must never rely on RISE's dynamic controller discovery.
 *
 * @var \CodeIgniter\Router\RouteCollection $routes
 */
$routes->get('fiscal/client-profiles/(:num)', 'Fiscal\ClientProfiles::index/$1');
$routes->post('fiscal/client-profiles/list/(:num)', 'Fiscal\ClientProfiles::list_data/$1');
$routes->post('fiscal/client-profiles/form', 'Fiscal\ClientProfiles::form');
$routes->post('fiscal/client-profiles/save', 'Fiscal\ClientProfiles::save');
$routes->post('fiscal/client-profiles/default', 'Fiscal\ClientProfiles::set_default');
$routes->post('fiscal/client-profiles/deactivate', 'Fiscal\ClientProfiles::deactivate');
$routes->post('fiscal/items/form', 'Fiscal\ItemSettings::form');
$routes->post('fiscal/items/save', 'Fiscal\ItemSettings::save');
$routes->get('fiscal/items/readiness/(:num)', 'Fiscal\ItemSettings::readiness/$1');
$routes->post('fiscal/catalogs/product-service/search', 'Fiscal\ItemSettings::search_products');
$routes->post('fiscal/catalogs/units/search', 'Fiscal\ItemSettings::search_units');
$routes->post('fiscal/items/deactivate', 'Fiscal\ItemSettings::deactivate');
$routes->post('fiscal/items/activate', 'Fiscal\ItemSettings::activate');
$routes->get('fiscal/invoices/review/(:num)', 'Fiscal\InvoiceReview::show/$1');
