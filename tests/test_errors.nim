# SPDX-License-Identifier: BSD-2-Clause

{.compile: "runtime_stub.c".}

import bgfx

proc testInitValidated(): bool {.importc: "bgfxim_test_init_validated", cdecl.}
proc testDebugFlags(): uint32 {.importc: "bgfxim_test_debug_flags", cdecl.}
proc testFrameFlags(): uint8 {.importc: "bgfxim_test_frame_flags", cdecl.}
proc testTriggerRelease(): bool
  {.importc: "bgfxim_test_trigger_release", cdecl.}
proc testCallAllocator(allocator: ptr bgfx_allocator_interface_t;
    size, align: csize_t): pointer
  {.importc: "bgfxim_test_call_allocator", cdecl.}
proc testTriggerFatal(callback: ptr bgfx_callback_interface_t): bool
  {.importc: "bgfxim_test_trigger_fatal", cdecl.}

var releaseCalled = false
var releasedData: pointer
var releasedUserData: pointer
var allocatorCalled = false
var fatalCalled = false

proc releaseCallback(data, userData: pointer) {.cdecl.} =
  releaseCalled = true
  releasedData = data
  releasedUserData = userData

proc rejectingRealloc(this: ptr bgfx_allocator_interface_t; old: pointer;
    size, align: csize_t; file: bgfx_const_char_ptr_t;
    line: uint32): pointer {.cdecl.} =
  doAssert this != nil
  doAssert old == nil
  doAssert size == high(csize_t)
  doAssert align == 64
  doAssert $file == "runtime_stub.c"
  doAssert line == high(uint32)
  allocatorCalled = true
  result = nil

proc fatalCallback(this: ptr bgfx_callback_interface_t;
    filePath: bgfx_const_char_ptr_t; line: uint16; code: bgfx_fatal_t;
    message: bgfx_const_char_ptr_t) {.cdecl.} =
  doAssert this != nil
  doAssert $filePath == "runtime_stub.c"
  doAssert line == high(uint16)
  doAssert code == BGFX_FATAL_INVALID_SHADER
  doAssert $message == "synthetic fatal path"
  fatalCalled = true

# Null and rejected initialization paths must preserve false exactly across FFI.
doAssert not BGFX.init(nil)
doAssert not testInitValidated()

var rejectedInit: bgfx_init_t
BGFX.initCtor(addr rejectedInit)
rejectedInit.vendorId = rejectedInit.vendorId xor 1'u16
doAssert not BGFX.init(addr rejectedInit)
doAssert not testInitValidated()

var init: bgfx_init_t
BGFX.initCtor(addr init)
doAssert BGFX.init(addr init)

