(function () {
    var login = '{{ login }}';
    var password = '{{ password }}';
    var isCalled = false;
    function touchAuthorize (callback) {
        if (!isCalled) { callback(login, password); isCalled = true; }
    }
 
    window.rootScope.native.touchAuthorize = touchAuthorize;
 })();