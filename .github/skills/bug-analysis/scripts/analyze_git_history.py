#!/usr/bin/env python3
import argparse
import subprocess
import sys
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description="Analyze git history for a specific file.")
    parser.add_argument("file_path", help="Path to the file to analyze")
    parser.add_argument("--limit", type=int, default=10, help="Number of commits to show (default: 10)")
    
    args = parser.parse_args()
    
    target_file = Path(args.file_path)
    
    if not target_file.exists():
        print(f"Error: File '{target_file}' does not exist.")
        sys.exit(1)
        
    print(f"--- Analyzing Git History for: {target_file} ---")
    print("\nRecent Commits:")
    
    try:
        # Run git log
        cmd = ["git", "log", f"-n {args.limit}", "--stat", "--follow", "--", str(target_file)]
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        
        if result.returncode != 0:
            print(f"Error running git log: {result.stderr}")
        else:
            print(result.stdout)
            
        print("\n--- Blame Analysis (Last 20 lines changed) ---")
        print(f"To see full history, run: git blame {target_file}")
            
    except FileNotFoundError:
        print("Error: 'git' command not found. Please ensure git is installed and in your PATH.")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
