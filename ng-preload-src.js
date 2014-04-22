/*! ng-preload-src - v 0.0.2 - Wed Apr 23 2014 02:59:17 GMT+0800 (CST)
 * https://github.com/tomchentw/ng-preload-src
 * Copyright (c) 2014 [tomchentw](https://github.com/tomchentw);
 * Licensed [MIT](http://tomchentw.mit-license.org)
 */
/*global angular:false*/
(function(angular, bind, noop){
  angular.module('ng-preload-src', []).factory('$image', ['$window', '$q', '$injector'].concat(function($window, $q, $injector){
    var cfpLoadingBar;
    cfpLoadingBar = $injector.get('cfpLoadingBar') || {
      start: noop,
      complete: noop
    };
    function onLoadEvent(url){
      cfpLoadingBar.complete();
      this.resolve(url);
    }
    return {
      preload: function(url){
        var defer, image;
        defer = $q.defer();
        image = new $window.Image;
        image.src = url;
        cfpLoadingBar.start(0);
        angular.element(image).on('load', bind(defer, onLoadEvent, url));
        return defer.promise;
      }
    };
  })).directive('preloadWithDefaultSrc', ['$interpolate', '$image'].concat(function($interpolate, $image){
    var PreloadCtrl;
    PreloadCtrl = (function(){
      PreloadCtrl.displayName = 'PreloadCtrl';
      var prototype = PreloadCtrl.prototype, constructor = PreloadCtrl;
      prototype.onSrcChanged = function(newUrl){
        this.$attrs.$set('ngSrc', this.$attrs.preloadWithDefaultSrc);
        this.lastUrl = newUrl;
        $image.preload(newUrl).then(this.onImageLoaded);
      };
      prototype.onImageLoaded = function(newUrl){
        if (this.lastUrl === newUrl) {
          this.$attrs.$set('ngSrc', newUrl);
        }
      };
      PreloadCtrl.$inject = ['$scope', '$attrs'];
      function PreloadCtrl($scope, $attrs){
        this.$scope = $scope;
        this.$attrs = $attrs;
        this.lastUrl = void 8;
        this.onImageLoaded = bind(this, this.onImageLoaded);
        $scope.$watch($interpolate($attrs.preloadSrc), bind(this, this.onSrcChanged));
      }
      return PreloadCtrl;
    }());
    return {
      controller: PreloadCtrl,
      compile: function(tElement, tAttrs){
        tAttrs.$set('preloadSrc', tAttrs.ngSrc);
        tAttrs.$set('ngSrc', tAttrs.preloadWithDefaultSrc);
      }
    };
  }));
}.call(this, angular, angular.bind, angular.noop));