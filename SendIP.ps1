# Initializing a variable to track the connection status
$connected = $false

# Loop until an internet connection is established
while (-not $connected) {
    try {
        # Attempt to ping a known website to test the connection
        $ping = Test-Connection -ComputerName www.apple.com -Count 1 -ErrorAction Stop
        $connected = $true
    } catch {
        # If the ping fails, wait for 5 seconds before retrying
        Write-Host "Waiting for Internet connection..."
        Start-Sleep -Seconds 5
    }
}

# SMTP server details
$smtpServer = "smtp.yourdomain.com" # Replace with your SMTP server address
$smtpPort = 587 # SMTP port, typically 587 for TLS
$smtpUser = "yourUsername" # Your SMTP username
$smtpPass = "yourPassword" # Your SMTP password

# Email details
$to = "recipient@example.com" # Recipient's email address
$from = "sender@example.com" # Sender's email address
$subject = "Startup IP Address" # Subject of the email

# Retrieving IPv6 addresses of the system
$ipAddresses = Get-NetIPAddress
$ipv6Addresses = $ipAddresses | Where-Object { $_.AddressFamily -eq 'IPv6' }
$body = $ipv6Addresses

# Setting up the SMTP client
$smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtpClient.EnableSsl = $true # Enabling SSL for secure email sending
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)

# Sending the email
$smtpClient.Send($from, $to, $subject, $body)
