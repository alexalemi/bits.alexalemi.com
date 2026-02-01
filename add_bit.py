#!/usr/bin/env python3
"""
Interactive CLI for adding new bits using Claude to structure freeform input.

Usage:
    python add_bit.py

Type your thoughts, URLs, whatever - then press Enter twice (empty line) to submit.
Claude will structure it into a bit, then open your $EDITOR to review/edit.
"""

import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

import anthropic


def get_user_input() -> str:
    """Read freeform multiline input from the user."""
    print("Enter your bit (empty line to finish):")
    lines = []
    while True:
        try:
            line = input("> ")
            if line == "":
                break
            lines.append(line)
        except EOFError:
            break
    return "\n".join(lines)


def structure_with_claude(text: str) -> dict:
    """Use Claude API with structured output to create a bit object."""
    client = anthropic.Anthropic()

    # Define the tool for structured output
    tools = [
        {
            "name": "create_bit",
            "description": "Create a structured bit object from freeform text",
            "input_schema": {
                "type": "object",
                "properties": {
                    "title": {
                        "type": "string",
                        "description": "A concise, descriptive title for the bit (not too long)"
                    },
                    "url": {
                        "type": "string",
                        "description": "URL if one was mentioned in the text. Leave empty if no URL."
                    },
                    "content": {
                        "type": "string",
                        "description": "The user's commentary, thoughts, or description. Can be empty if the title says it all."
                    },
                    "tags": {
                        "type": "array",
                        "items": {"type": "string"},
                        "description": "Relevant short tags (lowercase, hyphenated if multi-word)"
                    },
                    "via": {
                        "type": "string",
                        "description": "Source where this was found (e.g., 'Hacker News', 'Twitter'). Leave empty if not mentioned."
                    }
                },
                "required": ["title"]
            }
        }
    ]

    message = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=1024,
        tools=tools,
        tool_choice={"type": "tool", "name": "create_bit"},
        messages=[
            {
                "role": "user",
                "content": f"""Structure the following freeform text into a bit (a short link-blog entry).
Extract or generate:
- A concise title
- The URL if one is present
- Any commentary/thoughts as content
- Relevant tags
- The source (via) if mentioned

Text:
{text}"""
            }
        ]
    )

    # Extract the tool use result
    for block in message.content:
        if block.type == "tool_use":
            return block.input

    raise ValueError("Claude didn't return structured output")


def open_in_editor(data: dict) -> dict:
    """Open the bit in $EDITOR for user review/editing."""
    editor = os.environ.get("EDITOR", os.environ.get("VISUAL", "vim"))

    # Pretty-print JSON for editing
    json_str = json.dumps(data, indent=2, ensure_ascii=False)

    with tempfile.NamedTemporaryFile(
        mode="w",
        suffix=".json",
        delete=False,
        prefix="bit_"
    ) as f:
        f.write(json_str)
        f.write("\n")
        temp_path = f.name

    try:
        # Open editor and wait
        subprocess.run([editor, temp_path], check=True)

        # Read back
        with open(temp_path) as f:
            content = f.read()

        # Try to parse JSON
        try:
            return json.loads(content)
        except json.JSONDecodeError as e:
            print(f"Invalid JSON: {e}")
            retry = input("Re-edit? [Y/n] ").strip().lower()
            if retry != "n":
                return open_in_editor(json.loads(json_str))  # Re-open with original
            else:
                raise SystemExit("Aborted")
    finally:
        os.unlink(temp_path)


def slugify(text: str) -> str:
    """Convert text to a URL-friendly slug."""
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"^-|-$", "", text)
    return text[:50]


def add_bit(bit: dict) -> None:
    """Add the bit to bits.json and rebuild the site."""
    root = Path(__file__).parent
    bits_path = root / "data" / "bits.json"

    # Load existing bits
    with open(bits_path) as f:
        bits = json.load(f)

    # Add metadata
    bit["id"] = f"{slugify(bit['title'])}-{int(time.time() * 1000)}"
    bit["date"] = time.strftime("%Y-%m-%d")

    # Remove empty optional fields
    for key in ["url", "content", "via"]:
        if key in bit and not bit[key]:
            del bit[key]
    if "tags" in bit and not bit["tags"]:
        del bit["tags"]

    # Prepend to list
    bits.insert(0, bit)

    # Write back
    with open(bits_path, "w") as f:
        json.dump(bits, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"Added bit: {bit['title']}")

    # Rebuild site
    print("Rebuilding site...")
    subprocess.run([sys.executable, root / "build_bits.py"], check=True)
    print("Done!")


def main():
    # Check for API key
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("Error: ANTHROPIC_API_KEY environment variable not set")
        sys.exit(1)

    # Get input
    text = get_user_input()
    if not text.strip():
        print("No input provided, exiting.")
        sys.exit(0)

    # Structure with Claude
    print("\nCalling Claude to structure your bit...")
    try:
        bit = structure_with_claude(text)
    except Exception as e:
        print(f"Error calling Claude: {e}")
        sys.exit(1)

    # Open in editor
    print("Opening editor...")
    bit = open_in_editor(bit)

    # Confirm
    print("\nFinal bit:")
    print(json.dumps(bit, indent=2))
    confirm = input("\nAdd this bit? [Y/n] ").strip().lower()
    if confirm == "n":
        print("Aborted.")
        sys.exit(0)

    # Add and rebuild
    add_bit(bit)


if __name__ == "__main__":
    main()
