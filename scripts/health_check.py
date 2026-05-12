import os
import re
from pathlib import Path

def check_consistency():
    # Use colorama if available
    try:
        from colorama import Fore, Style, init
        init(autoreset=True)
        SUCCESS, ERROR, WARN, INFO = Fore.GREEN + "✅ ", Fore.RED + "❌ ", Fore.YELLOW + "⚠️  ", Fore.BLUE + "ℹ️  "
    except ImportError:
        SUCCESS, ERROR, WARN, INFO = "✅ ", "❌ ", "⚠️  ", "ℹ️  "

    root_dir = Path(__file__).parent.parent
    readme_files = list(root_dir.glob("**/*.md"))
    all_referenced_files = set()
    
    print(f"\n--- Starting Health Check for: {root_dir} ---\n")

    # 1. Extract file references (Links, code blocks, or plain paths)
    file_pattern = re.compile(r'(?:^|[\s\(`"\'\d])([a-zA-Z0-9_\-\.\/]+\.(?:sql|sh|yml|yaml|md))(?=$|[\s\)`"\'\d])')
    
    missing_files = []
    for readme in readme_files:
        with open(readme, 'r', encoding='utf-8') as f:
            content = f.read()
            references = file_pattern.findall(content)
            for ref in references:
                # Ignore generic names and this script itself
                if ref in ['postgresql.conf', 'pg_hba.conf']: continue
                
                # Resolve relative path based on README location or repository root
                if ref.startswith('/'):
                    potential_path = root_dir / ref.lstrip('/')
                else:
                    candidate = readme.parent / ref
                    if candidate.exists():
                        potential_path = candidate
                    else:
                        potential_path = root_dir / ref
                if not potential_path.exists():
                    missing_files.append((readme.name, ref))
                else:
                    all_referenced_files.add(potential_path.resolve())

    if missing_files:
        print(f"{ERROR}Missing Files Referenced in READMEs:")
        for readme, missing in missing_files:
            print(f"  - In {readme}: Could not find '{missing}'")
    else:
        print(f"{SUCCESS}All file references in READMEs are valid.")

    # 2. Check for User Consistency, Port Conflicts, and Orphaned Files
    user_patterns = {'engineer': [], 'postgres': []}
    ports_found = {} # {port: [file1, file2]}
    existing_files = set()
    
    target_extensions = ['.sh', '.sql', '.yml', '.yaml']
    port_pattern = re.compile(r'(?:port|PORT)[:\s=]+"?(\d{4,5})"?')

    for path in root_dir.rglob('*'):
        if any(part in path.parts for part in ['pgdata', '.git', 'node_modules', '.github']): continue
        if path.is_file():
            existing_files.add(path.resolve())
        
        if path.suffix in target_extensions:
            try:
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                    # User check
                    if 'engineer' in content.lower():
                        user_patterns['engineer'].append(path.name)
                    if 'U postgres' in content or 'user: postgres' in content:
                        user_patterns['postgres'].append(path.name)

                    # Port conflict check
                    ports = port_pattern.findall(content)
                    for p in ports:
                        if p not in ports_found: ports_found[p] = []
                        ports_found[p].append(path.name)
            except: continue
    
    # Check for Orphaned Files (Existing but not in any README)
    orphans = [f for f in existing_files if f.suffix in target_extensions and f not in all_referenced_files]
    if orphans:
        print(f"\n{INFO}Orphaned Files (Exist but not referenced in any README):")
        for f in orphans:
            print(f"  - {f.relative_to(root_dir)}")

    # Report Port Conflicts
    conflicts = {p: files for p, files in ports_found.items() if len(set(files)) > 1}
    if conflicts:
        print(f"\n{WARN}Port Usage Summary (Check for conflicts):")
        for port, files in conflicts.items():
            print(f"  - Port {port} used in multiple files: {list(set(files))}")
    else:
        print(f"\n{SUCCESS}No port conflicts detected.")

    if user_patterns['engineer'] and user_patterns['postgres']:
        print(f"\n{WARN}User Inconsistency Detected:")
        print(f"  - Files using 'engineer': {set(user_patterns['engineer'])}")
        print(f"  - Files using 'postgres': {set(user_patterns['postgres'])}")
        print("  Suggestion: Standardize DB_USER across all environments.")
    else:
        print(f"{SUCCESS}Database user consistency check passed.")

    # 3. SQL Syntax Basic Validation
    sql_errors = []
    for sql_file in [f for f in existing_files if f.suffix == '.sql']:
        with open(sql_file, 'r', encoding='utf-8') as f:
            content = f.read()
            # Check for unclosed quotes or basic markers
            if content.count("'") % 2 != 0:
                sql_errors.append(f"{sql_file.name}: Potential unclosed single quote")
            if "BEGIN" in content and "COMMIT" not in content and "ROLLBACK" not in content:
                # Only a warning as it might be intentional
                pass 

    if sql_errors:
        print(f"\n{ERROR}SQL Static Analysis Issues:")
        for err in sql_errors:
            print(f"  - {err}")
    else:
        print(f"\n{SUCCESS}SQL basic static analysis passed.")

    print(f"\n--- Health Check Completed ---\n")

if __name__ == "__main__":
    check_consistency()