# Count-only and null-output queries must not write through the output pointer.
var renderer = BGFX_RENDERER_TYPE_COUNT
doAssert BGFX.getSupportedRenderers(0'u8, addr renderer) == 1'u8
doAssert renderer == BGFX_RENDERER_TYPE_COUNT
doAssert BGFX.getSupportedRenderers(1'u8, nil) == 1'u8

# Version negotiation rejects every version other than the pinned API version.
doAssert BGFX.getInterface(BGFX_API_VERSION) != nil
doAssert BGFX.getInterface(BGFX_API_VERSION - 1'u32) == nil
doAssert BGFX.getInterface(BGFX_API_VERSION + 1'u32) == nil
doAssert BGFX.getInterface(high(uint32)) == nil

# Zero and all-bits-set values verify that flags are forwarded without narrowing.
BGFX.setDebug(0'u32)
doAssert testDebugFlags() == 0'u32
BGFX.setDebug(high(uint32))
doAssert testDebugFlags() == high(uint32)
discard BGFX.frame(high(uint8))
doAssert testFrameFlags() == high(uint8)

# Rejected vertex attributes must not modify the layout returned by begin.
var layout: bgfx_vertex_layout_t
discard BGFX.vertexLayoutBegin(addr layout, BGFX_RENDERER_TYPE_NOOP)
doAssert layout.stride == 4'u16
discard BGFX.vertexLayoutAdd(addr layout, BGFX_ATTRIB_COUNT, high(uint8),
  BGFX_ATTRIB_TYPE_COUNT, true, true)
doAssert layout.stride == 4'u16
discard BGFX.vertexLayoutAdd(addr layout, BGFX_ATTRIB_POSITION, 3'u8,
  BGFX_ATTRIB_TYPE_FLOAT, true, false)
doAssert layout.stride == 4'u16

# Invalid handles and memory allocation failures retain their sentinel values.
let invalidTexture = invalidHandle(bgfx_texture_handle_t)
doAssert invalidTexture.idx == high(uint16)
doAssert not BGFX_HANDLE_IS_VALID(invalidTexture)
let validTexture = bgfx_texture_handle_t(idx: 7'u16)
doAssert BGFX_HANDLE_IS_VALID(validTexture)

doAssert BGFX.alloc(0'u32) == nil
doAssert BGFX.alloc(65'u32) == nil
let allocation = BGFX.alloc(64'u32)
doAssert allocation != nil
doAssert allocation.size == 64'u32

var bytes = [0x00'u8, 0x7f'u8, 0x80'u8, 0xff'u8]
doAssert BGFX.copy(nil, uint32(bytes.len)) == nil
doAssert BGFX.copy(addr bytes[0], 0'u32) == nil
let copied = BGFX.copy(addr bytes[0], uint32(bytes.len))
doAssert copied != nil and copied.size == uint32(bytes.len)
let copiedBytes = cast[ptr UncheckedArray[uint8]](copied.data)
for index, value in bytes:
  doAssert copiedBytes[index] == value

# Release callbacks cover null rejection, user-data identity, and exactly-once use.
var releaseUserData = 0x12345678'u32
doAssert BGFX.makeRefRelease(nil, uint32(bytes.len), releaseCallback,
  addr releaseUserData) == nil
doAssert BGFX.makeRefRelease(addr bytes[0], uint32(bytes.len), nil,
  addr releaseUserData) == nil
let referenced = BGFX.makeRefRelease(addr bytes[0], uint32(bytes.len),
  releaseCallback, addr releaseUserData)
doAssert referenced != nil
doAssert testTriggerRelease()
doAssert releaseCalled
doAssert releasedData == addr bytes[0]
doAssert releasedUserData == addr releaseUserData
doAssert not testTriggerRelease()

# C-to-Nim callback dispatch preserves failure returns and boundary arguments.
doAssert testCallAllocator(nil, high(csize_t), 64) == nil
var allocatorVtable: bgfx_allocator_vtbl_t
var allocator: bgfx_allocator_interface_t
allocator.vtbl = addr allocatorVtable
doAssert testCallAllocator(addr allocator, high(csize_t), 64) == nil
doAssert not allocatorCalled
allocatorVtable.realloc = rejectingRealloc
doAssert testCallAllocator(addr allocator, high(csize_t), 64) == nil
doAssert allocatorCalled

doAssert not testTriggerFatal(nil)
var callbackVtable: bgfx_callback_vtbl_t
var callback: bgfx_callback_interface_t
callback.vtbl = addr callbackVtable
doAssert not testTriggerFatal(addr callback)
callbackVtable.fatal = fatalCallback
doAssert testTriggerFatal(addr callback)
doAssert fatalCalled

# Validation functions cover invalid enums, conflicting flags, null arrays,
# invalid handles, invalid video parameters, and a valid control case.
doAssert BGFX.isTextureValid(
  1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)
doAssert not BGFX.isTextureValid(
  1, false, 1, BGFX_TEXTURE_FORMAT_COUNT, BGFX_TEXTURE_NONE)
doAssert not BGFX.isTextureValid(
  2, true, 1, BGFX_TEXTURE_FORMAT_RGBA8, BGFX_TEXTURE_NONE)
doAssert not BGFX.isTextureValid(1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8,
  BGFX_TEXTURE_RT or BGFX_TEXTURE_READ_BACK)
doAssert not BGFX.isTextureValid(1, false, 1, BGFX_TEXTURE_FORMAT_RGBA8,
  BGFX_TEXTURE_COMPUTE_WRITE or BGFX_TEXTURE_READ_BACK)

var attachment: bgfx_attachment_t
attachment.handle = invalidHandle(bgfx_texture_handle_t)
doAssert not BGFX.isFrameBufferValid(0'u8, nil)
doAssert not BGFX.isFrameBufferValid(1'u8, nil)
doAssert not BGFX.isFrameBufferValid(1'u8, addr attachment)
attachment.handle = validTexture
doAssert BGFX.isFrameBufferValid(1'u8, addr attachment)

doAssert BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_H264, 0, 8, 1920, 1080, 4, 3)
doAssert not BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_COUNT, 0, 8, 1920, 1080, 4, 3)
doAssert not BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_H264, 1, 8, 1920, 1080, 4, 3)
doAssert not BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_H264, 0, 9, 1920, 1080, 4, 3)
doAssert not BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_H264, 0, 8, 0, 1080, 4, 3)
doAssert not BGFX.isVideoCodecValid(
  BGFX_VIDEO_CODEC_H264, 0, 8, 1920, 1080, 2, 3)

BGFX.shutdown()
echo "error and boundary FFI calls passed"
