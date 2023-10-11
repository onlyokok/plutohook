local response = http_request({
    Url = "https://raw.githubusercontent.com/onlyokok/plutohook/main/src/access",
    Method = "GET"
})

if response["StatusCode"] == 200 then
    warn("Successful")
else
    warn("Unsuccessful")
end