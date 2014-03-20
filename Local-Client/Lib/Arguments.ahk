/*	From LibCon.ahk Docs

	args is an Object that is used to reference the arguments the script has received.
	The object is created only when the number of arguments is greater than zero.
	Note: if (args) will return true, if the object exists, otherwise, it will return false.

	args.CSV (or args["CSV"]) - Contains the arguments in CSV format.
	args[n] - where 'n' (n>0) is the n'th argument
	args[0] - is equal to argc
	
	Note: argc exists only if the args Object exists. It is set to the number of arguments received.
*/

;Get Arguments
if 0 > 0
{
	argc=%0%
	args:=[]
	args[0]:=argc

	Loop, %0%
	{
		args.Insert(%A_Index%)
		args["CSV"]:=args["CSV"] """" %A_Index% "" ((A_Index==args[0]) ? """" : """,")
	}
}