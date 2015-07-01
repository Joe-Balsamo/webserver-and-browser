require 'socket'
require 'json'

host = 'localhost'
port = 2000
params = Hash.new

puts "Which type of request would you like to send? GET or POST"
input = gets.chomp

if input.upcase == "GET"
	request = "Get index.html HTTP/1.0\r\n\r\n"
elsif input.upcase == "POST"

	puts "Please provide a name:"
	name = gets.chomp
	puts "Please provide an email address:"
	email = gets.chomp

	params = {:viking => {:name=>name, :email=>email}}
	body = params.to_json

	request = "Post thanks.html HTTP/1.0\nContent-Length: #{body.length}\r\n\r\n#{body}"
end

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read

headers,body = response.split("\r\n\r\n", 2)
print body
