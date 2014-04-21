/*! ng-preload-src - v 0.0.1 - Mon Apr 21 2014 20:03:38 GMT+0800 (CST)
 * https://github.com/tomchentw/ng-preload-src
 * Copyright (c) 2014 [tomchentw](https://github.com/tomchentw);
 * Licensed [MIT](http://tomchentw.mit-license.org)
 */
/*global angular:false*/
(function(){
  angular.module('ng-preload-src', []).service('ImgPreloader', ['$document', '$q'].concat(function($document, $q){
    var element, $parent;
    element = angular.element;
    $parent = element('<div class="ng-hide"></div>');
    $document.find('body').append($parent);
    ImgPreloader.prototype.load = function(){
      var url, defer, $img;
      url = this.url, defer = this.defer;
      $img = element("<img src='" + url + "'>");
      $img.on('load', function(){
        $img.remove();
        defer.resolve(url);
      });
      $parent.append($img);
      return defer.promise;
    };
    function ImgPreloader(url){
      this.url = url;
      this.defer = $q.defer();
    }
    return ImgPreloader;
  })).directive('preloadWithDefaultSrc', ['$interpolate', 'ImgPreloader'].concat(function($interpolate, ImgPreloader){
    var bind;
    bind = angular.bind;
    function changeFn(setter, url){
      new ImgPreloader(url).load().then(setter);
    }
    function postLinkFn($scope, $element, $attrs){
      $scope.$watch($interpolate($attrs.preloadSrc), bind(void 8, changeFn, bind($attrs, $attrs.$set, 'ngSrc')));
    }
    return {
      compile: function(tElement, tAttrs){
        tAttrs.$set('preloadSrc', tAttrs.ngSrc);
        tAttrs.$set('ngSrc', tAttrs.preloadWithDefaultSrc);
        return postLinkFn;
      }
    };
  }));
}).call(this);
