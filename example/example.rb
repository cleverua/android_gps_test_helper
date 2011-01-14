require File.dirname(__FILE__) + '/../lib/android_emulator'

AndroidEmulator.connect() do
  geofix :lon => -87.651891, :lat => 41.86953, :alt => 0
  wait 2
  geofix :lon => -87.651891, :lat => 41.86953
  wait 2
  geofix '-87.651891 41.86953 0'
  wait 2
  geofix '-87.651891 41.86953'
end