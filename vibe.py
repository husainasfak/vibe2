import argparse
from dotenv import load_dotenv
import os

load_dotenv()

secret = os.getenv('SECRET')


def health():
    try:
        print("Hey I am doing fine")
        print("Hey I am doing fine")
        print(secret)
    except Exception as e:
        print("Error:", e)
        
        

def main():
    parser = argparse.ArgumentParser(prog="vibe", description="Vibe CLI Tool")
    subparsers = parser.add_subparsers(dest="command")
    # add sub command
    subparsers.add_parser("health", help="Check the health of the Vibe")
    # egisters the health command
    args = parser.parse_args()
    
    if args.command == "health":
        health()
    else:
        parser.print_help()
        


if __name__ == "__main__":
    main()