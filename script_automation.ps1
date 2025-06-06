param (
    [string]$projectName        = "MyProject",
    [string]$sourceRepoName     = "MyProject.Web.OLD",
    [string]$solutionFile       = "MySolution.sln",
    [string]$newRepoName        = "$($projectName).Web",
    [string]$pipelineName       = "$($projectName).Web-CI",
    [string]$localRepoPath      = "C:\Projects\$projectName",
    [string]$templateFilesPath  = "C:\Templates\BaseFiles",
    [string]$repoFilesPath      = "C:\Projects\$projectName\$($projectName).Web",
    [string]$organizationUrl    = "https://dev.azure.com/my-org",

    [string]$branchDev          = "dev",
    [string]$branchPre          = "pre",
    [string]$branchMain         = "main",
    [string]$branchMaster       = "refs/heads/master",

    [string]$artifactVariable   = '$(Build.DefinitionName)_$(Build.BuildNumber)',
    [string]$envVarUsername     = '$(Deploy_Username)',
    [string]$envVarPassword     = '$(Deploy_Password)'
)

# --- DESCARGA DEL REPOSITORIO DESDE TFS (si aplica) ---
$tfPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\TF.exe"
& $tfPath workfold $/SOURCE $localRepoPath
tf get "$/SOURCE/$projectName/$sourceRepoName" /recursive
cd "$localRepoPath\$sourceRepoName"

# --- CREACIÓN DEL PROYECTO Y REPOSITORIO ---
az devops project create --org $organizationUrl --name $projectName
az repos create --name $newRepoName --org $organizationUrl --project $projectName

# --- INICIALIZACIÓN DE GIT Y PUSH INICIAL ---
Copy-Item "$templateFilesPath\.gitattributes" -Destination .
Copy-Item "$templateFilesPath\.gitignore" -Destination .
Copy-Item "$templateFilesPath\Nuget.Config" -Destination .
Copy-Item "$templateFilesPath\azure-pipelines.yml" -Destination .

git init
git add .
git commit -m "Initial commit"
git remote add origin "$organizationUrl/$projectName/_git/$newRepoName/"
git push -u origin --all

# --- CREACIÓN Y CONFIGURACIÓN DE RAMAS ---
$branches = az repos ref list --org $organizationUrl --project $projectName --repository $newRepoName | ConvertFrom-Json
$masterBranch = $branches | Where-Object { $_.name -eq $branchMaster }
$objectId = $masterBranch.objectId

foreach ($branch in @($branchDev, $branchPre, $branchMain)) {
    az repos ref create --name "refs/heads/$branch" --object-id $objectId --org $organizationUrl --project $projectName --repository $newRepoName
}

az repos ref delete --name $branchMaster --object-id $objectId --org $organizationUrl --project $projectName --repository $newRepoName
$defaultRepo = (az repos list --org $organizationUrl --project $projectName | ConvertFrom-Json) | Where-Object { $_.name -eq $projectName }
az repos delete --id $defaultRepo.Id --org $organizationUrl --project $projectName

# --- CREACIÓN DE PIPELINE Y VARIABLES ---
cd $repoFilesPath
az pipelines create --name $pipelineName --yml-path azure-pipelines.yml --repository $newRepoName --branch main --repository-type tfsgit --org $organizationUrl --project $projectName

$pipelineVars = @{
    repository     = $newRepoName
    project        = $projectName
    solution       = $solutionFile
    configDev      = "Release-Dev"
    configProd     = "Release"
    baseDirectory  = "\\server\path\to\builds"
}

foreach ($key in $pipelineVars.Keys) {
    az pipelines variable create --name $key --value $pipelineVars[$key] --project $projectName --org $organizationUrl --pipeline-name $pipelineName
}

# --- POLÍTICAS DE RAMAS ---
function Set-BranchPolicies($branchName) {
    $repoInfo = (az repos list --org $organizationUrl --project $projectName | ConvertFrom-Json) | Where-Object { $_.name -eq $newRepoName }
    $pipelineInfo = (az pipelines list --org $organizationUrl --project $projectName | ConvertFrom-Json) | Where-Object { $_.name -eq $pipelineName }

    az repos policy approver-count create --org $organizationUrl --project $projectName --allow-downvotes false --blocking false --branch $branchName `
        --creator-vote-counts true --enabled true --minimum-approver-count 1 --repository-id $repoInfo.Id --reset-on-source-push false --output table

    az repos policy work-item-linking create --org $organizationUrl --project $projectName --repository-id $repoInfo.Id --branch $branchName --blocking false --enabled false
    az repos policy comment-required create --org $organizationUrl --project $projectName --blocking true --branch $branchName --enabled true --repository-id $repoInfo.Id
    az repos policy merge-strategy create --org $organizationUrl --project $projectName --blocking true --branch $branchName --enabled true --repository-id $repoInfo.Id --allow-no-fast-forward true
    az repos policy build create --org $organizationUrl --project $projectName --blocking true --branch $branchName --enabled true --repository-id $repoInfo.Id `
        --build-definition-id $pipelineInfo.id --manual-queue-only false --queue-on-source-update-only true --valid-duration 720 --display-name $pipelineName
    az repos policy required-reviewer create --org $organizationUrl --project $projectName --blocking true --branch $branchName --enabled true `
        --repository-id $repoInfo.Id --message "reviewer@example.com" --required-reviewer-ids "reviewer@example.com"
}

Set-BranchPolicies $branchMain
Set-BranchPolicies $branchPre
Set-BranchPolicies $branchDev

# --- GRUPO DE VARIABLES ---
az pipelines variable-group create --name "DeployCredentials" --variables Deploy_Username="domain\\deploy_user" Deploy_Password="P@ssword" --org $organizationUrl --project $projectName
$varGroup = (az pipelines variable-group list --org $organizationUrl --project $projectName | ConvertFrom-Json) | Where-Object { $_.name -eq "DeployCredentials" }
az pipelines variable-group variable create --group-id $varGroup.Id --name "Deploy_Password" --value "SuperSecret123" --org $organizationUrl --project $projectName
