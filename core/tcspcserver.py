import socket
import subprocess
import time


HOST = '127.0.0.1'      # Symbolic name meaning the local host
PORT = 50001            # Arbitrary non-privileged port

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(1)
s.bind((HOST, PORT))
s.listen(1)

print "Waiting for connection"
while 1:
	try:
		conn, addr = s.accept()
	except KeyboardInterrupt:
		break
	except:
		print "."
		continue

	print 'Connected by', addr

	print "Waiting for command"
	while 1:
		data = conn.recv(1024)
		command = data.split(";")
		if command[0] == "Exit":
			print "Connection closed by client."
			try: # we need to use try since p doesn't need to exist
				if p.poll() == None:
					p.communicate('q')
			except:
				pass
			break
		if command[0] == "Measure":
			try:
				p = subprocess.Popen(["./recordpt3.exe",command[1]],stdout=PIPE, stderr=PIPE)
				time.sleep(2)
				print p.stdout
			except:
				print "Could not start recordpt3.exe"
				print "Parameter was:" + command[1]
				break
		if command[0] == "Stop":
			p.communicate('q')
	conn.close()

