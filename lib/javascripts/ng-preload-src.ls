/*global angular:false*/
let angular = angular, bind = angular.bind, noop = angular.noop
  angular.module 'ng-preload-src' <[]>
  .factory '$image' <[
         $window  $q  $injector
  ]> ++ ($window, $q, $injector) ->

    const cfpLoadingBar = $injector.get 'cfpLoadingBar' or do
      start: noop
      complete: noop

    !function onLoadEvent (url)
      cfpLoadingBar.complete!
      @resolve url

    preload: (url) ->
      const defer = $q.defer!
      const image = new $window.Image
      image.src = url
      
      cfpLoadingBar.start 0
      angular
        .element image
        .on 'load' bind(defer, onLoadEvent, url)

      defer.promise
   
  .directive 'preloadWithDefaultSrc' <[
         $interpolate  $image
  ]> ++ ($interpolate, $image) ->

    class PreloadCtrl
      onSrcChanged: !(newUrl) ->
        @$attrs.$set 'ngSrc', @$attrs.preloadWithDefaultSrc
        @lastUrl = newUrl
        $image.preload newUrl .then @onImageLoaded

      onImageLoaded: !(newUrl) ->
        @$attrs.$set 'ngSrc', newUrl if @lastUrl is newUrl

      @$inject = <[
         $scope   $attrs ]>
      !(@$scope, @$attrs) ->

        @lastUrl = void
        @onImageLoaded = bind @, @onImageLoaded

        $scope.$watch do
          $interpolate $attrs.preloadSrc
          bind @, @onSrcChanged

    controller: PreloadCtrl
    compile: !(tElement, tAttrs) ->
      tAttrs.$set 'preloadSrc' tAttrs.ngSrc
      tAttrs.$set 'ngSrc' tAttrs.preloadWithDefaultSrc
