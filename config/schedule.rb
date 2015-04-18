deploy_to = '/home/hash/deploy/marika'

config = File.read(deploy_to + '/shared/config.dat')
config.split("\n").each do |line|
  key, val = line.split(' ')
  env key, val
end

every 3.days do
  command "source ~/.bashrc; cd #{deploy_to}/current; ruby marika.rb"
end
