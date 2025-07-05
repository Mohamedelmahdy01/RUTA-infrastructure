# GitHub Secrets Setup Script for Windows
# This script helps you generate and set up the required GitHub secrets for the deployment workflow

param(
    [switch]$Force
)

# Function to print colored output
function Write-Info {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host " $Message" -ForegroundColor Red
}

# Check if gh CLI is installed
function Test-GitHubCLI {
    try {
        $null = Get-Command gh -ErrorAction Stop
        Write-Success "GitHub CLI is installed"
        
        # Check if authenticated
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "GitHub CLI is authenticated"
        } else {
            Write-Error "You are not authenticated with GitHub CLI."
            Write-Host "Please run: gh auth login" -ForegroundColor Yellow
            exit 1
        }
    } catch {
        Write-Error "GitHub CLI (gh) is not installed."
        Write-Host "Please install it from: https://cli.github.com/" -ForegroundColor Yellow
        exit 1
    }
}

# Generate SSH key pair
function New-SSHKey {
    $keyName = "ruta-deploy-key"
    $keyFile = "$env:USERPROFILE\.ssh\$keyName"
    
    if (Test-Path $keyFile) {
        Write-Warning "SSH key already exists at $keyFile"
        if (-not $Force) {
            $overwrite = Read-Host "Do you want to overwrite it? (y/N)"
            if ($overwrite -notmatch "^[Yy]$") {
                Write-Info "Using existing SSH key"
                return $keyFile
            }
        }
    }
    
    Write-Info "Generating SSH key pair..."
    
    # Create .ssh directory if it doesn't exist
    $sshDir = "$env:USERPROFILE\.ssh"
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    }
    
    # Generate SSH key using ssh-keygen
    try {
        ssh-keygen -t rsa -b 4096 -f $keyFile -N '""' -C "ruta-deployment"
        Write-Success "SSH key generated at $keyFile"
    } catch {
        Write-Error "Failed to generate SSH key. Make sure OpenSSH is installed."
        Write-Host "You can install OpenSSH from Windows Features or use WSL." -ForegroundColor Yellow
        exit 1
    }
    
    return $keyFile
}

# Generate database password
function New-DatabasePassword {
    $bytes = New-Object Byte[] 32
    (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes)
    $password = [Convert]::ToBase64String($bytes) -replace '[=+/]', '' | Select-Object -First 25
    return $password
}

# Display secrets setup instructions
function Show-SecretsInstructions {
    param(
        [string]$SSHKeyFile,
        [string]$DBPassword
    )
    
    Write-Host ""
    Write-Host " Required GitHub Secrets" -ForegroundColor Cyan
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please add the following secrets to your GitHub repository:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. AWS Credentials:" -ForegroundColor Yellow
    Write-Host "   - AWS_ACCESS_KEY_ID: Your AWS access key" -ForegroundColor Gray
    Write-Host "   - AWS_SECRET_ACCESS_KEY: Your AWS secret access key" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Database Credentials:" -ForegroundColor Yellow
    Write-Host "   - DB_PASSWORD: $DBPassword" -ForegroundColor Gray
    Write-Host "   - DB_NAME: ruta_db" -ForegroundColor Gray
    Write-Host "   - DB_USER: admin" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. SSH Access:" -ForegroundColor Yellow
    
    if (Test-Path $SSHKeyFile) {
        $privateKey = Get-Content $SSHKeyFile -Raw
        Write-Host "   - SSH_PRIVATE_KEY: $privateKey" -ForegroundColor Gray
    } else {
        Write-Host "   - SSH_PRIVATE_KEY: [Content of $SSHKeyFile]" -ForegroundColor Gray
    }
    
    Write-Host "   - EC2_KEY_NAME: ruta-deploy-key" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🔧 How to add secrets:" -ForegroundColor Cyan
    Write-Host "1. Go to your GitHub repository" -ForegroundColor White
    Write-Host "2. Click Settings > Secrets and variables > Actions" -ForegroundColor White
    Write-Host "3. Click 'New repository secret'" -ForegroundColor White
    Write-Host "4. Add each secret with the exact name and value shown above" -ForegroundColor White
    Write-Host ""
    Write-Host " AWS Setup Instructions:" -ForegroundColor Cyan
    Write-Host "1. Create an IAM user with the following permissions:" -ForegroundColor White
    Write-Host "   - AmazonEC2FullAccess" -ForegroundColor Gray
    Write-Host "   - AmazonRDSFullAccess" -ForegroundColor Gray
    Write-Host "   - AmazonS3FullAccess" -ForegroundColor Gray
    Write-Host "   - AmazonCloudFrontFullAccess" -ForegroundColor Gray
    Write-Host "   - AmazonVPCFullAccess" -ForegroundColor Gray
    Write-Host "   - AmazonIAMFullAccess" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Generate access keys for the IAM user" -ForegroundColor White
    Write-Host "3. Add the access keys as GitHub secrets" -ForegroundColor White
    Write-Host ""
    Write-Host " SSH Key Setup:" -ForegroundColor Cyan
    Write-Host "1. The SSH key has been generated at: $SSHKeyFile" -ForegroundColor White
    
    $publicKeyFile = "$SSHKeyFile.pub"
    if (Test-Path $publicKeyFile) {
        $publicKey = Get-Content $publicKeyFile -Raw
        Write-Host "2. Add the public key to your AWS account:" -ForegroundColor White
        Write-Host "   - Go to AWS Console > EC2 > Key Pairs" -ForegroundColor Gray
        Write-Host "   - Create a new key pair named 'ruta-deploy-key'" -ForegroundColor Gray
        Write-Host "   - Or import the public key: $publicKey" -ForegroundColor Gray
    }
    Write-Host ""
}

# Main execution
function Main {
    Write-Host " GitHub Secrets Setup Script for Windows" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Info "Checking prerequisites..."
    Test-GitHubCLI
    
    Write-Info "Generating SSH key pair..."
    $sshKeyFile = New-SSHKey
    
    Write-Info "Generating database password..."
    $dbPassword = New-DatabasePassword
    
    Show-SecretsInstructions -SSHKeyFile $sshKeyFile -DBPassword $dbPassword
    
    Write-Success "Setup complete!"
    Write-Host ""
    Write-Info "Next steps:"
    Write-Host "1. Add all the secrets to your GitHub repository" -ForegroundColor White
    Write-Host "2. Create the AWS key pair" -ForegroundColor White
    Write-Host "3. Push your code to trigger the workflow" -ForegroundColor White
    Write-Host ""
    Write-Warning "Remember to keep your secrets secure and never commit them to version control!"
}

# Run main function
Main 