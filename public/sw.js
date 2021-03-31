importScripts('https://storage.googleapis.com/workbox-cdn/releases/6.1.1/workbox-sw.js');
workbox.routing.registerRoute(
    new RegExp('/.*'),
    new workbox.strategies.NetworkFirst()
)