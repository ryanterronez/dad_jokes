$jokeTime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
$jokeApi = "https://icanhazdadjoke.com/"
$headers = @{
'accept' = 'text/plain'
}

function get_dad_joke() {
    function send_request(){
        Invoke-RestMethod -Method Get -uri $jokeApi -Headers $headers -OutFile .\dad_jokes_cache.txt
        $response = Get-Content -Path .\dad_jokes_cache.txt -Encoding UTF8
        $response
    }
    $joke = send_request
    $dad_jokes = Get-Content -Path .\dad_jokes.txt
    $bad_jokes = Get-Content -Path .\bad_jokes.txt
    while ($dad_jokes -contains $joke -or $bad_jokes -contains $joke)
    {
        Write-Host "Match found"
        $joke = send_request
    }
    $msgBoxInput = [System.Windows.MessageBox]::Show("$joke`r`n`r`nWas this joke funny?","Dad joke for $jokeTime",'YesNoCancel','Error')
    switch  ($msgBoxInput) 
    {
        'Yes' {$joke | Out-File .\dad_jokes.txt -Append utf8}
        'No' {$joke | Out-File .\bad_jokes.txt -Append utf8}
        'Cancel' {}
    }
    $joke | Write-Host
}

get_dad_joke