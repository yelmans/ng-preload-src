/*global angular:false*/
let angular = angular, bind = angular.bind, noop = angular.noop
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
        .on 'load' bind(defer, defer.resolve, url)

      defer.promise
   
  .directive 'preloadWithDefaultSrc' <[
         $interpolate  $image  $injector  $timeout
  ]> ++ ($interpolate, $image, $injector, $timeout) ->

    class PreloadCtrl
      @cfpLoadingBar = $injector.get 'cfpLoadingBar' or do
        start: noop
        set: noop
        complete: noop

      @reqsTotal = @reqsCompleted = 0
      @startTimeout = void

      onSrcChanged: !(newUrl) ->
        @$attrs.$set 'ngSrc', @$attrs.preloadWithDefaultSrc
        @lastUrl = newUrl
        #
        @$scope.$root.$broadcast 'cfpLoadingBar:loading', url: newUrl
        if 0 is @@reqsTotal
          @@startTimeout = $timeout !->
            @@cfpLoadingBar.start!
          , 100
        @@reqsTotal++
        @@cfpLoadingBar.set @@reqsCompleted / @@reqsTotal
        #
        $image.preload newUrl .then @onImagePreloaded

      onImagePreloaded: !(newUrl) ->
        @$attrs.$set 'ngSrc', newUrl if @lastUrl is newUrl

      onLoadEvent: !->
        return unless @lastUrl is @$attrs.ngSrc
        #
        @@reqsCompleted++
        @$scope.$root.$broadcast 'cfpLoadingBar:loaded', url: @lastUrl
        if @@reqsCompleted >= @@reqsTotal
          $timeout.cancel @@startTimeout
          @@cfpLoadingBar.complete!
          @@reqsCompleted = @@reqsTotal = 0
        else
          @@cfpLoadingBar.set @@reqsCompleted / @@reqsTotal

      @$inject = <[
         $scope   $attrs ]>
      !(@$scope, @$attrs) ->

        @lastUrl = void
        @onImagePreloaded = bind @, @onImagePreloaded
        @onLoadEvent = bind @, @onLoadEvent

        $scope.$watch do
          $interpolate $attrs.preloadSrc
          bind @, @onSrcChanged

    !function postLinkFn ($scope, $element, $attrs, preloadCtrl)
      $element.on 'load' preloadCtrl.onLoadEvent

    controller: PreloadCtrl
    require: 'preloadWithDefaultSrc'
    compile: (tElement, tAttrs) ->
      tAttrs.$set 'preloadSrc' tAttrs.ngSrc
      tAttrs.$set 'ngSrc' tAttrs.preloadWithDefaultSrc

      postLinkFn
