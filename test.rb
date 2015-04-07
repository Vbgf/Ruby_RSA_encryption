require 'openssl'

# Creates a public-private keypair for interal use
def create_keypair(bitrate=4096)
	keypair = OpenSSL::PKey::RSA::generate(bitrate)
	puts "Keypair created sucessfully!"
	return keypair
end

# Imports public key from a file
def import_public_key(filename)
	pubkey = OpenSSL::PKey::RSA.new File.read filename
	puts "Public key imported sucessfully!"
	return pubkey
end

# Exports public key to a file
def export_public_key(keypair)
	open 'public_key.pem', 'w' do |io|
		io.write keypair.public_key.to_pem
	end
	puts "Public key exported sucessfully!"
end

# Imports a private key from a file
def import_private_key(filename)
	prkey = OpenSSL::PKey::RSA.new File.read filename
	puts "Private key imported sucessfully!"
	return prkey
end

# Exports a priavte key to a file
def export_private_key(keypair)
	open 'private_key.pem', 'w' do |io|
		io.write keypair.to_pem
	end
	puts "Private key exported sucessfully!"
end

# Decrypts a message from a crypted file
def decrypt_message(keypair, filename)
	crypt = File.read filename
	decrypt = keypair.private_decrypt(crypt)
	puts "Message decrypted sucessfully!\n\n"
	print "Message: "
	puts decrypt
	puts "\n"
end

# Makes a crypted file from short console message input
def encrypt_message(pubkey, filename = 'crypt.pem')
	print "Enter a short message: "
	crypt = pubkey.public_encrypt(gets.chomp)
	open filename, 'w' do |io| 
		io.write crypt
	end
	puts "Message encrypted sucessfully!"
end

# Guidence for the gui
def help()
	puts "Welcome to the help menu!"
	puts "Type 'create' to create a keypair"
	puts "Type 'import public' to import a public key from a file"
	puts "Type 'export public' to export a public key to a file"
	puts "Type 'import private' to import a private key from a file"
	puts "Type 'export private' to export a private key to a file"
	puts "Type 'decrypt' to decrypt a file"
	puts "Type 'encrypt' to encrypt a short message to a file"
	puts "Type 'exit' to exit the program"
end

# The main function, bad habbit from C and C++
def main()
	puts "\nWelcome to the encrypt/decrypt program!"
	puts "Type 'help' for some guidence.\n\n"
	while(1) do
		print "Choose an action: "
		case gets.chomp.downcase
		when "create"
			keypair = create_keypair()
		when "import public"
			print "Where is the file?: "
			pubkey = import_public_key(gets.chomp)
		when "export public"
			if keypair != nil
				export_public_key(keypair)
			else
				puts "You need a keypair for this! Generate it with 'create'"
			end
		when "import private"
			print "Where is the file?: "
			prkey = import_private_key(gets.chomp)
		when "export private"
			if keypair != nil
				export_private_key(keypair)
			else
				puts "You need a keypair for this! Generate it with 'create'"
			end
		when "decrypt"
			print "Type 'created' to use the created keypair for decrypting",
			" 'imported' to use the imported one",
			" or exit to cancel the decryption process: "
			while(1) do
				case gets.chomp.downcase
				when "created"
					if keypair != nil
						print "Where is the file?: "
						decrypt_message(keypair, gets.chomp)
					else
						print "You need a keypair for this.",
						" Generate it with 'create'!"
					end
					break
				when "imported"
					if prkey != nil
						print "Where is the file?: "
						decrypt_message(prkey, gets.chomp)
					else
						print "You need to import a private key ",
						" for this. Import it with 'import private'!"
					end
					break
				when "exit"
					break
				else 
					puts "Sorry, no such command found!"
				end
			end
		when "encrypt"
			print "Type 'created' to use the created keypair for encrypting,",
			" 'imported' to use the imported one",
			" or exit to cancel the encryption process: "
			while(1) do
				case gets.chomp.downcase
				when "created"
					if keypair != nil
						encrypt_message(keypair)
					else
						print "You need a keypair for this.",
						" Generate it with 'create'!"
					end
					break
				when "imported"
					if pubkey != nil
						encrypt_message(pubkey)
					else
						print "You need a public key for this.",
						" Import it with 'import public'!"
					end
					break
				when "exit"
					break
				when ""
				else 
					puts "Sorry, no such command found!"
				end
			end
		when "help"
			help()
		when "exit"
			puts "Goodbye!"
			return
		else
			puts "Sorry, no such command found!"
		end
	end
end

main
