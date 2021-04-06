# Andrew Cross PS Port scanning utility, last iteration FA20

# Get initial values/locations for IP List and preffered IP Range
$ErrorActionPreference= 'silentlycontinue'
$ipinput = Read-Host -Prompt 'Input file location for IP List (Example: list.txt (if in working directory))'
[string[]]$iparray = Get-Content -Path $ipinput #Store IP list as an array
$iparray = $iparray.split(',') #Split at , character to parse second list
$port1 = Read-Host -Prompt 'Please input starting port (Leave blank and hit enter to continue with default value of 80'
$port2 = Read-Host -Prompt 'Please input ending port (Leave blank and hit enter to continue with default value of 443'

#If ports left empty, default to these values
If (!$port1  -and !$port2) {
    $port1 = 80
    $port2 = 443
}
#Take port input and create array of all numbers between, as well as the input
$range = $port1..$port2

#output port range and check for existance of existing results file, remove if existing
write-host "Using port range:" $port1 " to " $port2
Write-host "Checking for existing result file"

#Check for existing results output
If (Test-Path -Path ".\documents\results.txt") {
    Remove-item .\documents\results.txt
    write-Host "Results.txt Found, removing and creating fresh result file" -BackgroundColor Green
}else{
    Write-Host "Results.txt not found, continuing" -BackgroundColor Green
}

#Output transcript to results.txt in documents directory
Start-Transcript -Path ".\documents\results.txt"
#Nested loop for working through each IP with each port in range
foreach($ip in $iparray) {
   Write-Host "Attempting to ping" $ip
    if(Test-Connection -ComputerName $ip){ #Ping IP, if ping receives a response, continue
       Write-Host "Response from " $ip " received, scanning ports" 
       ForEach($port in $range){ #loop through each port in given range
        $portscan = New-Object Net.Sockets.TcpClient
        $portscan.Connect($ip,$port) #attempt connection with IP and port
        if(($portscan).Connected){
            Write-Host "Successfully connected to " $ip ":" $port -BackgroundColor Green
        }
        else {
            Write-Host "Could not connect to " $ip ":" $port -BackgroundColor Red
        }
       }
        
       }
    else {
        Write-Host "Could not receive response from " $ip ", skipping address" -BackgroundColor Red
        }
        
    }
Stop-Transcript
Write-Host "Transcript saved in documents folder"

#End