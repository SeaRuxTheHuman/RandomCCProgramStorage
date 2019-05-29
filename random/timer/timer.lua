rate=10
IDD=os.startTimer(rate)

while true do
  id,p1=os.pullEvent()
  print(id, p1) 
  if id == "timer" and p1 == IDD then
    IDD=os.startTimer(rate)
    print('BugTest')
  end
end
