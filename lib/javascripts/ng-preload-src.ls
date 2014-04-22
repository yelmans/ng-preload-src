/*global angular:false*/
angular.module 'ng-preload-src' <[]>
.factory '$image' <[
       $window  $q
]> ++ ($window, $q) ->

  preload: (url) ->
    const defer = $q.defer!
    const image = new $window.Image
    image.src = url

    angular
      .element image
      .on 'load' angular.bind(defer, defer.resolve, url)

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
      @onImageLoaded = angular.bind @, @onImageLoaded

      $scope.$watch do
        $interpolate $attrs.preloadSrc
        angular.bind @, @onSrcChanged

  controller: PreloadCtrl
  compile: !(tElement, tAttrs) ->
    tAttrs.$set 'preloadSrc' tAttrs.ngSrc
    tAttrs.$set 'ngSrc' tAttrs.preloadWithDefaultSrc
