# tool_downloader

//deprecated, but the link text is still ok, just not maintained or up to date
the ps1's should continue to work and I'll probably be focusing on putting more of them up

--------------------------------------

I wrote a short perl script that downloads tools based on an attached text file.
If you run it with no options it looks for the link.txt file and then loads up the GUI 

If you run it with -q then it wont use the GUI at all and just download everything in the links file.
You can exclude downloads by putting a # at the beginning of the line

It doesn't do a great job of running all the downloads concurrently, nor does it give an indication of the download. 
If someone else wants to make improvements (or just take the idea and make a better tool) then go for it

I'll try remember to update the links.txt file, but pull request for anything not on there or not up to date :)

Installation:
ppm install Win32-GUI

may require other libraries that aren't default, will have to test later
