#!/usr/bin/env python

import sys, time, subprocess, os, argparse
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


parser = argparse.ArgumentParser()
parser.add_argument('-H', action='store', dest='remoteIP',
                    help='Remote server ip', required=True)
parser.add_argument('-p', action='store', dest='remotePort',
                    help='Remote ssh port', required=True)
parser.add_argument('-u', action='store', dest='remoteUser',
                    help='Remote username', required=True)
parser.add_argument('-s', action='store', dest='srcPath',
                    help='Src folder for sync')
parser.add_argument('-d', action='store', dest='dstPath',
                    help='Dst folder for sync', required=True)
args = parser.parse_args()

if (not args.srcPath):
    args.srcPath =os.path.dirname(os.path.realpath(__file__)) + "/../../.."



def doCopy():
    cmd =   'rsync  -rlptzv --exclude ".git" --exclude "deploy/scripts" -e "ssh -p ' + args.remotePort + \
            '" ' + args.srcPath + '/ ' + args.remoteUser + '@' + args.remoteIP + ':' + args.dstPath
    print subprocess.check_output(['bash','-c', cmd])


class CreatedHandler(FileSystemEventHandler):
    def on_modified(self, event):
        print 'modified: ' + event.src_path
        doCopy()

    def on_created(self, event):
        print 'created: ' + event.src_path
        doCopy()


if __name__ == "__main__":
    event_handler = CreatedHandler()
    observer = Observer()
    observer.schedule(event_handler, args.srcPath, recursive=True)
    observer.start()
    print "Watching..."
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
