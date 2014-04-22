angular.module 'application' <[
  ui.bootstrap
  ga
  angular-loading-bar
  ng-preload-src
]>
.run <[
        $rootScope
]> ++ !($rootScope) ->

  $rootScope.images = [
    * name: 'iPhone'
      src: 'http://www.hardwareheaven.com/reviewimages/iphone5/full/iphone5_front.jpg'
    * name: 'Mountain'
      src: 'http://www.avo.alaska.edu/images/dbimages/1374610376.jpg'
    * name: 'Dog'
      src: 'http://www.magezinepublishing.com/equipment/images/equipment/D5200-4931/highres/nikon-d5200-sports_1358509383.jpg'
  ]

  $rootScope.image = $rootScope.images.0
