# Script de Despliegue de Infraestructura
# Terraform Infrastructure Deployment Script

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Portfolio Adrian Riera - Terraform Deployment" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

function Deploy-Module {
    param (
        [string]$ModulePath,
        [string]$ModuleName
    )
    
    Write-Host "🔄 Desplegando módulo: $ModuleName" -ForegroundColor Yellow
    Write-Host "📁 Ruta: $ModulePath" -ForegroundColor Gray
    Write-Host ""
    
    Push-Location $ModulePath
    
    try {
        # Inicializar Terraform
        Write-Host "  ⚙️  Inicializando Terraform..." -ForegroundColor Cyan
        terraform init -upgrade
        
        if ($LASTEXITCODE -ne 0) {
            throw "Error en terraform init"
        }
        
        # Formatear código
        Write-Host "  📝 Formateando código..." -ForegroundColor Cyan
        terraform fmt -recursive
        
        # Validar configuración
        Write-Host "  ✅ Validando configuración..." -ForegroundColor Cyan
        terraform validate
        
        if ($LASTEXITCODE -ne 0) {
            throw "Error en terraform validate"
        }
        
        # Mostrar plan
        Write-Host "  📊 Generando plan de ejecución..." -ForegroundColor Cyan
        terraform plan -out=tfplan
        
        if ($LASTEXITCODE -ne 0) {
            throw "Error en terraform plan"
        }
        
        # Preguntar confirmación
        Write-Host ""
        $confirm = Read-Host "  ❓ ¿Deseas aplicar estos cambios? (yes/no)"
        
        if ($confirm -eq "yes") {
            Write-Host "  🚀 Aplicando cambios..." -ForegroundColor Green
            terraform apply tfplan
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✅ Módulo $ModuleName desplegado exitosamente!" -ForegroundColor Green
                
                # Mostrar outputs
                Write-Host ""
                Write-Host "  📤 Outputs del módulo:" -ForegroundColor Cyan
                terraform output
            } else {
                throw "Error en terraform apply"
            }
        } else {
            Write-Host "  ⏭️  Aplicación cancelada por el usuario" -ForegroundColor Yellow
        }
        
        # Limpiar archivo de plan
        if (Test-Path "tfplan") {
            Remove-Item "tfplan"
        }
        
    } catch {
        Write-Host "  ❌ Error: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
    
    Pop-Location
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    return $true
}

# Obtener ruta base
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Menú de opciones
Write-Host "Selecciona la opción de despliegue:" -ForegroundColor Yellow
Write-Host "  1. Desplegar Core (Route53)" -ForegroundColor White
Write-Host "  2. Desplegar Portfolio Frontend (S3 + CloudFront)" -ForegroundColor White
Write-Host "  3. Desplegar Todo (Core + Frontend)" -ForegroundColor White
Write-Host "  4. Solo validar (sin aplicar cambios)" -ForegroundColor White
Write-Host "  5. Destruir infraestructura (PELIGRO)" -ForegroundColor Red
Write-Host ""

$option = Read-Host "Opción"

switch ($option) {
    "1" {
        Deploy-Module -ModulePath "$ScriptPath\core" -ModuleName "Core (Route53)"
    }
    "2" {
        Deploy-Module -ModulePath "$ScriptPath\aplicaciones\portfolio-frontend" -ModuleName "Portfolio Frontend"
    }
    "3" {
        $success = Deploy-Module -ModulePath "$ScriptPath\core" -ModuleName "Core (Route53)"
        if ($success) {
            Start-Sleep -Seconds 2
            Deploy-Module -ModulePath "$ScriptPath\aplicaciones\portfolio-frontend" -ModuleName "Portfolio Frontend"
        } else {
            Write-Host "❌ No se desplegará Frontend debido a errores en Core" -ForegroundColor Red
        }
    }
    "4" {
        Write-Host "🔍 Validando todos los módulos..." -ForegroundColor Cyan
        
        Push-Location "$ScriptPath\core"
        terraform init -upgrade
        terraform fmt -recursive
        terraform validate
        Pop-Location
        
        Push-Location "$ScriptPath\aplicaciones\portfolio-frontend"
        terraform init -upgrade
        terraform fmt -recursive
        terraform validate
        Pop-Location
        
        Write-Host "✅ Validación completada" -ForegroundColor Green
    }
    "5" {
        Write-Host ""
        Write-Host "⚠️  ADVERTENCIA: Esto eliminará TODA la infraestructura" -ForegroundColor Red
        Write-Host "⚠️  Esta acción NO se puede deshacer" -ForegroundColor Red
        Write-Host ""
        $confirm = Read-Host "Escribe 'DESTROY' para confirmar"
        
        if ($confirm -eq "DESTROY") {
            Write-Host "🗑️  Destruyendo Frontend primero..." -ForegroundColor Yellow
            Push-Location "$ScriptPath\aplicaciones\portfolio-frontend"
            terraform destroy
            Pop-Location
            
            Write-Host "🗑️  Destruyendo Core..." -ForegroundColor Yellow
            Push-Location "$ScriptPath\core"
            terraform destroy
            Pop-Location
            
            Write-Host "✅ Infraestructura eliminada" -ForegroundColor Green
        } else {
            Write-Host "❌ Destrucción cancelada" -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "❌ Opción no válida" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🏁 Script finalizado" -ForegroundColor Cyan
