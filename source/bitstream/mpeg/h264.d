
module bitstream.mpeg.h264;

const NAL_UNIT_TYPE_CODED_SLICE_IDR = 5;

ubyte get_nal_type(const ubyte[] nal)
{
    return nal[3] & 0x1f;
}