#!/usr/bin/env python3
"""
[Script Name] - [Brief description]

This script [what it does in one sentence].

Usage:
    python3 script-name.py <input> [options]
    python3 script-name.py --help

Examples:
    python3 script-name.py input.txt
    python3 script-name.py input.txt --output result.txt
    python3 script-name.py data.csv --format json --verbose

Platforms:
    - Windows 10/11
    - macOS 12+
    - Linux (Ubuntu 20.04+, Debian 11+)

Requirements:
    - Python 3.8+
    - [package-name] >= [version]  (pip install package-name)

Exit Codes:
    0 - Success
    1 - General error
    2 - Invalid usage/arguments
    130 - Interrupted by user (Ctrl+C)

Author: [Your Name]
Version: 1.0
License: MIT
"""

import sys
import argparse
from pathlib import Path
from typing import Optional


def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
        description='[Script description for help text]',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 script-name.py input.txt
  python3 script-name.py input.txt --output result.txt
  python3 script-name.py data.csv --verbose
        """
    )
    
    # Required arguments
    parser.add_argument(
        'input',
        help='Input file path'
    )
    
    # Optional arguments
    parser.add_argument(
        '--output', '-o',
        help='Output file path (default: stdout)',
        default=None
    )
    
    parser.add_argument(
        '--format', '-f',
        help='Output format',
        choices=['text', 'json', 'csv'],
        default='text'
    )
    
    parser.add_argument(
        '--verbose', '-v',
        help='Enable verbose output',
        action='store_true'
    )
    
    parser.add_argument(
        '--quiet', '-q',
        help='Suppress non-error output',
        action='store_true'
    )
    
    return parser.parse_args()


def validate_input(input_path: Path, verbose: bool = False) -> bool:
    """
    Validate input file exists and is readable.
    
    Args:
        input_path: Path to input file
        verbose: Print verbose messages
        
    Returns:
        True if valid, False otherwise
    """
    if not input_path.exists():
        print(f"Error: Input file not found: {input_path}", file=sys.stderr)
        return False
    
    if not input_path.is_file():
        print(f"Error: Input path is not a file: {input_path}", file=sys.stderr)
        return False
    
    if not input_path.stat().st_size > 0:
        print(f"Warning: Input file is empty: {input_path}", file=sys.stderr)
    
    if verbose:
        print(f"Input file validated: {input_path}")
        print(f"File size: {input_path.stat().st_size} bytes")
    
    return True


def process_file(input_path: Path, output_format: str, verbose: bool = False) -> Optional[str]:
    """
    Process the input file and return results.
    
    Args:
        input_path: Path to input file
        output_format: Desired output format
        verbose: Print verbose messages
        
    Returns:
        Processed content as string, or None on error
    """
    if verbose:
        print(f"Processing {input_path}...")
    
    try:
        # Read input file
        content = input_path.read_text(encoding='utf-8')
        
        # Process content (example: just return it)
        # Replace this with your actual processing logic
        result = content
        
        # Format output based on requested format
        if output_format == 'json':
            # Convert to JSON format
            result = f'{{"content": "{result}"}}'
        elif output_format == 'csv':
            # Convert to CSV format
            result = f"content\n{result}"
        
        if verbose:
            print(f"Processing complete. Output size: {len(result)} characters")
        
        return result
        
    except UnicodeDecodeError as e:
        print(f"Error: Failed to decode file (not UTF-8?): {e}", file=sys.stderr)
        return None
    except Exception as e:
        print(f"Error processing file: {e}", file=sys.stderr)
        return None


def write_output(content: str, output_path: Optional[Path], verbose: bool = False) -> bool:
    """
    Write content to output file or stdout.
    
    Args:
        content: Content to write
        output_path: Output file path (None for stdout)
        verbose: Print verbose messages
        
    Returns:
        True if successful, False otherwise
    """
    try:
        if output_path:
            # Write to file
            output_path.write_text(content, encoding='utf-8')
            if verbose:
                print(f"Output written to: {output_path}")
        else:
            # Write to stdout
            print(content)
        
        return True
        
    except IOError as e:
        print(f"Error writing output: {e}", file=sys.stderr)
        return False


def main() -> int:
    """
    Main function.
    
    Returns:
        Exit code (0 for success, non-zero for error)
    """
    # Parse arguments
    args = parse_arguments()
    
    # Validate quiet and verbose are mutually exclusive
    if args.quiet and args.verbose:
        print("Error: --quiet and --verbose cannot be used together", file=sys.stderr)
        return 2
    
    # Convert paths
    input_path = Path(args.input)
    output_path = Path(args.output) if args.output else None
    
    # Validate input
    if not validate_input(input_path, args.verbose):
        return 1
    
    # Process file
    result = process_file(input_path, args.format, args.verbose)
    if result is None:
        return 1
    
    # Write output
    if not write_output(result, output_path, args.verbose):
        return 1
    
    if not args.quiet:
        print("✓ Success", file=sys.stderr)
    
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n✗ Operation cancelled by user", file=sys.stderr)
        sys.exit(130)
    except Exception as e:
        print(f"✗ Unexpected error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
