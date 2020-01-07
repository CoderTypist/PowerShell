
# imports
. .\class_Backup.ps1

# usage information
function usage {

    echo "`nCreates backup"
    echo ".\backup <backup_option>`n"

    echo "`nLists backup options"
    echo ".\backup list`n"
}

# lists all backup options
function listBackups {
    
    echo "`nBackup Options:`n"
    foreach ($item in $all_Backups) {
        $item.toString()
    }
    exit
}

#------------------------ ANY MODIFICATIONS GO HERE ------------------------#

# backups will be stored here
# $dest = "D:\"
$dest = "C:\Users\Coder Typist\Documents\PowerShell\Backup_Script\Backups"

# default number of backups
$numBackups = 3

# list of all backup options
# [Backup[]]$all_Backups = @()
$all_Backups = @()

# backup options
$backup_Documents = [Backup]::new("Documents", $env:ComputerName, $dest, $numBackups)
$backup_Drive = [Backup]::new("Drive", "Google_Drive", $dest, $numBackups)
$backup_Test = [Backup]::new("Test", "PowerShell_Examples", $dest, $numBackups)

# backup Documents
$backup_Documents.add("C:\Users\$env:UserName\Documents")
$backup_Documents.add("C:\Users\$env:UserName\Desktop")
$backup_Documents.add("C:\Users\$env:UserName\Pictures")
$backup_Documents.add("C:\Users\$env:UserName\Videos")
$backup_Documents.add("C:\Users\$env:UserName\Downloads")

# backup Google Drive
$backup_Drive.add("C:\Users\$env:UserName\Google Drive")

# backup Testing
$backup_Test.add("C:\Users\$env:UserName\Documents\PowerShell_Examples")

# add all backup options to list
$all_Backups += $backup_Documents
$all_Backups += $backup_Drive
$all_Backups += $backup_Test

#-------------------- SHOULD NOT MODIFY AFTER THIS POINT -------------------#

# user selected backup option
$cur_Backup = $null

# if no arguments are provided
if ( !$args ) {
    usage
    exit
}

# list backup options
if ( $args[0].tolower().equals("list") ) {
    listBackups
    exit
}

# select backup option from user input
foreach ( $item in $all_Backups ) {

    if( $args[0].toLower().equals($item.backupName.toLower()) ){
        $cur_Backup = $item
        break
    }
}

# if an invalid backup option was selected
if ( !$cur_Backup ) {

    Write-Host "`n  Invalid backup option: " -NoNewLine
    echo $args[0]
    listBackups
    exit
}

# if none of the folders to backup exist
if ( $false -eq $cur_Backup.canBackup() ) {

    echo "`n  None of the target directories exist."
    echo "  No backups were made.`n"
    $cur_Backup.toString()
    exit
}

# create backup
$cur_Backup.createBackup()

# $var = get-date -format "_MM_dd_yy_HH_mm"