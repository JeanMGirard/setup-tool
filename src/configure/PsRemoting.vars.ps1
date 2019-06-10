$ENV:PsConfigsDir = "~/Documents/WindowsPowerShell/Configs"
$ENV:PsSessionsDir =  "~/Documents/WindowsPowerShell/Sessions"

$ENV:PsDefaultConfig = @{
#    Path 		= '${ENV:PsConfigsDir}/defaults.pssc'
    SchemaVersion 	= '1.0.0.0'
    Author 		= ''
    Copyright 		= ''
    CompanyName 	= ''
    Description 	= ''
    ExecutionPolicy 	= 'RemoteSigned'
    PowerShellVersion 	= '3.0'
    LanguageMode 	= 'FullLanguage'
    SessionType 	= 'Default'
    EnvironmentVariables = `
	@{TESTSHARE='\\Test2\Test'}
    ModulesToImport 	= `
	@{ModuleName='PSScheduledJob';ModuleVersion='1.0.0.0';GUID='50cdb55f-5ab7-489f-9e94-4ec21ff51e59'},
	'PSDiagnostics'
    AssembliesToLoad 	= 'System.Web.Services','FSharp.Compiler.CodeDom.dll'
    TypesToProcess 	= 'Types1.ps1xml','Types2.ps1xml'
    FormatsToProcess 	= 'CustomFormats.ps1xml'
    ScriptsToProcess 	= 'Get-Inputs.ps1'
    AliasDefinitions = `
	@{ 	Name='hlp';   
		Value='Get-Help';   Description='Gets help.';  Options='AllScope' }, 
	@{ Name='Update';Value='Update-Help';Description='Updates help';Options='ReadOnly' }
    FunctionDefinitions = `
	@{Name='Get-Function';ScriptBlock={Get-Command -CommandType Function }; Options='ReadOnly'}
    VariableDefinitions = `
	@{Name='WarningPreference';Value='SilentlyContinue'}
    VisibleAliases 	= 'c*','g*','i*','s*'
    VisibleCmdlets 	= 'Get*'
    VisibleFunctions 	= 'Get*'
    VisibleProviders 	= 'FileSystem','Function','Variable'
    RunAsVirtualAccount = $true
    RunAsVirtualAccountGroups = 'Backup Operators'
}
