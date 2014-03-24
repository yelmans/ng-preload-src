(...) <-! describe 'ng-preload-src module'
it 'should be defined' !(...) ->
  expect ng-preload-src .toBeDefined!

it 'should return true value' !(...) ->
  const value = ng-preload-src {}
  expect value .toEqual true

it 'should return false value' !(...) ->
  const value = ng-preload-src ''
  expect value .toEqual false