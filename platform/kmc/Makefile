override CPPFLAGS += -Iinclude -Isrc/common -Isrc/cac -Isrc/kmc -Isrc/sdp -Isrc/mip -Isrc/mip/linux -Isrc/mip/other
override CPPFLAGS += -DWSEC_COMPILE_CAC_OPENSSL -DWSEC_COMPILE_CAC_OPENSSL -DWSEC_USE_OPENSSL_110 -DWSEC_AES_GCM_SUPPORT -DWSEC_ERR_CODE_BASE=0x10000000
override CPPFLAGS += -ldl -lc -lrt -Wl,-z,relro,-z,now -s -ftrapv -fstack-protector-strong -Wl,-Bsymbolic -Wl,-z,noexecstack -fPIC
override CPPFLAGS += -s -g -DNDEBUG -O2 -fstack-protector-all -Wl,-z,relro -Wl,-z,noexecstack -fPIC  -Wl,-z,now -s -Wformat=2 -Wfloat-equal -Wshadow -Wconversion -Wformat-security -Wextra --param ssp-buffer-size=4 -Warray-bounds -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes -Wstrict-overflow=1 -Wstrict-aliasing=2 -Wswitch -Wswitch-default -D__LP64__ -Wall -DWSEC_CPU_ENDIAN_MODE=2  -DWSEC_AES_GCM_SUPPORT -DWSEC_DEBUG -DWSEC_TRACE_MEMORY  -DWSEC_COMPILE_MIP_LINUX

override CPPFLAGS += -I$(KMC_LD_DEPEND_PATH)/openssl/comm/include -I$(KMC_LD_PLATFORM_PATH)/Huawei_Secure_C/comm/include
override LDFLAGS += -L$(KMC_LD_DEPEND_PATH)/openssl/comm/lib -L$(KMC_LD_PLATFORM_PATH)/Huawei_Secure_C/comm/lib
override LDLIBS += -lcrypto -lsecurec

OBJS = $(patsubst %.c,%.o,$(wildcard src/kmc/*.c))
OBJS += $(patsubst %.c,%.o,$(wildcard src/common/*.c))
OBJS += $(patsubst %.c,%.o,$(wildcard src/cac/*.c))
OBJS += $(patsubst %.c,%.o,$(wildcard src/mip/linux/*.c))
OBJS += $(patsubst %.c,%.o,$(wildcard src/mip/other/*.c))
OBJS := $(sort $(OBJS))

.PHNOY: all
all: libkmc.so
libkmc.so:$(OBJS)
	gcc -shared $(CPPFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o lib/$@ 
	rm -rf ${OBJS}

%.o:%.c 
	gcc ${CPPFLAGS} -c $< -o $@ 

.PHNOY : clean
 clean:
	rm -rf  lib/libkmc.so  $(OBJS)
