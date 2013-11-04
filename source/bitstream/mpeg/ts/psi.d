
module bitstream.mpeg.psi;

import std.array;
import std.bitmanip;
import std.exception;
import std.container;
import std.stdint;
//import bitstream.mpeg.ts.;

/*
uint16_t pat_program_get_program_number(ubyte[] p)
{
	return (p[0] << 8) | p[1];
}

uint16_t pat_program_get_pid(ubyte[] p)
{
	return ( (p[2] & 0x1f ) << 8) | p[3];
}

class Program
{
	uint16_t pmt_pid;
	uint16_t program_number;
}

struct PatSection
{

	static uint16_t section_length(ubyte[] s)
	{
		return (( (s[1] & 0x0f ) << 8 ) | s[2]);
	}

	static Program[] parse_programs(ubyte[] s)
	{
		Program[] programs;

		assert( s[0] == 0 );

		auto programs_section_end = 8 + section_length(s) - 9;

		for (size_t i = 8;
			 i < programs_section_end;
			 i += 4 )
		{
			auto off = s[i..i+4];
			auto p = new Program;
			p.pmt_pid = pat_program_get_pid(off);
			p.program_number = pat_program_get_program_number(off);
			programs ~= p ;
		}
		return programs;
	}

};

struct PmtSection
{

	immutable static PMT_HEADER_SIZE = 12;

	static uint16_t section_length(ubyte[] s)
	{
		return ( (s[1] & 0x0f ) << 8 ) | s[2];
	}

	static uint16_t program_info_length(ubyte[] s)
	{
		return ((s[10] & 0x0f ) << 8) | s[11];
	}


	static PmtStream[] parse_streams(ubyte[] s)
	{
		PmtStream[] streams;

		auto stream_data_start = 12 + program_info_length(s);

		//debug log("PmtStream section_length: %s", section_length(s));
		//debug log("PmtStream : program_info_length %s", program_info_length(s));

		auto stream_data_end = 12 + section_length(s) + 3 - PMT_HEADER_SIZE - 4;

		PmtStream *  stream = null;

		for (auto off = stream_data_start;
			 off < stream_data_end;
			 off += stream.length() )
		{
			stream = cast(PmtStream*) &s[off];

			enforce( stream.is_valid(), "PmtSection: stream is not valid" );

			streams ~= *stream;
		}
		return streams;
	}

	unittest
	{

	}

};

class Pat
{
	private TsPacket[] _packets;

	public Program[] programs;

	this(Program[] p, TsPacket[] packets)
	{
		programs = p;
		_packets = packets.dup;
	}

	bool is_pmt_pid(uint16_t pid)
	{
		foreach(p;programs)
		{
			if( p.pmt_pid == pid )
			{
				return true;
			}
		}

		return false;
	}

	@property const(TsPacket[]) packets() const
	{
		return _packets;
	}

}

class PatBuilder
{
	TsPacket[] _packets;
public:
	void add_packet(TsPacket pkt)
	{
		_packets ~= pkt;
	}

	Pat build()
	{
		while( _packets.length > 0 && ! _packets[0].ts_get_unitstart() )
		{
			_packets = _packets[1..$];
		}

		if( _packets.length == 0 )
		{
			return null;
		}

		auto pkt = _packets[0];

		auto section = ts_section(pkt);

		return new Pat(PatSection.parse_programs(section), _packets );
	}
}

struct PmtStream
{
public:

	uint8_t stream_type() const
	{
		return _stream_type;
	}

	uint16_t elementary_pid() const
	{
		return (elementary_pid1 << 8) | elementary_pid2;
	}

	uint16_t es_info_length() const
	{
		return (es_info_length1 << 8) | es_info_length2;
	}

	uint16_t length() const
	{
		return cast(uint16_t)(es_info_length() + cast(uint16_t)PmtStream.sizeof);
	}
	bool is_valid() const
	{
		return ( (es_info_length1 & 0x0c ) == 0 ) ;
	}
private:
	uint8_t _stream_type;

	mixin( bitfields!(
		ubyte, "elementary_pid1", 5,
		ubyte, "reserved1", 3
	));

	//uint8_t elementary_pid1 :5;
	//uint8_t reserved1 :3;

	uint8_t elementary_pid2;

	mixin( bitfields!(
		ubyte, "es_info_length1", 4,
		ubyte, "reserved2", 4
	));
	//uint8_t es_info_length1 :4;
	//uint8_t reserved2 :4;

	uint8_t es_info_length2;
}

class Pmt
{
	this( TsPacket[] pkts, PmtStream[] streams, uint16_t pcr_pid )
	{
		_packets = pkts;
		_streams = streams;
		_pcr_pid = pcr_pid;
	}

	TsPacket[] _packets;
	PmtStream[] _streams;
	uint16_t _pcr_pid;
public:
	@property const(PmtStream[]) streams() const
	{
		return cast(const(PmtStream[]))_streams;
	}

	@property const(TsPacket[]) packets() const
	{
		return _packets;
	}

	//uint16_t get_pcr_pid() const;
}

class PmtBuilder
{
	TsPacket[] _packets;
public:
	void add_packet(TsPacket pkt)
	{
		_packets ~= pkt;
	}

	Pmt build()
	{
		while( _packets.length > 0 && ! ts_get_unitstart(_packets[0]) )
		{
			_packets = _packets[1..$];
		}

		if( _packets.length == 0 )
		{
			return null;
		}

		auto pkt = _packets[0];

		auto section = ts_section(pkt);

		return new Pmt(_packets, PmtSection.parse_streams(section), 0 );
	}
}

*/
