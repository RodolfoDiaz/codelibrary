$requestBody = Get-Content $req -Raw | ConvertFrom-Json
 
# Get request body or query string parameter
if ($req_query_name) {
    $name = $req_query_name
} else {
    $name = $requestBody.name
}
 
$response = @{
    time = [System.DateTime]::UtcNow.ToString('u')
    Message = "Hello $name"
} | ConvertTo-Json
 
Out-File -InputObject $response -FilePath $res -Encoding Ascii