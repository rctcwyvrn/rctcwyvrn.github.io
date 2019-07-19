import glob

for filename in glob.glob('*.md'):
	file = open(filename)
	lines = file.readlines()
	print("checking file=",filename)
	if len(lines) > 1 and len(lines[0]) >=5 and lines[0][:5] == "tags:":
		new_file = lines[1] # should be '---'
		tags = lines[0].split()
		for tag in tags:
			if tag != "tags:":
				new_file+=(tag + "_tag: yes\n")
		for line in lines[2:]:
			new_file+=line
		print(new_file)

		x = open(filename, 'w')
		x.write(new_file)

