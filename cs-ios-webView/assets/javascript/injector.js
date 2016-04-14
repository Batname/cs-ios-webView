window.injector = angular.element(document).injector();
window.rootScope = injector.get('$rootScope');
window.rootScope.embeddedNative = window.embeddedNative;
window.rootScope.native = window.rootScope.native || {};
