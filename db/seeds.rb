$stdout.sync = true

##################################
# Import countries
##################################
if Ticket.any?
  puts "Skipping ticket import. There are already tickets in the database."
else
  print "Importing tickets"
  tickets_file = File.open(Rails.root.join("import", "tickets.yml"))
  tickets = YAML.load(tickets_file)
  tickets.each do |t|
    t.symbolize_keys!
    Ticket.create(t)
    print "."
  end
  puts "done"
end

# Create default admin user
AdminUser.create! do |a|
  a.email = 'admin@example.com'
  a.password = a.password_confirmation = 'password'
end