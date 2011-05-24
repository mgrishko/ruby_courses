#Exercise6. Write a Deaf Grandma program.
#Whatever you say to grandma (whatever you type in), she should respond
#with HUH?! SPEAK UP, SONNY!, unless you shout it (type in all capitals).
#If you shout, she can hear you (or at least she thinks so) and yells back,
#NO, NOT SINCE 1938! To make your program really believable, have grandma
#shout a different year each time; maybe any year at random between 1930
#and 1950. You can't stop talking to grandma until you shout BYE.
#
#Adapted from Chris Pine's Book.
#
#For example:
#
#You enter: Hello Grandma
#Grandma responds: HUH?! SPEAK UP, SONNY!
#You enter: HELLO GRANDMA
#Grandma responds: NO, NOT SINCE 1938!

#Exercise3. Call this program (p026zdeafgm2.rb) - Modify your Deaf Grandma program (Week 3 / Exercise6): What if grandma doesn't want you to leave? When you shout BYE, she could pretend not to hear you. Change your previous program so that you have to shout BYE three times in a row. Make sure to test your program: if you shout BYE three times, but not in a row, you should still be talking to grandma. You must shout BYE three separate times. If you shout BYEBYEBYE or BYE BYE BYE, grandma should pretend not to hear you (and not count it as a BYE).

def random_year
  rand(21) + 1930
end

str = ''
until str == "BYE"
  print "Say: "
  str = gets.chomp
  if str == str.downcase
    puts "HUH?! SPEAK UP, SONNY!"
  elsif str == str.upcase 
    puts "NO, NOT SINCE #{random_year}!"
  end
end
