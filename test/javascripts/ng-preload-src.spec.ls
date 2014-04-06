(...) <-! describe 'module ng-preload-src'
it 'should be defined' !(...) ->
  expect tc-ng-boilerplate .toBeDefined!

it 'should return true value' !(...) ->
  const value = tc-ng-boilerplate {}
  expect value .toEqual true

it 'should return false value' !(...) ->
  const value = tc-ng-boilerplate ''
  expect value .toEqual false