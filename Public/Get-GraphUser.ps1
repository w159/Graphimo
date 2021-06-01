﻿function Get-GraphUser {
    [alias('Get-GraphUsers')]
    [cmdletBinding()]
    param(
        [alias('Authorization')][System.Collections.IDictionary] $Headers,
        [string] $Id,
        [string[]] $Property,
        [string] $Filter,
        [string] $OrderBy

        #[validateSet('Guest')][string] $UserType,
        #[uri] $PrimaryUri = 'https://graph.microsoft.com/v1.0',
        #[switch] $AsHashTable,
        #[string] $CacheProperty = 'mail'
    )
    <#
    $UsersDictionary = [ordered]@{}
    $URI = '/users'
    if ($Property -and $UserType) {
        $URI = "$($URI)?" + "`$select=" + $($Property -join ",") + "&`$filter=userType eq 'Guest'"
    } elseif ($Property) {
        $URI = "$($URI)?" + "`$select=" + $($Property -join ",")
    } elseif ($UserType) {
        $URI = "$($URI)?" + "`$filter=userType eq 'Guest'"
    }
    if ($AsHashTable) {
        $Users = Invoke-O365Graph -Uri $URI -Method GET -Headers $Headers -PrimaryUri $PrimaryUri
        if ($Users -ne $false) {
            # When invoke-graph fails - it will return $FALSE
            foreach ($User in $Users) {
                if ($User.$CacheProperty) {
                    $UsersDictionary[$User.$CacheProperty] = $User
                }
            }
            $UsersDictionary
        }
    } else {
        Invoke-O365Graph -Uri $URI -Method GET -Headers $Headers -PrimaryUri $PrimaryUri
    }
    #>


    if ($ID) {
        # Query a single group
        $RelativeURI = "/users/$ID"
        $QueryParameter = @{
            '$Select' = $Property -join ','
        }
    } else {
        # Query multiple groups
        $RelativeURI = '/users'
        $QueryParameter = @{
            '$Select'  = $Property -join ','
            '$filter'  = $Filter
            '$orderby' = $OrderBy
        }
    }
    Remove-EmptyValue -Hashtable $QueryParameter
    $URI = Join-UriQuery -BaseUri 'https://graph.microsoft.com/v1.0' -RelativeOrAbsoluteUri $RelativeURI -QueryParameter $QueryParameter
    Invoke-Graph -Uri $URI -Method GET -Headers $Headers -PrimaryUri $PrimaryUri -FullUri
}