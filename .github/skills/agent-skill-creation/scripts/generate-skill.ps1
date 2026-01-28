# generate-skill.ps1 - Agent Skill Generator (PowerShell/Windows)
#
# Usage:
#   .\generate-skill.ps1 -Name skill-name -Description "Skill description"
#   .\generate-skill.ps1 -Name skill-name -Description "Skill description" -Author "Your Name"
#   .\generate-skill.ps1 -Name skill-name -Description "Skill description" -OutputDir .\custom-path
#
# Author: Dau Quang Thanh
# License: MIT

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$true)]
    [string]$Description,
    
    [Parameter(Mandatory=$false)]
    [string]$Author = "Dau Quang Thanh",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputDir,
    
    [Parameter(Mandatory=$false)]
    [switch]$WithScripts,
    
    [Parameter(Mandatory=$false)]
    [switch]$WithReferences,
    
    [Parameter(Mandatory=$false)]
    [switch]$WithTemplates,
    
    [Parameter(Mandatory=$false)]
    [switch]$Full
)

$ErrorActionPreference = 'Stop'

# Validate skill name
function Test-SkillName {
    param([string]$SkillName)
    
    # Length check
    if ($SkillName.Length -lt 1 -or $SkillName.Length -gt 64) {
        Write-Error "Skill name must be 1-64 characters (current: $($SkillName.Length))"
        return $false
    }
    
    # Only lowercase letters, numbers, and hyphens
    if ($SkillName -notmatch '^[a-z0-9-]+$') {
        Write-Error "Skill name must only contain lowercase letters, numbers, and hyphens"
        return $false
    }
    
    # Cannot start or end with hyphen
    if ($SkillName -match '^-' -or $SkillName -match '-$') {
        Write-Error "Skill name cannot start or end with a hyphen"
        return $false
    }
    
    # No consecutive hyphens
    if ($SkillName -match '--') {
        Write-Error "Skill name cannot contain consecutive hyphens"
        return $false
    }
    
    return $true
}

# Validate description
function Test-Description {
    param([string]$Desc)
    
    if ($Desc.Length -lt 1 -or $Desc.Length -gt 1024) {
        Write-Error "Description must be 1-1024 characters (current: $($Desc.Length))"
        return $false
    }
    
    return $true
}

# Convert skill-name to Title Case
function ConvertTo-TitleCase {
    param([string]$Text)
    
    $words = $Text -split '-'
    $titleWords = $words | ForEach-Object {
        $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
    }
    return $titleWords -join ' '
}

# Generate SKILL.md content
function New-SkillMdContent {
    param(
        [string]$SkillName,
        [string]$Desc,
        [string]$AuthorName
    )
    
    $today = Get-Date -Format "yyyy-MM-dd"
    $title = ConvertTo-TitleCase -Text $SkillName
    
    return @"
---
name: $SkillName
description: "$Desc"
license: MIT
metadata:
  author: $AuthorName
  version: "1.0.0"
  last-updated: "$today"
---

# $title

## When to Use

- [Describe scenario 1 when this skill should be activated]
- [Describe scenario 2]
- [Describe scenario 3]

## Prerequisites

- [List required tools or packages]
- [Add environment requirements if any]

## Instructions

### Step 1: [First Action]

[Provide clear, step-by-step instructions for the first action]

1. Detail 1
2. Detail 2
3. Detail 3

### Step 2: [Second Action]

[Continue with sequential steps]

``````bash
# Example command if applicable
command --option value
``````

### Step 3: [Complete Task]

[Final steps to complete the task]

## Examples

### Example 1: Basic Usage

**Input:**
``````
[Show example input]
``````

**Expected Output:**
``````
[Show expected result]
``````

**Explanation:**
[Brief explanation of what happened]

## Edge Cases

### Case 1: [Unusual Situation]

**Description**: [Explain the edge case]

**Handling**: [How to handle this situation]

### Case 2: [Error Condition]

**Description**: [Explain the error condition]

**Handling**: [Steps to resolve]

## Error Handling

### Error: [Error Type]

**Symptoms**: [How to identify this error]

**Resolution**:
1. [Step to resolve]
2. [Another step]

## Guidelines

1. [Important rule to follow]
2. [Best practice to maintain]
3. [Convention to follow]

## Additional Resources

- [Add links to references if needed]
"@
}

