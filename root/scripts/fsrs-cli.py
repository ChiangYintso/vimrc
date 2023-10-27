#!/bin/python3
from fsrs import Card, FSRS, Rating
import datetime
import argparse
import pickle
import os

DB_NAME = f'{os.path.expanduser("~")}/fsrs.db'

def list_cards():
    if not os.path.exists(DB_NAME):
        return
    with open(DB_NAME, 'rb') as f:
        db = pickle.load(f)
    for (file, card) in db.items():
        print(file, card.scheduled_days, sep='\t')


def _update_card(card: Card) -> Card:
    f = FSRS()
    scheduled_cards = f.repeat(card, datetime.datetime.now())
    return scheduled_cards[Rating.Easy].card


def update_card(file):
    if not os.path.exists(DB_NAME):
        db = {}
    else:
        with open(DB_NAME, 'rb') as f:
            db = pickle.load(f)
    with open(DB_NAME, 'wb+') as f:
        try:
            c = db[file]
        except KeyError:
            c = Card()
        c = _update_card(c)
        db[file] = c
        pickle.dump(db, f)


if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('-l', '--list', action='store_true',
                            help='List all the files in the current directory')
    arg_parser.add_argument('file', type=str, metavar='FILE',
                            nargs='?', help='The file to be read')
    args = arg_parser.parse_args()

    if args.list:
        list_cards()
    elif args.file:
        update_card(args.file)
    else:
        arg_parser.print_help()
