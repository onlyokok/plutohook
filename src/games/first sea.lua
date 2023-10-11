local reponse = http_request({
    Url = "www.google.com",
    Method = "GET"
})

print(reponse)