#Exercise4. Write a Ruby program (call it p028swapcontents.rb) to do the following. Take two text files say A and B. The program should swap the contents of A and B. That is after the program is executed, A should contain B's contents and B should contains A's contents.
content_a = IO.read('a.txt')
content_b = IO.read('b.txt')

file_a, file_b = File.open('a.txt', 'w'), File.open('b.txt', 'w')

file_a.write(content_b)
file_b.write(content_a)

file_a.close
file_b.close
