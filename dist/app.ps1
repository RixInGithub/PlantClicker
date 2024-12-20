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
$col = New-Object System.Drawing.SolidBrush("#808080")
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
		<Style x:Key="Plant" TargetType="Button">
			<Setter Property="Background" Value="Red"/>
			<Setter Property="Foreground" Value="White"/>
			<Setter Property="BorderThickness" Value="0"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="Button">
						<Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" Padding="14" Cursor="Hand" CornerRadius="10000">
							<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
						</Border>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
			<Style.Triggers>
				<Trigger Property="IsMouseOver" Value="True">
					<Setter Property="Background" Value="Red"/>
				</Trigger>
			</Style.Triggers>
		</Style>
	</Window.Resources>
	<Grid>
		<Button Name="plant" Content="🪴" Style="{StaticResource Plant}" HorizontalAlignment="Center" VerticalAlignment="Center" FontFamily="Segoe UI Emoji" FontSize="48"></Button>
		<Label Name="counter0" Content="Loading..." HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Segoe UI Emoji" />
		<Label Name="counter1" Content="Loading..." HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Segoe UI Emoji" />
		<Button Name="upg" Content="Upgrades" Cursor="Hand" Margin="8" HorizontalAlignment="Right" VerticalAlignment="Top" />
	</Grid>
</Window>
"@)
$win = [Windows.Markup.XamlReader]::Load($r)
$global:plants = 0

$upg = $win.FindName("upg")
$upgM = 48
$upgW = $win.Width - ($upgM * 2)
$upgH = $win.Height - ($upgM * 2)
$upgXAML = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="Upgrades" Width="$upgW" Height="$upgH" Icon="$icnP">
	<Window.Resources>
		<Style x:Key="BuyBtn" TargetType="Button">
			<Setter Property="Background" Value="#0f0"/>
			<Setter Property="Foreground" Value="White"/>
			<Setter Property="BorderThickness" Value="0"/>
			<Setter Property="Cursor" Value="Hand"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="Button">
						<Border x:Name="buttonBorder" Background="{TemplateBinding Background}" Padding="12">
							<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
						</Border>
						<ControlTemplate.Triggers>
							<Trigger Property="IsMouseOver" Value="True">
								<Setter TargetName="buttonBorder" Property="Background" Value="#0f0"/>
							</Trigger>
						</ControlTemplate.Triggers>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style x:Key="LblStyles" TargetType="Label">
			<Setter Property="FontFamily" Value="Segoe UI Emoji"/>
			<Setter Property="Padding" Value="0"/>
		</Style>
		<Style x:Key="CostStyle" TargetType="TextBlock">
			<Setter Property="FontFamily" Value="Segoe UI Emoji"/>
			<Setter Property="Padding" Value="0"/>
		</Style>
	</Window.Resources>
	<ScrollViewer VerticalScrollBarVisibility="Auto">
		<StackPanel>
			<Grid Name="mult" Margin="8,8,8,0">
				<StackPanel VerticalAlignment="Center">
					<Label Content="+1 multiplier" FontSize="16" Style="{StaticResource LblStyles}" />
					<Label Content="This stuff makes you produce more 🪴s than ever!" FontSize="8" Style="{StaticResource LblStyles}" />
					<TextBlock FontSize="8" Style="{StaticResource CostStyle}">
						<Run Text="Cost:" FontWeight="Bold" />
						<Run Text=" " />
						<Run Name="mult_q" />
						<Run Name="mult_c" />
					</TextBlock>
				</StackPanel>
				<Button Style="{StaticResource BuyBtn}" HorizontalAlignment="Right" VerticalAlignment="Center">Buy</Button>
			</Grid>
		</StackPanel>
	</ScrollViewer>
</Window>
"@
$upgW = $null

$btn = $win.FindName("plant")
$lbl1 = $win.FindName("counter0")
$lbl2 = $win.FindName("counter1")
$btn.Add_Click({
	$global:plants++
	$lbl1.Content = "$global:plants 🪴s"
	[System.Media.SystemSounds]::Beep.Play()
})

$upgNms = @("mult")
$upgCosts = @{
	"mult" = @{
		"curr" = "plants"
		"cost" = 40
	}
}
$crcyEmohis = @{
	"plants" = "🪴"
	"mults" = "🪴🪴"
	"autoclick" = "🤖"
}
$crcyVars = @{
	"plants" = "plants"
}
$upg.Add_Click({
	# [System.Windows.MessageBox]::Show("soon™", $win.Title)
	$uR = New-Object System.Xml.XmlNodeReader($upgXAML)
	if ($global:upgW -eq $null) {
		$global:upgW = [Windows.Markup.XamlReader]::Load($uR)
		$global:upgW.Left = $win.Left + ($win.Width - $global:upgW.Width) / 2
		$global:upgW.Top = $win.Top + ($win.Height - $global:upgW.Height) / 2
		$global:upgW.WindowState = [System.Windows.WindowState]::Normal
		$global:upgW.ResizeMode = [System.Windows.ResizeMode]::NoResize
		$global:upgW.WindowStyle = [System.Windows.WindowStyle]::SingleBorderWindow
		$global:upgW.Topmost = $true
		$global:upgW.Add_ContentRendered({
			$upgNms | ForEach-Object {
				$e = $global:upgW.FindName($_)
				$bBtn = $e.Children[$e.Children.Count-1]
				Write-Host $bBtn
				$q = $global:upgW.FindName("$($_)_q") # quantity
				$c = $global:upgW.FindName("$($_)_c") # currency
				$q.Text = $upgCosts[$_]["cost"].ToString()
				$c.Text = $crcyEmohis[$upgCosts[$_]["curr"]]
				$bBtn.Add_Click({
					$me = $args[0]
					$_ = [System.Windows.Media.VisualTreeHelper]::GetParent($me).Name
					$crcy = (Get-Variable -Name $crcyVars[$upgCosts[$_]["curr"]]).Value
					$cost = $upgCosts[$_]["cost"]
					if ($crcy -lt $cost) {
						$diff = $cost - $crcy
						$c = $global:upgW.FindName("$($_)_c")
						[System.Windows.MessageBox]::Show("You need $diff more $($c.Text) to buy this upgrade.", $win.Title)
						return
					}
					[System.Windows.MessageBox]::Show("yipe", $win.Title)
				})
				$bBtn.Add_LayoutUpdated({ # args[0] is null.
					return
					$me = $args[0]
					try {
						$me.Width = $me.Height
					} catch {
						Write-Host "failed to set width to height of $me because of $($_.FullyQualifiedErrorId.ToString())"
					}
				})
			}
		})
		$global:upgW.Add_Closed({$global:upgW=$null})
		$global:upgW.Show()
		return
	}
	$global:upgW.Activate()
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
if ($upgW -ne $null) {$upgW.Icon = $null;$upgW.Close()}
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
Remove-Item $icnP