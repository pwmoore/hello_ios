CC:=$(shell xcrun -f clang)

IOS_SDK:=$(shell xcrun -sdk iphoneos --show-sdk-path)

# Can also add -arch arm64e to build for A12 devices
ARCH:=-arch arm64

# Add needed frameworks here
FRAMEWORKS:=-framework CoreFoundation

# Add any needed dylibs here
LIBS:=

IOS_LDFLAGS:=$(LIBS) $(FRAMEWORKS)
IOS_CFLAGS:=-isysroot $(IOS_SDK) $(ARCH) -Wall -Wextra -std=gnu99 

SRC:=$(wildcard *.c)
OBJS:=$(patsubst %.c,%.o,$(SRC))

ENT:=$(PWD)/entitlements.plist

BIN:=hello

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(ARCH) $(IOS_CFLAGS) $(IOS_LDFLAGS) $^ -o $@
	codesign -s - --entitlements $(ENT) -f $@

%.o: %.c
	$(CC) $(IOS_CFLAGS) $^ -c -o $@

.PHONY: clean install
clean:
	-rm $(OBJS)
	-rm $(BIN)

install:
	-ssh -p 2222 root@localhost rm /bin/$(BIN)
	scp -P 2222 $(BIN) root@localhost:/bin/$(BIN)

