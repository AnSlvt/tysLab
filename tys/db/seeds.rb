# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({ name: 'AnSlvt', email: 'andrea.slvt94@gmail.com' })
application = Application.create({ application_name: 'TSM', author: user.name, programming_language: 'C#', github_repository: 'repo' })
user.applications << application
StackTrace.create([
  { application_id: application.id, device: "Lumia 950XL", stack_trace_message: "Che cazzo è successo!", error_type: "NullReferenceException", stack_trace_text: "at Main.Blam() at Lib.Test()", application_version: "1.0.0.0" },
  { application_id: application.id, device: "Lumia 640", stack_trace_message: "Bubu settete!", error_type: "NullReferenceException", stack_trace_text: "at IPorc.MoveNext() at Main.Run() at Main.Zio()", application_version: "1.1.0.0" },
  { application_id: application.id, device: "Lumia 640", stack_trace_message: "WTF", error_type: "ArgumentPorcoddioException", stack_trace_text: "at Ciao.Cojone() end of previous locations", application_version: "1.1.0.0" }
  ])
