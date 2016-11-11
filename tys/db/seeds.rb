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
  { application_name: 'app_2', author: users[2].name, programming_language: 'C#', github_repository: 'AnSlvt/test_repo', authorization_token: tokens[1] },
  { application_name: 'APITest', author: users[2].name, programming_language: 'C#', github_repository: 'AnSlvt/test_repo', authorization_token: 'UZz5xTEUjs7YoW2hQhCKxw' }
])

anslvt_apps.each do |app|
  app.users << users[2]
end

leo_app = Application.create( application_name: 'app_1', author: users[0].name, programming_language: 'C#', github_repository: 'LeonardoPetrucci/toy_app', authorization_token: tokens[2] )
leo_app.users << users[0]

StackTrace.create!( application_id: leo_app.id, stack_trace_text: "argument type mismatch\n
    at org.apache.axis.AxisFault.makeFault(AxisFault.java:101)\n
    at org.apache.axis.client.Call.invoke(Call.java:2470)\n
    at org.apache.axis.client.Call.invoke(Call.java:2366)\n
    at org.apache.axis.client.Call.invoke(Call.java:1812)\n
    at com.hps.webservice.SOAPInterfaceBindingStub.getStatus(SOAPInterfaceBindingStub.java:852)\n
    at com.hps.ws.HPSStatusManagerJob.getApplicationStatusResponse(HPSStatusManagerJob.java:265)\n
    at com.hps.ws.HPSStatusManagerJob.updateStatus(HPSStatusManagerJob.java:84)\n
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\n
    at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)\n
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)\n
    at java.lang.reflect.Method.invoke(Unknown Source)\n
    at org.springframework.util.MethodInvoker.invoke(MethodInvoker.java:273)", stack_trace_message: "ExampleException\n", application_version: "1.1.1.1", crash_time: "23", error_type: "Sample")
