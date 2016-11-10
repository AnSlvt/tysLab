# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([
      { name: 'LeonardoPetrucci', email: 'leonardo.petrucci94@gmail.com' },
      { name: 'Sergio0694', email: 'Sergio0694@live.com' },
      { name: 'AnSlvt', email: 'andrea.slvt94@gmail.com'},
      { name: 'marcozecchini', email: 'marcozecchini.2594@gmail.com' }
])

tokens = []
0..5.times do
  tokens << SecureRandom.urlsafe_base64(nil, true)
end

anslvt_apps = Application.create([
  { application_name: 'app_1', author: users[2].name, programming_language: 'C#', github_repository: 'AnSlvt/test_repo', authorization_token: tokens[0] },
  { application_name: 'app_2', author: users[2].name, programming_language: 'C#', github_repository: 'AnSlvt/test_repo', authorization_token: tokens[1] }
])

anslvt_apps.each do |app|
  app.users << users[2]
end

leo_app = Application.create( application_name: 'app_1', author: users[0].name, programming_language: 'C#', github_repository: 'LeonardoPetrucci/toy_app', authorization_token: tokens[2] )
leo_app.users << users[0]
