$ScriptXAML = @"

 <Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Script Launcher V.9000" Height="450" Width="800" ResizeMode="CanMinimize">
    <Grid Name="Script_Launcher_V_9000">
        <Image Name="Otacon" HorizontalAlignment="Left" Height="1891" Margin="-272,22,0,-1494" VerticalAlignment="Top" Width="908" Source="C:\ScriptLauncher9000\Untitled_Artwork.png"/>
        <TextBlock Name="Title_Block" HorizontalAlignment="Left" Height="107" Margin="296,22,0,0" TextWrapping="Wrap" Text="Welcome to the Script Launcher V.9000!" VerticalAlignment="Top" Width="476" FontSize="36" TextAlignment="Center" FontFamily="Yu Gothic Medium"/>
        <TextBox Name="Disclaimer" HorizontalAlignment="Left" Height="27" Margin="295,144,0,0" TextWrapping="Wrap" Text="*Disclaimer: Not very interesting, but will get better soon!" VerticalAlignment="Top" Width="477" TextAlignment="Center" BorderThickness="0"/>
        <Button Name="UserCreate" Content="User Creator" HorizontalAlignment="Left" Height="59" Margin="390,171,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Name="UserDisable" Content="Disable User" HorizontalAlignment="Left" Height="59" Margin="570,171,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Name="WMS" Content="WMS FE Folder" HorizontalAlignment="Left" Height="59" Margin="390,247,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Name="locked" Content="Are They Locked?" HorizontalAlignment="Left" Height="59" Margin="570,247,0,0" VerticalAlignment="Top" Width="112"/>
        <Button Name="QuickExchange" Content="Quick Exchange" HorizontalAlignment="Left" Height="59" Margin="390,325,0,0" VerticalAlignment="Top" Width="112"/>
    </Grid>
</Window>

"@ 
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $ScriptXAML

 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)

try{
    $OpenWindow=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
  
$xaml.SelectNodes("//*[Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $OpenWindow.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }

$UserCreate = $OpenWindow.FindName("UserCreate")
$QuickExchange = $OpenWindow.FindName("QuickExchange")
$WMS = $OpenWindow.FindName("WMS")
$Lockedout = $OpenWindow.FindName("locked")
$UserDisable = $OpenWindow.FindName("UserDisable")

$qepath = "C:\ScriptLauncher9000\quickexchange.ps1"

$UserCreate.Add_Click({Start-Process -FilePath "powershell" C:\ScriptLauncher9000\UserCreationV2.ps1})
$QuickExchange.Add_Click({Start-Process powershell -ArgumentList "-noexit", "C:\ScriptLauncher9000\quickexchange.ps1"})
$WMS.Add_Click({Start-Process -FilePath "powershell" C:\ScriptLauncher9000\wms.ps1})
$Lockedout.Add_Click({Start-Process -FilePath "powershell" C:\ScriptLauncher9000\aretheylocked.ps1})
$UserDisable.Add_Click({Start-Process -FilePath "powershell" C:\ScriptLauncher9000\UserRemoval.ps1})

$OpenWindow.ShowDialog() | out-null
