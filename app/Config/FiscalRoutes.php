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
$routes->post('fiscal/invoices/review/(:num)', 'Fiscal\InvoiceReview::show/$1');
$routes->post('fiscal/invoices/pricing/apply', 'Fiscal\InvoiceReview::apply');
$routes->post('fiscal/invoices/drafts/create', 'Fiscal\InvoiceReview::create_draft');
$routes->post('fiscal/invoices/drafts/(:num)/view', 'Fiscal\InvoiceReview::draft/$1');
$routes->post('fiscal/invoices/drafts/action', 'Fiscal\InvoiceReview::draft_action');
$routes->post('fiscal/invoices/prexml/generate', 'Fiscal\InvoiceReview::generate_prexml');
$routes->post('fiscal/invoices/prexml/view/(:num)', 'Fiscal\InvoiceReview::view_prexml/$1');
$routes->get('fiscal/invoices/prexml/download/(:num)', 'Fiscal\InvoiceReview::download_prexml/$1');
$routes->post('fiscal/invoices/prexml/validate', 'Fiscal\InvoiceReview::validate_prexml');
$routes->post('fiscal/invoices/sign', 'Fiscal\InvoiceReview::sign_xml');
$routes->post('fiscal/invoices/signed/view/(:num)', 'Fiscal\InvoiceReview::view_signed_xml/$1');
$routes->get('fiscal/invoices/signed/download/(:num)', 'Fiscal\InvoiceReview::download_signed_xml/$1');
$routes->get('fiscal/issuers', 'Fiscal\Issuers::index');
$routes->post('fiscal/issuers/list', 'Fiscal\Issuers::list_data');
$routes->post('fiscal/issuers/form', 'Fiscal\Issuers::form');
$routes->post('fiscal/issuers/save', 'Fiscal\Issuers::save');
$routes->post('fiscal/issuers/default', 'Fiscal\Issuers::set_default');
$routes->post('fiscal/issuers/deactivate', 'Fiscal\Issuers::deactivate');
$routes->get('fiscal/issuers/(:num)/certificates', 'Fiscal\Certificates::index/$1');
$routes->post('fiscal/certificates/list/(:num)', 'Fiscal\Certificates::list_data/$1');
$routes->post('fiscal/certificates/form', 'Fiscal\Certificates::form');
$routes->post('fiscal/certificates/upload', 'Fiscal\Certificates::upload');
$routes->post('fiscal/certificates/deactivate', 'Fiscal\Certificates::deactivate');
$routes->get('fiscal/series', 'Fiscal\Series::index');
$routes->post('fiscal/series/list', 'Fiscal\Series::list_data');
$routes->post('fiscal/series/form', 'Fiscal\Series::form');
$routes->post('fiscal/series/save', 'Fiscal\Series::save');
$routes->post('fiscal/series/deactivate', 'Fiscal\Series::deactivate');
