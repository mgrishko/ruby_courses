#Exercise5. Given a string s = 'key=value', create two strings s1 and s2
#such that s1 contains key and s2 contains value.
#Hint: Use some of the String functions.
#
#variant1:


s = "key=value"
s1, s2 = s.split("=")
puts s1
puts s2

#variant2:

s = "key=value"
s1, s2 = s.scan(/\w+/)
puts s1, s2
