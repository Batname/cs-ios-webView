window.injector = window.injector || angular.element(document).injector();
window.rootScope = window.rootScope || injector.get('$rootScope');
window.rootScope.embeddedNative = window.embeddedNative || true;
window.rootScope.native = window.rootScope.native || {};
