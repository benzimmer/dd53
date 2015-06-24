workers Integer(ENV['PUMA_WORKERS'] || 4)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

rackup DefaultRackup
port ENV['PORT'] || '3000'
environment ENV['RACK_ENV'] || 'development'
