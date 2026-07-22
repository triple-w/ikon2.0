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
