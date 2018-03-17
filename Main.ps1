#========================================================================
# Author 	: Kevin RAHETILAHY                                          #
#========================================================================

##############################################################
#                      LOAD ASSEMBLY                         #
##############################################################

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null

[System.Windows.Forms.Application]::EnableVisualStyles()

##############################################################
#                      LOAD FUNCTION                         #
##############################################################
                      

function LoadXml ($Global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml(".\Main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$ShellApp = New-Object -comObject Shell.Application  

##############################################################
#                CONTROL INITIALIZATION                      #
##############################################################

$datagridtest  = $Form.FindName("gridLogs")
$btntest   =  $Form.FindName("btntest")


$okOnly = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::Affirmative

##############################################################
#                FUNCTIONS                                   #
##############################################################

Function Get-Folder(){

    $foldername = [System.Windows.Forms.FolderBrowserDialog]::new()
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}



   $script:observableCollection = [System.Collections.ObjectModel.ObservableCollection[Object]]::new()

    # Row 1
               
    $objArray = New-Object PSObject
    $objArray | Add-Member -type NoteProperty -name ComputerName -value "Computer_03"
    $objArray | Add-Member -type NoteProperty -name IP_Adress -value "192.168.0.0"
    $objArray | Add-Member -type NoteProperty -name Domain -value "Domain0"
    $objArray | Add-Member -type NoteProperty -name Patch -value $true


    $script:observableCollection.Add($objArray) | Out-Null

    # Row 3
    
    $objArray = New-Object PSObject
    $objArray | Add-Member -type NoteProperty -name ComputerName -value "Computer_10"
    $objArray | Add-Member -type NoteProperty -name IP_Adress -value "192.168.1.1"
    $objArray | Add-Member -type NoteProperty -name Domain -value "Domain2"
    $objArray | Add-Member -type NoteProperty -name Patch -value $true

    $script:observableCollection.Add($objArray) | Out-Null


    # Row 2
                   
    $objArray = New-Object PSObject
    $objArray | Add-Member -type NoteProperty -name ComputerName -value "Computer_32"
    $objArray | Add-Member -type NoteProperty -name IP_Adress -value "192.168.2.0"
    $objArray | Add-Member -type NoteProperty -name Domain -value "Domain3"
    $objArray | Add-Member -type NoteProperty -name Patch -value $false

    $script:observableCollection.Add($objArray) | Out-Null


 $datagridtest.ItemsSource = $Script:observableCollection


##############################################################
#                MANAGE EVENT ON PANEL                       #
##############################################################




$xamlDialog  = LoadXml(".\template\Dialog.xaml")
$read=(New-Object System.Xml.XmlNodeReader $xamlDialog)
$Window=[Windows.Markup.XamlReader]::Load( $read )

$CustomDialog = [MahApps.Metro.Controls.Dialogs.CustomDialog]::new($Form)

$BtnClose   = $Window.FindName("BtnClose")
$dialgComputerName   = $Window.FindName("dialgComputerName")
$dialgIPAdress   = $Window.FindName("dialgIPAdress")
$dialgDomain   = $Window.FindName("dialgDomain")
$dialgPatched   = $Window.FindName("dialgPatched")    
    
# Metro Dialog Settings
$settings = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
$settings.ColorScheme = [MahApps.Metro.Controls.Dialogs.MetroDialogColorScheme]::Theme

 
$CustomDialog.AddChild($Window)


# get value from custom dialog
$BtnClose.add_Click({



   $CustomDialog.RequestCloseAsync()
   
 
})





$btntest.add_Click({
  # Internal
  [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMetroDialogAsync($Form, $CustomDialog, $settings)
})


$Script:Test = $null

[System.Windows.RoutedEventHandler]$EventonDataGrid = {
   
   $button =  $_.OriginalSource.Name

   # =========================================================
   # THIS RETURN THE ROW DATA AVAILABLE in $TEST
   # =========================================================
   $Script:Test = $datagridtest.CurrentItem

   $button =  $_.OriginalSource.Name

    If ( $button -match "View" ){
        # Then it's View option button
        Write-Host "View button"
   }
   ElseIf ($button -match "Edit" ){
        # Then it's edit option button
        Write-Host "Edit button"
        Write-Host $datagridtest.CurrentCell
        $datagridtest.BeginEdit()

    
   }
   ElseIf ($button -match "Delete" ){
        # Then it's Remove option button
        $datagridtest.Items.Remove($Test)
        Write-Host "removed row"
   }


   #$datagridtest.UpdateLayout()

}
$datagridtest.AddHandler([System.Windows.Controls.Button]::ClickEvent, $EventonDataGrid)


$Form.ShowDialog() | Out-Null

