Import-Module UniversalDashboard.Community

Get-UDDashboard | Stop-UDDashboard

$Limites = @(
    @{
        Cemento = @{
            Minimo = 170
            Ideal = 180
        }
        Agregado1 = @{
            Minimo = 23
            Ideal = 26
        }
        Agregado2 = @{
            Minimo = 33
            Ideal = 36
        }
        Agregado3 = @{
            Minimo = 5
            Ideal = 10
        }
        AguaPorcentaje = @{
            Minimo = 90
            Ideal = 95
        }
        PlacasProducidas = @{
            Minimo = 150
            Ideal = 160
        }
    }
)

$Tags = @(
    [PSCustomObject]@{
        Cemento = 170
        Agregado1 = 25
        Agregado2 = 35
        Agregado3 = 10
        AguaPorcentaje = 95
        PlacasProducidas = 152
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:20:00'
    }
    [PSCustomObject]@{
        Cemento = 168
        Agregado1 = 24
        Agregado2 = 32
        Agregado3 = 11
        AguaPorcentaje = 97
        PlacasProducidas = 145
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:25:00'
    }
    [PSCustomObject]@{
        Cemento = 175
        Agregado1 = 26
        Agregado2 = 33
        Agregado3 = 13
        AguaPorcentaje = 93
        PlacasProducidas = 157
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:30:00'
    }
    [PSCustomObject]@{
        Cemento = 173
        Agregado1 = 23
        Agregado2 = 37
        Agregado3 = 8
        AguaPorcentaje = 98
        PlacasProducidas = 153
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:35:00'
    }
    [PSCustomObject]@{
        Cemento = 170
        Agregado1 = 27
        Agregado2 = 35
        Agregado3 = 9
        AguaPorcentaje = 95
        PlacasProducidas = 162
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:40:00'
    }
    [PSCustomObject]@{
        Cemento = 171
        Agregado1 = 24
        Agregado2 = 33
        Agregado3 = 10
        AguaPorcentaje = 94
        PlacasProducidas = 155
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:45:00'
    }
    [PSCustomObject]@{
        Cemento = 173
        Agregado1 = 25
        Agregado2 = 38
        Agregado3 = 11
        AguaPorcentaje = 96
        PlacasProducidas = 160
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:50:00'
    }
    [PSCustomObject]@{
        Cemento = 195
        Agregado1 = 26
        Agregado2 = 34
        Agregado3 = 10
        AguaPorcentaje = 97
        PlacasProducidas = 156
        PlacasObjectivo = 150
        Hora = '2020/01/28 08:55:00'
    }
)

