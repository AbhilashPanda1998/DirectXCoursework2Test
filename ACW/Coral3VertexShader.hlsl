cbuffer ModelViewProjectionConstantBuffer : register(b0)
{
    matrix model;
    matrix view;
    matrix projection;
};

struct VertexShaderInput
{
    float3 pos : POSITION;
    float3 color : COLOR0;
};

cbuffer timeConstantBuffer : register(b1)
{
    float time;
    float3 padding;
}

struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float3 color : COLOR0;
};

PixelShaderInput main(VertexShaderInput input)
{
    PixelShaderInput output;
    output.color = input.color;
    float3 pos = input.pos;
    output.pos = mul(float4(pos, 1.0f), model);
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, projection);

    output.pos.x += 8;
    output.pos.y += 8.5f;

    return output;
}
