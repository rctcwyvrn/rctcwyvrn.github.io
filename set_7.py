#lETS GOOOOo
#I have 2 hours before boarding my flight, lets see what we can do!
import set_2

def cbc_mac(msg):
	return set_2.aes_cbc_mode_enc(msg)[-1]

def cbc_mac_server(message, IV, MAC):
	parts = message.split("&")
	msg_from = parts[0]
	msg_to = parts[1]
	msg_amount = parts[2]