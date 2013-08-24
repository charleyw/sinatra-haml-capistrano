get "/helloworld" do
  haml :helloworld
end

post "/helloworld" do
  params[:email] + " " + params[:password]
end

get "/test" do
  "test"
end