$footer = New-UDFooter -Copyright "Desarrollado por: Héctor Andrade"
$theme = Get-UDTheme -Name Default
$MyDashboard = New-UDDashboard -Title 'Sistemas hAndrade' -Theme $theme -Footer $footer -Content {

    # New-UDRow -Columns { New-UDColumn -SmallOffset 1 -MediumOffset 2 -LargeOffset 6 -Content { New-UDHeading -Size 4 -Text "Corrida de las $($Tags[-1].Hora)" } }

    New-UDRow -Columns {

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Cemento' -TextAlignment center -TextSize Large -Endpoint {

                $Tags[-1].Cemento

            }

        }

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Agregado 1' -TextAlignment center -TextSize Large -Endpoint {

                $Tags[-1].Agregado1

            }

        }

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Agregado 2' -TextAlignment center -TextSize Large -Endpoint {

                $Tags[-1].Agregado2

            }

        }

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Agregado 3' -TextAlignment center -TextSize Large -Endpoint {

                $Tags[-1].Agregado3

            }

        }

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Agua' -Format '%' -TextAlignment center -TextSize Large -Endpoint {

                ($Tags[-1].AguaPorcentaje)/100

            }

        }

        New-UDColumn -SmallSize 4 -MediumSize 4 -LargeSize 2 -Content {

            New-UDCounter -Title 'Placas Producidas' -TextAlignment center -TextSize Large -Endpoint {

                $Tags[-1].PlacasProducidas

            }

        }

        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 6 -Content {

            $Produccion_Chart_Properties = @{

                Title = "Historial del Dia - Placas Producidas"
                Type = 'line'
                ArgumentList = $Tags
                Endpoint = {
                    $ArgumentList | Out-UDChartData -LabelProperty 'Hora' -Dataset @(
                        New-UDLineChartDataset -DataProperty 'PlacasProducidas' -Label 'Placas Producidas' -BorderColor '#003F91' -BackgroundColor '#5DA9E9'
                        New-UDLineChartDataset -DataProperty 'PlacasObjectivo' -Label 'Cantidad Objectivo' -BorderColor '#BF0000' -BackgroundColor '#FF0000' -BorderWidth 3 #-Fill $false
                    )
                }
            }

            New-UDChart @Produccion_Chart_Properties

        }

        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 6 -Content {

            $Produccion_Chart_Properties = @{

                Title = "Historial del Dia - Componentes"
                Type = 'Bar'
                ArgumentList = $Tags # | Get-Member -MemberType Noteproperty | where {$_.Name -ne 'Hora'} | Select Name,@{n='Value';e={($_.definition -split '=')[1]}}
                Endpoint = {
                    $ArgumentList | Out-UDChartData -LabelProperty Hora -Dataset @(
                        New-UDChartDataset -DataProperty 'Cemento' -Label 'Cemento' -BackgroundColor '#5DA9E9' -HoverBackgroundColor '#D84220'
                        New-UDChartDataset -DataProperty 'Agregado1' -Label 'Agregado 1' -BackgroundColor '#C4E1FF' -HoverBackgroundColor '#FBECCB'
                        New-UDChartDataset -DataProperty 'Agregado2' -Label 'Agregado 2' -BackgroundColor '#33357A' -HoverBackgroundColor '#4D5146'
                        New-UDChartDataset -DataProperty 'Agregado3' -Label 'Agregado 3' -BackgroundColor '#CEEAF7' -HoverBackgroundColor '#F47D42'
                        New-UDChartDataset -DataProperty 'AguaPorcentaje' -Label 'Agua %' -BackgroundColor '#003F91' -HoverBackgroundColor '#FF8A84'
                    )
                }

            }

            New-UDChart @Produccion_Chart_Properties

        }

    }


    New-UDRow -Columns {

        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 12 -Content {

            New-UDGrid -Title "Historial de Produccion" -NoPaging -NoExport -NoFilter -DefaultSortColumn Hora -Endpoint {

                $Grid_Data = @()
                $Cemento = @{Background_Color = 'Purple';Foreground_Color = 'White'}
                $Agregado1 = @{Background_Color = 'Purple';Foreground_Color = 'White'}
                $Agregado2 = @{Background_Color = 'Purple';Foreground_Color = 'White'}
                $Agregado3 = @{Background_Color = 'Purple';Foreground_Color = 'White'}
                $AguaPorcentaje = @{Background_Color = 'Purple';Foreground_Color = 'White'}
                $PlacasProducidas = @{Background_Color = 'Purple';Foreground_Color = 'White'}

                foreach ($Tag in $Tags) {
                    switch ($Tag.Cemento) {
                        {$Tag.Cemento -le $Limites.Cemento.Minimo} { $Cemento.Background_Color = 'Red';$Cemento.Foreground_Color = 'White' }
                        {$Tag.Cemento -gt $Limites.Cemento.Minimo -and $Tag.Cemento -lt $Limites.Cemento.Ideal} { $Cemento.Background_Color = 'Yellow';$Cemento.Foreground_Color = 'Blue' }
                        {$Tag.Cemento -ge $Limites.Cemento.Ideal} { $Cemento.Background_Color = 'Green';$Cemento.Foreground_Color = 'White' }
                        Default { $Cemento.Background_Color = 'Purple';$Cemento.Foreground_Color = 'White' }
                    }
                    switch ($Tag.Agregado1) {
                        {$Tag.Agregado1 -le $Limites.Agregado1.Minimo} { $Agregado1.Background_Color = 'Red';$Agregado1.Foreground_Color = 'White' }
                        {$Tag.Agregado1 -gt $Limites.Agregado1.Minimo -and $Tag.Agregado1 -lt $Limites.Agregado1.Ideal} { $Agregado1.Background_Color = 'Yellow';$Agregado1.Foreground_Color = 'Blue' }
                        {$Tag.Agregado1 -ge $Limites.Agregado1.Ideal} { $Agregado1.Background_Color = 'Green';$Agregado1.Foreground_Color = 'White' }
                        Default { $Agregado1.Background_Color = 'Purple';$Agregado1.Foreground_Color = 'White' }
                    }
                    switch ($Tag.Agregado2) {
                        {$Tag.Agregado2 -le $Limites.Agregado2.Minimo} { $Agregado2.Background_Color = 'Red';$Agregado2.Foreground_Color = 'White' }
                        {$Tag.Agregado2 -gt $Limites.Agregado2.Minimo -and $Tag.Agregado2 -lt $Limites.Agregado2.Ideal} { $Agregado2.Background_Color = 'Yellow';$Agregado2.Foreground_Color = 'Blue' }
                        {$Tag.Agregado2 -ge $Limites.Agregado2.Ideal} { $Agregado2.Background_Color = 'Green';$Agregado2.Foreground_Color = 'White' }
                        Default { $Agregado2.Background_Color = 'Purple';$Agregado2.Foreground_Color = 'White' }
                    }
                    switch ($Tag.Agregado3) {
                        {$Tag.Agregado3 -le $Limites.Agregado3.Minimo} { $Agregado3.Background_Color = 'Red';$Agregado3.Foreground_Color = 'White' }
                        {$Tag.Agregado3 -gt $Limites.Agregado3.Minimo -and $Tag.Agregado3 -lt $Limites.Agregado3.Ideal} { $Agregado3.Background_Color = 'Yellow';$Agregado3.Foreground_Color = 'Blue' }
                        {$Tag.Agregado3 -ge $Limites.Agregado3.Ideal} { $Agregado3.Background_Color = 'Green';$Agregado3.Foreground_Color = 'White' }
                        Default { $Agregado3.Background_Color = 'Purple';$Agregado3.Foreground_Color = 'White' }
                    }
                    switch ($Tag.AguaPorcentaje) {
                        {$Tag.AguaPorcentaje -le $Limites.AguaPorcentaje.Minimo} { $AguaPorcentaje.Background_Color = 'Red';$AguaPorcentaje.Foreground_Color = 'White' }
                        {$Tag.AguaPorcentaje -gt $Limites.AguaPorcentaje.Minimo -and $Tag.AguaPorcentaje -lt $Limites.AguaPorcentaje.Ideal} { $AguaPorcentaje.Background_Color = 'Yellow';$AguaPorcentaje.Foreground_Color = 'Blue' }
                        {$Tag.AguaPorcentaje -ge $Limites.AguaPorcentaje.Ideal} { $AguaPorcentaje.Background_Color = 'Green';$AguaPorcentaje.Foreground_Color = 'White' }
                        Default { $AguaPorcentaje.Background_Color = 'Purple';$AguaPorcentaje.Foreground_Color = 'White' }
                    }
                    switch ($Tag.PlacasProducidas) {
                        {$Tag.PlacasProducidas -le $Limites.PlacasProducidas.Minimo} { $PlacasProducidas.Background_Color = 'Red';$PlacasProducidas.Foreground_Color = 'White' }
                        {$Tag.PlacasProducidas -gt $Limites.PlacasProducidas.Minimo -and $Tag.PlacasProducidas -lt $Limites.PlacasProducidas.Ideal} { $PlacasProducidas.Background_Color = 'Yellow';$PlacasProducidas.Foreground_Color = 'Blue' }
                        {$Tag.PlacasProducidas -ge $Limites.PlacasProducidas.Ideal} { $PlacasProducidas.Background_Color = 'Green';$PlacasProducidas.Foreground_Color = 'White' }
                        Default { $PlacasProducidas.Background_Color = 'Purple';$PlacasProducidas.Foreground_Color = 'White' }
                    }

                    $props = @{
                        Cemento = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $Cemento.Background_Color; color = $Cemento.Foreground_Color; align = 'center' } } -Content {$tag.Cemento }
                        Agregado1 = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $Agregado1.Background_Color; color = $Agregado1.Foreground_Color; align = 'center' } } -Content {$tag.Agregado1 }
                        Agregado2 = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $Agregado2.Background_Color; color = $Agregado2.Foreground_Color; align = 'center' } } -Content {$tag.Agregado2 }
                        Agregado3 = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $Agregado3.Background_Color; color = $Agregado3.Foreground_Color; align = 'center' } } -Content {$tag.Agregado3 }
                        AguaPorcentaje = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $AguaPorcentaje.Background_Color; color = $AguaPorcentaje.Foreground_Color; align = 'center' } } -Content {$tag.AguaPorcentaje }
                        PlacasProducidas = New-UDElement -Tag 'div' -Attributes @{ style = @{ 'backgroundColor' = $PlacasProducidas.Background_Color; color = $PlacasProducidas.Foreground_Color; align = 'center' } } -Content {$tag.PlacasProducidas }
                        Hora = $tag.Hora

                    }

                    $obj = New-Object -TypeName psobject -Property $props

                    $Grid_Data += $obj

                }

                $Grid_Data | Select Cemento,Agregado1,Agregado2,Agregado3,AguaPorcentaje,PlacasProducidas,Hora | Out-UDGridData

            }

        }

    }

    New-UDRow -Columns {

        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 12 -Content {

            New-UDGrid -Title "Historial de Produccion" -NoPaging -DefaultSortColumn Hora -Endpoint {

                $Grid_Data = @()
                foreach ($Tag in $Tags) {

                    $props = @{

                        Cemento = $tag.Cemento
                        Agregado1 = $tag.Agregado1
                        Agregado2 = $tag.Agregado2
                        Agregado3 = $tag.Agregado3
                        AguaPorcentaje = $tag.AguaPorcentaje
                        PlacasProducidas = $tag.PlacasProducidas
                        Hora = $tag.Hora

                    }

                    $obj = New-Object -TypeName psobject -Property $props

                    $Grid_Data += $obj

                }

                $Grid_Data | Select Cemento,Agregado1,Agregado2,Agregado3,AguaPorcentaje,PlacasProducidas,Hora | Out-UDGridData

            }

        }

    }

}
dock
Start-UDDashboard -Port 80 -Dashboard $MyDashboard -Force

While (Get-UDDashboard) {
    Start-Sleep 3
}