# Generate sample PowerShell script
function New-SampleScript {
    param([string]$SkillName)
    
    $title = ConvertTo-TitleCase -Text $SkillName
    
    return @"
# $SkillName.ps1 - $title Script

[CmdletBinding()]
param(
    [Parameter(Mandatory=`$true)]
    [string]`$InputFile,
    
    [Parameter(Mandatory=`$false)]
    [string]`$OutputFile
)

`$ErrorActionPreference = 'Stop'

# Validate input file
if (-not (Test-Path `$InputFile)) {
    Write-Error "File not found: `$InputFile"
    exit 1
}

Write-Host "Processing: `$InputFile" -ForegroundColor Green

# TODO: Add your processing logic here

if (`$OutputFile) {
    Write-Host "Output saved to: `$OutputFile" -ForegroundColor Green
} else {
    Write-Host "Processing complete" -ForegroundColor Green
}
"@
}

# Generate sample reference
function New-SampleReference {
    param([string]$SkillName)
    
    $title = ConvertTo-TitleCase -Text $SkillName
    
    return @"
# $title - Detailed Guide

## Overview

[Provide detailed background information about this skill]

## Concepts

### Concept 1

[Explain important concepts]

### Concept 2

[Continue with more details]

## Advanced Usage

[Provide advanced techniques and patterns]

## Best Practices

1. [Best practice 1]
2. [Best practice 2]
3. [Best practice 3]

## Troubleshooting

### Issue 1

**Problem**: [Describe the problem]

**Solution**: [Provide solution]

### Issue 2

**Problem**: [Another issue]

**Solution**: [Another solution]

## References

- [External resources]
- [Documentation links]
- [Related materials]
"@
}

# Main execution
try {
    # Validate inputs
    if (-not (Test-SkillName -SkillName $Name)) {
        exit 1
    }
    
    if (-not (Test-Description -Desc $Description)) {
        exit 1
    }
    
    # Determine output directory
    if ([string]::IsNullOrEmpty($OutputDir)) {
        $OutputDir = Join-Path (Get-Location) $Name
    } else {
        $OutputDir = Join-Path $OutputDir $Name
    }
    
    # Determine which directories to include
    if ($Full) {
        $WithScripts = $true
        $WithReferences = $true
        $WithTemplates = $true
    }
    
    Write-Host "`nGenerating skill: $Name" -ForegroundColor Blue
    Write-Host "Author: $Author" -ForegroundColor Blue
    Write-Host "Description: $($Description.Substring(0, [Math]::Min(60, $Description.Length)))..." -ForegroundColor Blue
    Write-Host ""
    
    # Create main directory
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir | Out-Null
    }
    Write-Host "✓ Created directory: $OutputDir" -ForegroundColor Green
    
    # Generate SKILL.md
    $skillMdContent = New-SkillMdContent -SkillName $Name -Desc $Description -AuthorName $Author
    $skillMdPath = Join-Path $OutputDir "SKILL.md"
    $skillMdContent | Out-File -FilePath $skillMdPath -Encoding UTF8
    Write-Host "✓ Created SKILL.md" -ForegroundColor Green
    
    # Create optional directories
    if ($WithScripts) {
        $scriptsDir = Join-Path $OutputDir "scripts"
        if (-not (Test-Path $scriptsDir)) {
            New-Item -ItemType Directory -Path $scriptsDir | Out-Null
        }
        
        $scriptContent = New-SampleScript -SkillName $Name
        $scriptPath = Join-Path $scriptsDir "$Name.ps1"
        $scriptContent | Out-File -FilePath $scriptPath -Encoding UTF8
        Write-Host "✓ Created scripts/" -ForegroundColor Green
    }
    
    if ($WithReferences) {
        $referencesDir = Join-Path $OutputDir "references"
        if (-not (Test-Path $referencesDir)) {
            New-Item -ItemType Directory -Path $referencesDir | Out-Null
        }
        
        $referenceContent = New-SampleReference -SkillName $Name
        $referencePath = Join-Path $referencesDir "detailed-guide.md"
        $referenceContent | Out-File -FilePath $referencePath -Encoding UTF8
        Write-Host "✓ Created references/" -ForegroundColor Green
    }
    
    if ($WithTemplates) {
        $templatesDir = Join-Path $OutputDir "templates"
        if (-not (Test-Path $templatesDir)) {
            New-Item -ItemType Directory -Path $templatesDir | Out-Null
        }
        
        $templateContent = @"
# Output Template

[Template content goes here]
"@
        $templatePath = Join-Path $templatesDir "output-template.md"
        $templateContent | Out-File -FilePath $templatePath -Encoding UTF8
        Write-Host "✓ Created templates/" -ForegroundColor Green
    }
    
    Write-Host "`n✓ Skill generated successfully: $OutputDir" -ForegroundColor Green
    Write-Host "`nNext steps:"
    Write-Host "1. Review and customize SKILL.md"
    Write-Host "2. Add detailed instructions and examples"
    Write-Host "3. Implement scripts if needed"
    Write-Host "4. Validate with: .\validate-skill.ps1 -Path $OutputDir"
    Write-Host "5. Test with your target agent"
    
} catch {
    Write-Error "Error generating skill: $_"
    exit 1
}
