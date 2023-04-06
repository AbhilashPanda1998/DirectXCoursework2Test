cbuffer ModelViewProjectionConstantBuffer : register(b0)
{
    matrix model;
    matrix view;
    matrix projection;
};

struct GeometryShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
};

struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
    float2 uv : TEXCOORD0;
};

struct GSOutput
{
    float4 pos : SV_POSITION;
};

[maxvertexcount(9)]
void main(triangle GeometryShaderInput input[3], inout
	TriangleStream<PixelShaderInput> OutputStream
)
{
    PixelShaderInput output = (PixelShaderInput) 0;

    for (uint i = 0; i < 3; i++)
    {
        output.pos = input[i].pos;
        output.pos.xyz *= 0.5;

        output.pos = mul(output.pos, model);
        output.pos = mul(output.pos, view);
        output.pos = mul(output.pos, projection);


        output.color = input[i].color;
        output.uv = (sign(input[i].pos.xy) + 1.0) / 2.0;

        OutputStream.Append(output);
    }
    OutputStream.RestartStrip();

    for (uint i = 0; i < 3; i++)
    {
        output.pos = input[i].pos;
        output.pos.xyz *= 0.5;
        output.pos.x += 0.8;

        output.pos = mul(output.pos, model);
        output.pos = mul(output.pos, view);
        output.pos = mul(output.pos, projection);


        output.color = input[i].color;
        output.uv = (sign(input[i].pos.xy) + 1.0) / 2.0;

        OutputStream.Append(output);
    }
    OutputStream.RestartStrip();

    for (uint i = 0; i < 3; i++)
    {
        output.pos = input[i].pos;
        output.pos.xyz *= 0.5;
        output.pos.x -= 0.8;

        output.pos = mul(output.pos, model);
        output.pos = mul(output.pos, view);
        output.pos = mul(output.pos, projection);


        output.color = input[i].color;
        output.uv = (sign(input[i].pos.xy) + 1.0) / 2.0;

        OutputStream.Append(output);
    }
    OutputStream.RestartStrip();
}

