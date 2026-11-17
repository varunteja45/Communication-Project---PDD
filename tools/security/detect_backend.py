#!/usr/bin/env python3
"""
Universal Backend Technology Stack Detector
Detects backend framework, language, database, ORM, API architecture,
and security configurations across any repository.
"""

import os
import json
import sys

def detect_stack(root_dir="."):
    findings = {
        "framework": "Unknown",
        "language": "Unknown",
        "api_architecture": "REST API",
        "database": "Unknown",
        "orm": "None",
        "auth_mechanism": "Custom / Unknown",
        "realtime_engine": "None",
        "package_manager": "Unknown",
        "root_path": os.path.abspath(root_dir),
        "manifest_files": []
    }

    # Walk directory to find indicators
    files_found = set()
    for root, dirs, files in os.walk(root_dir):
        # Exclude vendor / build directories from shallow checks
        dirs[:] = [d for d in dirs if d not in ['.git', 'node_modules', '.dart_tool', 'build', '.idea', 'dist']]
        for f in files:
            files_found.add(f)
            rel_path = os.path.relpath(os.path.join(root, f), root_dir)
            
            # Check package.json
            if f == "package.json":
                findings["manifest_files"].append(rel_path)
                try:
                    with open(os.path.join(root, f), 'r', encoding='utf-8') as pf:
                        pkg = json.load(pf)
                        deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}
                        if "express" in deps:
                            findings["framework"] = "Express.js"
                            findings["language"] = "JavaScript / Node.js"
                        elif "@nestjs/core" in deps:
                            findings["framework"] = "NestJS"
                            findings["language"] = "TypeScript / Node.js"
                        elif "koa" in deps:
                            findings["framework"] = "Koa"
                            findings["language"] = "JavaScript / Node.js"
                        elif "fastify" in deps:
                            findings["framework"] = "Fastify"
                            findings["language"] = "JavaScript / Node.js"

                        if "sqlite3" in deps or "better-sqlite3" in deps:
                            findings["database"] = "SQLite"
                        elif "pg" in deps or "postgres" in deps:
                            findings["database"] = "PostgreSQL"
                        elif "mysql" in deps or "mysql2" in deps:
                            findings["database"] = "MySQL"
                        elif "mongoose" in deps or "mongodb" in deps:
                            findings["database"] = "MongoDB"
                            findings["orm"] = "Mongoose ODM"

                        if "sequelize" in deps:
                            findings["orm"] = "Sequelize ORM"
                        elif "prisma" in deps or "@prisma/client" in deps:
                            findings["orm"] = "Prisma ORM"
                        elif "typeorm" in deps:
                            findings["orm"] = "TypeORM"

                        if "ws" in deps or "socket.io" in deps:
                            findings["realtime_engine"] = "WebSockets"

                        if "jsonwebtoken" in deps:
                            findings["auth_mechanism"] = "JWT (JSON Web Tokens)"
                        elif "passport" in deps:
                            findings["auth_mechanism"] = "Passport.js Session / OAuth"

                        findings["package_manager"] = "npm / pnpm / yarn"
                except Exception:
                    pass

            # Check Python requirements / pyproject
            elif f in ["requirements.txt", "Pipfile", "pyproject.toml"]:
                findings["manifest_files"].append(rel_path)
                findings["language"] = "Python"
                findings["package_manager"] = "pip / poetry"
                try:
                    with open(os.path.join(root, f), 'r', encoding='utf-8', errors='ignore') as rf:
                        content = rf.read().lower()
                        if "django" in content:
                            findings["framework"] = "Django"
                            findings["orm"] = "Django ORM"
                        elif "fastapi" in content:
                            findings["framework"] = "FastAPI"
                        elif "flask" in content:
                            findings["framework"] = "Flask"
                        if "sqlalchemy" in content:
                            findings["orm"] = "SQLAlchemy"
                except Exception:
                    pass

            # Check Java / Spring Boot (excluding mobile Android gradle)
            elif f == "pom.xml" or (f == "build.gradle" and "android" not in root.lower()):
                try:
                    with open(os.path.join(root, f), 'r', encoding='utf-8', errors='ignore') as jf:
                        jcontent = jf.read().lower()
                        if "spring" in jcontent or "boot" in jcontent:
                            findings["manifest_files"].append(rel_path)
                            findings["language"] = "Java / Kotlin"
                            findings["framework"] = "Spring Boot"
                            findings["orm"] = "Spring Data JPA / Hibernate"
                            findings["package_manager"] = "Maven / Gradle"
                except Exception:
                    pass

            # Check Go
            elif f == "go.mod":
                findings["manifest_files"].append(rel_path)
                findings["language"] = "Go"
                findings["package_manager"] = "Go Modules"
                try:
                    with open(os.path.join(root, f), 'r', encoding='utf-8', errors='ignore') as gf:
                        content = gf.read()
                        if "gin-gonic" in content:
                            findings["framework"] = "Gin"
                        elif "gofiber" in content:
                            findings["framework"] = "Fiber"
                except Exception:
                    pass

            # Check PHP / Laravel
            elif f in ["artisan", "composer.json"]:
                findings["manifest_files"].append(rel_path)
                findings["language"] = "PHP"
                findings["framework"] = "Laravel"
                findings["orm"] = "Eloquent ORM"
                findings["package_manager"] = "Composer"

            # Check Ruby on Rails
            elif f == "Gemfile":
                findings["manifest_files"].append(rel_path)
                findings["language"] = "Ruby"
                findings["framework"] = "Ruby on Rails"
                findings["orm"] = "ActiveRecord"
                findings["package_manager"] = "Bundler"

            # Check ASP.NET
            elif f.endswith(".csproj") or f.endswith(".sln"):
                findings["manifest_files"].append(rel_path)
                findings["language"] = "C# / .NET"
                findings["framework"] = "ASP.NET Core"
                findings["orm"] = "Entity Framework Core"
                findings["package_manager"] = "NuGet"

    # Specific database heuristics if sqlite file is present
    for root, dirs, files in os.walk(root_dir):
        dirs[:] = [d for d in dirs if d not in ['.git', 'node_modules', '.dart_tool', 'build']]
        for f in files:
            if f.endswith(".db") or f.endswith(".sqlite") or f.endswith(".sqlite3"):
                findings["database"] = f"SQLite ({f})"

    return findings

if __name__ == "__main__":
    search_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    result = detect_stack(search_dir)
    print(json.dumps(result, indent=2))
