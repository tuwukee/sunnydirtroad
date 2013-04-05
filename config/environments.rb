configure :production, :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/sinatra_development')

  ActiveRecord::Base.establish_connection(
    :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => "postgres",
    :database => db.path[1..-1],
    :encoding => 'utf8'
    )
end

after do
  ActiveRecord::Base.connection.close
end