Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing

# [System.Windows.MessageBox]::Show("msgbox sample")

# ICON CONFIG DO NOT TOUCH
$bmpSiz = 32
$bmp = New-Object System.Drawing.Bitmap $bmpSiz, $bmpSiz
$draw = [System.Drawing.Graphics]::FromImage($bmp)
$draw.Clear([System.Drawing.Color]::White)
$f = New-Object System.Drawing.FontFamily("Segoe UI Emoji")
$fontObj = New-Object System.Drawing.Font($f, 24, [System.Drawing.FontStyle]::Regular)
$col = New-Object System.Drawing.SolidBrush("#006000")
$e = "🪴"
$bbox = $draw.MeasureString($e, $fontObj)
$x = ($bmpSiz - $bbox.Width) / 2
$y = ($bmpSiz - $bbox.Height) / 2
$draw.DrawString($e, $fontObj, $col, $x, $y)
$icnP = "$env:Temp\plantClickerEmohi.ico"
$strm = New-Object System.IO.MemoryStream
$bmp.Save($strm, [System.Drawing.Imaging.ImageFormat]::Png)
$icn = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
$icnFile = [System.IO.File]::Create($icnP)
$icn.Save($icnFile)
$icnFile.Close()
$draw.Dispose()
$bmp.Dispose()
# ICON CONFIG DO NOT TOUCH

$r = New-Object System.Xml.XmlNodeReader([xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="🪴 Clicker" Width="400" Height="266" Icon="$icnP">
	<Window.Resources>
		<Style x:Key="CustomButtonStyle" TargetType="Button">
			<Setter Property="Background" Value="Red"/>
			<Setter Property="Foreground" Value="White"/>
			<Setter Property="BorderThickness" Value="0"/>
			<Setter Property="Padding" Value="28"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="Button">
						<Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" Padding="8" Cursor="Hand" CornerRadius="10000">
							<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
						</Border>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
			<Style.Triggers>
				<Trigger Property="IsMouseOver" Value="True">
					<Setter Property="Background" Value="Red"/>
					<Setter Property="Foreground" Value="White"/>
					<Setter Property="BorderThickness" Value="0"/>
				</Trigger>
			</Style.Triggers>
		</Style>
	</Window.Resources>
	<Grid>
		<Button Name="plant" Content="🪴" Style="{StaticResource CustomButtonStyle}" HorizontalAlignment="Center" VerticalAlignment="Center" FontFamily="Segoe UI Emoji" FontSize="48"></Button>
		<Label Name="counter0" Content="Loading..." HorizontalAlignment="Left" VerticalAlignment="Top" />
		<Label Name="counter1" Content="Loading..." HorizontalAlignment="Left" VerticalAlignment="Top" />
		<Button Name="upds" Content="Upgrades" Cursor="Hand" Margin="8" HorizontalAlignment="Right" VerticalAlignment="Top" />
	</Grid>
</Window>
"@)
$win = [Windows.Markup.XamlReader]::Load($r)
$plants = 0

$btn = $win.FindName("plant")
$lbl1 = $win.FindName("counter0")
$lbl2 = $win.FindName("counter1")
$btn.Add_Click({
	$global:plants++
	$lbl1.Content = "$global:plants 🪴s"
	[System.Media.SystemSounds]::Beep.Play()
})

$win.Add_ContentRendered({
	Write-Host "App started!"
	$lbl1.Content = "$plants 🪴s"
	$type = New-Object System.Windows.Media.Typeface($lbl1.FontFamily, $lbl1.FontStyle, $lbl1.FontWeight, $lbl1.FontStretch)
	$f = New-Object System.Windows.Media.FormattedText(
		$lbl1.Content.ToString(),
		[System.Globalization.CultureInfo]::CurrentCulture,
		[System.Windows.FlowDirection]::LeftToRight,
		$type,
		$lbl1.FontSize,
		[System.Windows.Media.Brushes]::Black
	)
	$h = $f.Height
	Write-Host "sacred variable `$h: $h" # i am not removing this bcuz ***h***
	$lbl2.Margin = New-Object System.Windows.Thickness(0, $h, 0, 0)
})
$win.WindowState = [System.Windows.WindowState]::Normal
$win.ResizeMode = [System.Windows.ResizeMode]::NoResize
$win.WindowStyle = [System.Windows.WindowStyle]::SingleBorderWindow
$win.Topmost = $true

$win.ShowDialog() | Out-Null
$win.Icon = $null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
Remove-Item $icnP