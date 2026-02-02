#!/usr/bin/env python3
"""
Script template for agent commands.

This template provides a cross-platform foundation for command scripts
that work on Windows, macOS, and Linux.

Usage: python3 script-name.py <input> [--option value]
Platforms: Windows, macOS, Linux
Requirements: Python 3.8+
"""

import sys
import argparse
from pathlib import Path
from typing import Optional


def main() -> int:
    """
    Main entry point for the script.
    
    Returns:
        int: Exit code (0 for success, non-zero for error)
    """
    parser = argparse.ArgumentParser(
        description="Description of what this script does"
    )
    
    # Add arguments
    parser.add_argument(
        "input",
        type=str,
        help="Input file or directory path"
    )
    
    parser.add_argument(
        "--output",
        type=str,
        default="output",
        help="Output directory (default: output)"
    )
    
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable verbose output"
    )
    
    args = parser.parse_args()
    
    # Validate input
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: Input path does not exist: {input_path}", file=sys.stderr)
        return 1
    
    # Create output directory
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Verbose logging
    if args.verbose:
        print(f"Input: {input_path}")
        print(f"Output: {output_dir}")
    
    try:
        # Main processing logic here
        process_input(input_path, output_dir, args.verbose)
        
        print("✓ Processing complete!")
        return 0
        
    except Exception as e:
        print(f"Error during processing: {e}", file=sys.stderr)
        return 1


def process_input(input_path: Path, output_dir: Path, verbose: bool = False) -> None:
    """
    Process the input and generate output.
    
    Args:
        input_path: Path to input file or directory
        output_dir: Directory for output files
        verbose: Enable verbose logging
    """
    if verbose:
        print(f"Processing {input_path}...")
    
    # Your processing logic here
    # Example: Read input, process, write output
    
    if input_path.is_file():
        # Process single file
        content = input_path.read_text(encoding="utf-8")
        output_file = output_dir / f"processed-{input_path.name}"
        output_file.write_text(content, encoding="utf-8")
        
        if verbose:
            print(f"  Created: {output_file}")
    
    elif input_path.is_dir():
        # Process directory
        for file_path in input_path.glob("*"):
            if file_path.is_file():
                # Process each file
                if verbose:
                    print(f"  Processing: {file_path}")


if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print("\n✗ Cancelled by user", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(f"✗ Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)
