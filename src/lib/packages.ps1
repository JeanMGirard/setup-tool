


class Package {
    [string] $name
    [string] $id
    [System.Collections.Generic.List[string]]  $tags

    Package([string]$_name, [string] $_id = $_name) {
        $this.name = $_name
        $this.id = $_id
        $this.tags = [System.Collections.Generic.List[string]]::new()
    }
    Package([string]$_name) {
        $this.name = $_name
        $this.id = $_name
    }
}



class PackageCategory {

    [string] $name
    [System.Collections.Generic.List[Package]] $packages
    [PackageCategory] $parent

    # $PackageNames = { $this.packages | ForEach-Object { $_.name } } 
    $PackageNames = @{ Name = 'PackageNames'; Expression = { $_.packages | ForEach-Object { $_.name } } }

    PackageCategory(
        [string]$_name
    ) {
        $this.name = $_name
        $this.packages = [System.Collections.Generic.List[Package]]::new()
    }

    [System.Collections.Generic.List[string]] GetPackageNames() {
        return ($this.packages | ForEach-Object { $_.name })
    }
    
    

    Show() {
        Write-Host
        Write-Host $this.name ": " $this.PackageNames
    }
    Sort() { $this.packages.Sort() }
    Add([Package]$package) {
        $this.packages.Add($package)
    }
    Add([string]$name) {
        $pkg = [Package]::new($name)
        $this.Add($pkg);
    }
}



$devTools = [PackageCategory]::new('Dev Tools')
$devTools.Add("Clojure")

$devTools.Show()
