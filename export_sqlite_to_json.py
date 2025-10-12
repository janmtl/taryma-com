#!/usr/bin/env python3
"""
SQLite to JSON Exporter

This module provides functionality to export all tables from a SQLite database
to separate JSON files.
"""

import sqlite3
import json
import os
from pathlib import Path
from typing import Optional


def export_sqlite_to_json(
    sqlite_file: str,
    output_dir: Optional[str] = None,
    pretty: bool = True
) -> dict[str, str]:
    """
    Export all tables from a SQLite database to separate JSON files.
    
    Args:
        sqlite_file (str): Path to the SQLite database file
        output_dir (str, optional): Directory where JSON files will be saved.
                                   If None, creates a directory named after the database
                                   in the same location as the database file.
        pretty (bool): If True, format JSON with indentation for readability.
                      Default is True.
    
    Returns:
        dict: A dictionary mapping table names to their output file paths
        
    Raises:
        FileNotFoundError: If the SQLite file doesn't exist
        sqlite3.Error: If there's an error accessing the database
    """
    # Verify the SQLite file exists
    sqlite_path = Path(sqlite_file)
    if not sqlite_path.exists():
        raise FileNotFoundError(f"SQLite file not found: {sqlite_file}")
    
    # Determine output directory
    if output_dir is None:
        # Create output directory based on database name
        db_name = sqlite_path.stem  # e.g., "production" from "production.sqlite3"
        output_dir = sqlite_path.parent / f"{db_name}_json_export"
    
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    
    exported_files = {}
    
    # Connect to the database
    conn = sqlite3.connect(sqlite_file)
    conn.row_factory = sqlite3.Row  # This enables column access by name
    cursor = conn.cursor()
    
    try:
        # Get all table names
        cursor.execute("""
            SELECT name FROM sqlite_master 
            WHERE type='table' 
            AND name NOT LIKE 'sqlite_%'
            ORDER BY name
        """)
        
        tables = [row[0] for row in cursor.fetchall()]
        
        if not tables:
            print(f"No tables found in {sqlite_file}")
            return exported_files
        
        print(f"Found {len(tables)} table(s) in {sqlite_file}")
        
        # Export each table
        for table_name in tables:
            print(f"Exporting table: {table_name}")
            
            # Fetch all data from the table
            cursor.execute(f"SELECT * FROM {table_name}")
            rows = cursor.fetchall()
            
            # Convert rows to list of dictionaries
            data = [dict(row) for row in rows]
            
            # Write to JSON file
            output_file = output_path / f"{table_name}.json"
            with open(output_file, 'w', encoding='utf-8') as f:
                if pretty:
                    json.dump(data, f, indent=2, ensure_ascii=False, default=str)
                else:
                    json.dump(data, f, ensure_ascii=False, default=str)
            
            exported_files[table_name] = str(output_file)
            print(f"  → Exported {len(data)} row(s) to {output_file}")
        
        print(f"\nExport complete! All files saved to: {output_path}")
        
    finally:
        conn.close()
    
    return exported_files


def main():
    """Command-line interface for the exporter."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Export all tables from a SQLite database to JSON files"
    )
    parser.add_argument(
        "sqlite_file",
        help="Path to the SQLite database file"
    )
    parser.add_argument(
        "-o", "--output-dir",
        help="Output directory for JSON files (default: auto-generated based on database name)"
    )
    parser.add_argument(
        "--compact",
        action="store_true",
        help="Output compact JSON without indentation"
    )
    
    args = parser.parse_args()
    
    try:
        export_sqlite_to_json(
            args.sqlite_file,
            output_dir=args.output_dir,
            pretty=not args.compact
        )
    except Exception as e:
        print(f"Error: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())


