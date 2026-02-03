function Convert-GraphInternalUser {
    <#
    .SYNOPSIS
    Converts user returned by graph with onPremisesExtensionAttributes to new simplified object

    .DESCRIPTION
    Converts user returned by graph with onPremisesExtensionAttributes to new simplified object

    .PARAMETER InputObject
    The object to convert

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)][PSCustomObject[]] $InputObject
    )
    Process {
        $InputObject | ForEach-Object {
            $NewObject = [ordered] @{}
            $Object = $_
            foreach ($Property in $Object.PSObject.Properties.Name) {
                if ($Property -eq 'onPremisesExtensionAttributes') {
                    $OnPrem = $Object.onPremisesExtensionAttributes
                    if ($null -ne $OnPrem) {
                        if ($OnPrem -is [System.Collections.IDictionary]) {
                            foreach ($Key in $OnPrem.Keys) {
                                $NewObject[$Key] = $OnPrem[$Key]
                            }
                        } else {
                            foreach ($ExtensionAttribute in $OnPrem.PSObject.Properties.Name) {
                                $NewObject[$ExtensionAttribute] = $OnPrem.$ExtensionAttribute
                            }
                        }
                    }
                    # keep the raw object for debugging/inspection
                    $NewObject['onPremisesExtensionAttributes'] = $OnPrem
                } else {
                    $NewObject[$Property] = $Object.$Property
                }
            }
            [PSCustomObject] $NewObject
        }
    }
}
