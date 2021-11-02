Recording Link: https://ucsd.zoom.us/rec/share/i1cMB9h72Y3-zxL4WEiddNieEVthgkyDxXM5dhTjCFHF8cgSfO8rjXkTXdM2Y6nr.eEoTK9_-RNmhqO7v
password: 9Dk?uui4

Working programs:
Working programs: Program 1 and 2. We can carry out multiplicative inverse and division and have passed all edge cases we can think of for them. Also, we tested every instruction individually that we created and they all work as expected, so if there’s a failure case then it’s most likely coming from the assembly code we’ve written, but again we tested many edge cases and we believe programs 1 and 2 should work on an exhaustive test.

Programs not working:
Not working: Program 3 does not work because while we implemented our processor we didn’t add a carryout for the twosComp instruction which is needed for program 3 to add two 16 bit numbers and have the carryout from the twosComp. In the interest of not messing up our first two programs we decided to not do program 3. 

Challenges we faced:
The main challenge we faced while implementing our design was branching, to avoid complicated branching we simply decided to manually count and branch to a specific address, so calculating branch target is handled manually by the person writing the assembly to  provide the correct value needed to branch. We used a signed 8 bit value in a register to provide the processor with how far we’re going to branch and if it’s a negative or positive branch. 

Our answer form for programs 1 and 2:
Both programs 1 and 2 use flooring as the final output result.

Testbench:
Mainly we used the test benches provided by the instructional team for both programs 1 and 2. We did make very slight changes to both of them such as restructuring clock on and off signal, adding some displays to see more clear outputs, and finally we set init=0 at the beginning of the initial begin block to turn off the reset signal. And as you can see towards the end of the test benches we are using no rounding result to check against our answer.

CPU Instantiation: 0:31
We forgot to explicitly show our CPU instantiation but it’s visible at 0:31 of our video for a split second. We have also provided an image of that moment in case it’s too hard to see.

Time Stamps:
Overview: 0:00

Program 1:
Test 1: 4:06
Test 2: 10:50

Program 2:
Test 1: 6:35
Test 2: 9:07

How to run code: 
3:20

Email (reach out with any questions to any of the below emails): 
wrafei@ucsd.edu
anh190@ucsd.edu
nanguyen@ucsd.edu

