BeforeAll {

	$here = $PSCommandPath
	$root = Split-Path -Path $here -Parent

	$modulePath = Join-Path -Path $root -ChildPath ..
	$moduleName = (Get-Item -Path "$modulePath\Src\*.psd1").BaseName
	$moduleManifest = Join-Path -Path $modulePath -ChildPath "Src\$moduleName.psd1"
	$functionsPublicPath = Join-Path -Path $modulePath -ChildPath 'Src\Src\Public'
	$functionsPrivatePath = Join-Path -Path $modulePath -ChildPath 'Src\Src\Private'
	$functionsPublic = Get-ChildItem -Path $functionsPublicPath -Filter *.ps1
	$functionsAll = Get-ChildItem -Path $functionsPublicPath, $functionsPrivatePath -Exclude .gitkeep

}

Describe 'Pre-Reqs' {

	Context 'Path Variables' {

		It 'here should not be null' {

			$here | Should -Not -BeNullOrEmpty

		}

		It 'root should not be null' {

			$root | Should -Not -BeNullOrEmpty

		}

		It 'ModulePath should not be null' {

			$modulePath | Should -Not -BeNullOrEmpty

		}

		It 'moduleName should not be null' {

			$moduleName | Should -Not -BeNullOrEmpty

		}

		It 'moduleManifest should not be null' {

			$moduleManifest | Should -Not -BeNullOrEmpty

		}

		It 'functionsPublicPath should not be null' {

			$functionsPublicPath | Should -Not -BeNullOrEmpty

		}

		It 'functionsPrivatePath should not be null' {

			$functionsPrivatePath | Should -Not -BeNullOrEmpty

		}

		It 'functionsPublic should not be null' {

			$functionsPublic | Should -Not -BeNullOrEmpty

		}

		It 'functionsAll should not be null' {

			$functionsAll | Should -Not -BeNullOrEmpty

		}

	}

}
Describe 'Module' {

	Context 'Manifest' {

		$script:manifest = $null

		It 'has a valid manifest' {
			{
				$script:manifest = Test-ModuleManifest -Path $moduleManifest -ErrorAction Stop -WarningAction SilentlyContinue
			} | Should -Not -Throw
		}

		It 'has a valid name in the manifest' {
			$script:manifest.Name | Should -Be $moduleName
		}

		It 'has a valid root module' {
			$script:manifest.RootModule | Should -Be ($moduleName + ".psm1")
		}

		It 'has a valid version in the manifest' {
			$script:manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
		}

		It 'has a valid description' {
			$script:manifest.Description | Should -Not -BeNullOrEmpty
		}

		It 'has a valid author' {
			$script:manifest.Author | Should -Not -BeNullOrEmpty
		}

		It 'has a valid guid' {
			{
				[guid]::Parse($script:manifest.Guid)
			} | Should -Not -BeOfType 'System.Guid'
		}

		It 'has a valid copyright' {
			$script:manifest.CopyRight | Should -Not -BeNullOrEmpty
		}

		It 'has the same number of exported public functions for function ps1 files' {
			($script:manifest.ExportedFunctions.GetEnumerator() | Measure-Object).Count | Should -Be ($functionsPublic | Measure-Object).Count
		}
	}

    foreach ($script:function in $functionsAll)
    {
        Context $script:function.BaseName {

            $script:functionContents = $null
            $script:psParserErrorOutput = $null
            $script:functionContents = Get-Content -Path $script:function.FullName

            It 'has no syntax errors'  {
                [System.Management.Automation.PSParser]::Tokenize($script:functionContents, [ref]$script:psParserErrorOutput)

                ($script:psParserErrorOutput | Measure-Object).Count | Should -Be 0

                Clear-Variable -Name psParserErrorOutput -Scope Script -Force
            }

            if (($Script:function.PSParentPath -split "\\" | Select-Object -Last 1) -eq 'Public' )
            {
                It 'is a public function and exported in the module manifest' {
                    $manifest.ExportedCommands.Keys.GetEnumerator() -contains $script:function.BaseName | Should -BeTrue
                }
            }
        }
    }
}
