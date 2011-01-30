from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
import urllib2

class Handler(BaseHTTPRequestHandler):
	
	
	#def do_GET(self):
	#	print 'GET' + self.path
	#	self.do_POST()
	#	
	#	return	
	
	def do_POST(self):
		
		params = self.get_params(self.rfile, int(self.headers['Content-Length']))
		url = urllib2.unquote(params['url'])
		
		data = urllib2.urlopen(url, data=None)
		self.wfile.write(data.read())
		
		return
	
	def get_params(self, inputstream, length):
		param_as_stream = inputstream.read(length)
		params_as_array = param_as_stream.split('&')
		
		params = {}
		for p in params_as_array:
			key = p.split('=')[0]
			value = p.split('=')[1]
			
			params[key] = value
		
		return params
	


def main():
	server = HTTPServer(('localhost', 7777), Handler)
	print 'Listening...'
	server.serve_forever()

if __name__ == '__main__':
	main()
