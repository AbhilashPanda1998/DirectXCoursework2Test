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

      // Apply random displacements to the vertex position
    float3 pos = input.pos;
    float3 random1 = normalize(float3(1.0f, 2.0f, 3.0f));
    float3 random2 = normalize(float3(4.0f, 5.0f, 6.0f));
    float3 random3 = normalize(float3(7.0f, 8.0f, 9.0f));
    float3 random4 = normalize(float3(10.0f, 11.0f, 12.0f));
    float3 random5 = normalize(float3(13.0f, 14.0f, 15.0f));
    float3 random6 = normalize(float3(16.0f, 17.0f, 18.0f));
    float3 random7 = normalize(float3(19.0f, 20.0f, 21.0f));
    float3 random8 = normalize(float3(22.0f, 23.0f, 24.0f));
    pos += 0.1f * sin(dot(random1, pos)) * random1;
    pos += 0.2f * sin(dot(random2, pos)) * random2;
    pos += 0.3f * sin(dot(random3, pos)) * random3;
    pos += 0.4f * sin(dot(random4, pos)) * random4;
    pos += 0.5f * sin(dot(random5, pos)) * random5;
    pos += 0.6f * sin(dot(random6, pos)) * random6;
    pos += 0.7f * sin(dot(random7, pos)) * random7;
    pos += 0.8f * sin(dot(random8, pos)) * random8;

    // Apply the model, view, and projection matrices
    output.pos = mul(float4(pos, 1.0f), model);
    output.pos = mul(output.pos, view);
    output.pos = mul(output.pos, projection);
    
    // Add additional transformations to create a complex shape
    

    output.pos.x += 8;
    output.pos.y += 2.5f;

    return output;
}
