# encoding: utf-8
module Mule; end

require 'mule/loader/requires'

EM.epoll
EM.kqueue

MULE_NAME = <<-end
    MMMMMMMM               MMMMMMMUUUUUUUU     UUUUUUULLLLLLLLLLL            EEEEEEEEEEEEEEEEEEEEEE
    M:::::::M             M:::::::U::::::U     U::::::L:::::::::L            E::::::::::::::::::::E
    M::::::::M           M::::::::U::::::U     U::::::L:::::::::L            E::::::::::::::::::::E
    M:::::::::M         M:::::::::UU:::::U     U:::::ULL:::::::LL            EE::::::EEEEEEEEE::::E
    M::::::::::M       M::::::::::MU:::::U     U:::::U  L:::::L                E:::::E       EEEEEE
    M:::::::::::M     M:::::::::::MU:::::D     D:::::U  L:::::L                E:::::E             
    M:::::::M::::M   M::::M:::::::MU:::::D     D:::::U  L:::::L                E::::::EEEEEEEEEE   
    M::::::M M::::M M::::M M::::::MU:::::D     D:::::U  L:::::L                E:::::::::::::::E   
    M::::::M  M::::M::::M  M::::::MU:::::D     D:::::U  L:::::L                E:::::::::::::::E   
    M::::::M   M:::::::M   M::::::MU:::::D     D:::::U  L:::::L                E::::::EEEEEEEEEE   
    M::::::M    M:::::M    M::::::MU:::::D     D:::::U  L:::::L                E:::::E             
    M::::::M     MMMMM     M::::::MU::::::U   U::::::U  L:::::L         LLLLLL E:::::E       EEEEEE
    M::::::M               M::::::MU:::::::UUU:::::::ULL:::::::LLLLLLLLL:::::EE::::::EEEEEEEE:::::E
    M::::::M               M::::::M UU:::::::::::::UU L::::::::::::::::::::::E::::::::::::::::::::E
    M::::::M               M::::::M   UU:::::::::UU   L::::::::::::::::::::::E::::::::::::::::::::E
    MMMMMMMM               MMMMMMMM     UUUUUUUUU     LLLLLLLLLLLLLLLLLLLLLLLEEEEEEEEEEEEEEEEEEEEEE
      by Linkedcare
end



EM.run do
  Mule::Service.run
  puts MULE_NAME
  puts "\n"
  puts "Running Mule v.#{Mule::VERSION}"
  puts "Mule listening on port #{Mule::Config[:websocket_port]}"
end