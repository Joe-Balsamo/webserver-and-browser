require 'socket'
require 'json'

server = TCPServer.open(2000)
loop do
  client = server.accept
  
  begin
    request = client.gets.split(" ")
  
    if request[0]=="GET"
      
      begin
        file_to_read = File.open(request[1][1..-1])
        client.puts "#{request[2]} 200 OK"
        client.puts "Date: #{Time.now.ctime}"
        client.puts "Content-Length: #{file_to_read.size}"
        file_to_read.each { |line| client.puts line }
      rescue
        client.puts "#{request[2]} 404 File Not Found"
      end
  
    elsif request[0]=="POST"
  
      begin
        params = JSON.parse(request[-1])
        name = params["viking"]["name"]
        name.gsub!("_"," ") if name.include?("_")
        email = params["viking"]["email"]
        file_to_read = File.open(request[1][1..-1])
        
        client.puts "#{request[2]} 200 OK"
        client.puts "Date: #{Time.now.ctime}"
        client.puts "Content-Length: #{file_to_read.size}"
        file_to_read.each do |line| 
          if line.include?("<%= yield %>")
            client.puts "      <li>Name: #{name}</li>\n      <li>Email: #{email}</li>"
          else
            client.puts line
          end
        end
      rescue Exception => e  
        puts e.message 
        client.puts "#{request[2]} 404 File Not Found"
      end

    else
      client.puts "Error: wrong request method."
    end
  rescue
    client.puts "Error: no request sent"
  end
  
  client.close
end
