/*global angular:false*/
angular.module 'ng-preload-src' <[]>
.service 'ImgPreloader' <[
       $document  $q
]> ++ ($document, $q) ->
  const {element} = angular
  const $parent   = element '<div class="ng-hide"></div>'
 
  $document.find 'body' .append $parent
 
  ImgPreloader::load = ->
    const {url, defer} = @
    const $img = element "<img src='#{ url }'>"
    
    $img.on 'load' !->
      $img.remove!
      defer.resolve url
 
    $parent.append $img
    defer.promise
 
  !function ImgPreloader (@url)
    @defer = $q.defer!
 
.directive 'preloadWithDefaultSrc' <[
       $interpolate  ImgPreloader
]> ++ ($interpolate, ImgPreloader) ->
  const {bind} = angular

  !function changeFn (setter, url)
    new ImgPreloader url .load!then setter
 
  !function postLinkFn ($scope, $element, $attrs) 
    $scope.$watch do
      $interpolate $attrs.preloadSrc
      bind void, changeFn, bind($attrs, $attrs.$set, 'ngSrc')
 
  compile: (tElement, tAttrs) ->
    tAttrs.$set 'preloadSrc' tAttrs.ngSrc
    tAttrs.$set 'ngSrc' tAttrs.preloadWithDefaultSrc
 
    postLinkFn
