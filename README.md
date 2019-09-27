# qqospath
Compose a command line argument in Windows using input variables from Prolog. 

EXAMPLE 0.5:
(Part of a in-house software that builds a command line argument in Windows 10) 
Ffmpeg.exe and ffplay.exe will show a zoom in-effect using some input image
``` prolog
(debugging(ffzoompan(report))-> DEBUG=' -report -nostats';DEBUG=''),
    atomic_list_concat( {|ospath(FFMPEG,FFPLAY,DEBUG,FPS,BL1,BL2,STEP,SCALER,IMG,WIDo,HEIo,XX,YY,MAXRECT)
||cmd /C" "FFMPEG " DEBUG -i "IMG"  -an -pixel_format yuv444p -filter_complex
   "[0:0] scale=w=SCALER*WIDo:h=SCALER*HEIo,
   zoompan@1=z=zoom+STEP
   :x=  (XX*(zoom+STEP)-XX)/(zoom+STEP):y= (YY*(zoom+STEP)-YY)  /(zoom+STEP):d=375:s=WIDoxHEIo:fps=FPS,

   scale=h='if(lte(a,1.0),MAXRECT,-1)':w='if(lte(a,1.0),-1,MAXRECT)',

     scale=
       h='if(lte(a,1.0),MAXRECT,-1)':
       w='if(lte(a,1.0),-1,MAXRECT)',
         split=3[c1][b1][c2];

     [c2]copy@str0,BL2      [d1];
     [b1]copy@str1,BL1 [k1];
     [c1]copy@str2,
     sendcmd=
       '13.0  [enter] streamselect map 1;
        26.0  [enter] streamselect map 0',
     [d1][k1]streamselect=inputs=3:map=2,

     tpad=stop_mode=clone:stop=2*FPS[out]"
     -map "[out]"  -vcodec h264_qsv -f mpegts pipe: |
     "FFPLAY" -y 750  -autoexit
         -i pipe: -vcodec h264_qsv -f mpegts "|},Comm),

debug(ffzoompan(command),'~@',write_comm(Comm)),
     with_output_to(atom(Comm2),write_comm(Comm)),
     shell(Comm2,_),
     (   debugging(ffzoompan(report))->lastlog;true).

```
Example of a result for cmd.exe
``` cmd.exe
cmd /C" "c:\Program Files\ffmpeg-20190805-5ac28e9-win64-static\bin\ffmpeg.exe " -i "example.jpg" -an -pixel_format yuv444p -filter_complex "[0:0] scale=w=4*530:h=4*800, zoompan@1=z=zoom+2*1/375 :x= (1253*(zoom+2*1/375)-1253)/(zoom+2*1/375):y= (1307*(zoom+2*1/375)-1307) /(zoom+2*1/375):d=375:s=530x800:fps=10, scale=h='if(lte(a,1.0),1000,-1)':w='if(lte(a,1.0),-1,1000)', scale= h='if(lte(a,1.0),1000,-1)': w='if(lte(a,1.0),-1,1000)', split=3[c1][b1][c2]; [c2]copy@str0,smartblur=luma_threshold=-15.0 [d1]; [b1]copy@str1,smartblur=luma_threshold= 0.0 [k1]; [c1]copy@str2, sendcmd= '13.0 [enter] streamselect map 1; 26.0 [enter] streamselect map 0', [d1][k1]streamselect=inputs=3:map=2, tpad=stop_mode=clone:stop=2*10[out]" -map "[out]" -vcodec h264_qsv -f mpegts pipe: | "c:\Program Files\ffmpeg-20190805-5ac28e9-win64-static\bin\ffplay.exe" -y 750 -autoexit -i pipe: -vcodec h264_qsv -f mpegts
```
EXAMPLE1:
Compose a command that can be be used with shell/1

``` prolog
?- MSG='hello world',  atomic_list_concat(  {|ospath(MSG)||echo MSG |}   ,Command).
Command = 'echo hello world '. %copy and paste to Windows prompt
```

```
C:\> echo hello world 
hello world
```
 
EXAMPLE2:
It is possible to write anything to ospath, because syntax is not checked. Not checking the syntax is illogical, this would not be acceptable at planet Vulcan! 
``` prolog
?- A= {|ospath||C:\program files (x86)\swipl|}. %Wow thats cool!! I can write a line with 
                                                %Windows command line syntax inside a prolog file :) :) 
A = ['C:\\program files (x86)\\swipl'].
```

EXAMPLE3:
``` prolog
?- Var=swipl,  A={|ospath(Var)||c:\program files (x86)\Var|}.
Var = swipl,
A = ['c:\\program files (x86)\\', swipl].
```

EXAMPLE4: (Github gets confused when trying to understand this prolog code??)
``` prolog
?- Testvariable=xxx, 
  AnotherVariable=yyy,
  A={|ospath(Testvariable,AnotherVariable)||Testvariable\sometext_here\AnotherVariable|}.
Testvariable = xxx,
AnotherVariable = yyy,
A = [xxx, '\sometext_here\', yyy].
```


